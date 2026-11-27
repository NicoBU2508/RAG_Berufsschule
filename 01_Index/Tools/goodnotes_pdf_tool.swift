// Hilfswerkzeug für den GoodNotes-Import.
//
//   goodnotes_pdf_tool info <pdf>
//   goodnotes_pdf_tool extract <pdf> <bild-ordner> [erste-seite]
//   goodnotes_pdf_tool fingerprint <pdf>
//
// extract rendert jede Seite als PNG (für die visuelle Prüfung), liest die
// eingebettete Textschicht und führt zusätzlich eine lokale Vision-OCR
// (de-DE, en-US) aus. Es werden keine Daten an externe Dienste gesendet.

import AppKit
import Foundation
import PDFKit
import Vision

struct PageRecord: Encodable {
    let page: Int
    let image: String
    let textLayer: String
    let ocrText: String
    let ocrConfidence: Double
    let ocrError: String?
}

struct ExtractResult: Encodable {
    let pdf: String
    let pageCount: Int
    let pages: [PageRecord]
}

struct FingerprintResult: Encodable {
    let pdf: String
    let pageCount: Int
    let fingerprints: [String]
}

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data((message + "\n").utf8))
    exit(1)
}

func openDocument(_ path: String) -> PDFDocument {
    guard let document = PDFDocument(url: URL(fileURLWithPath: path)) else {
        fail("PDF konnte nicht geöffnet werden: \(path)")
    }
    if document.isLocked { fail("PDF ist passwortgeschützt: \(path)") }
    return document
}

func renderedSize(_ page: PDFPage, width: CGFloat) -> NSSize {
    var bounds = page.bounds(for: .mediaBox)
    if page.rotation % 180 != 0 { bounds = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width) }
    let scale = width / max(bounds.width, 1)
    return NSSize(width: width, height: max(bounds.height * scale, 1))
}

func render(_ page: PDFPage, width: CGFloat) -> CGImage? {
    let size = renderedSize(page, width: width)
    let thumbnail = page.thumbnail(of: size, for: .mediaBox)
    var rect = CGRect(origin: .zero, size: thumbnail.size)
    guard let image = thumbnail.cgImage(forProposedRect: &rect, context: nil, hints: nil) else { return nil }
    // Auf weißen Hintergrund legen, damit transparente Bereiche lesbar bleiben.
    let w = image.width, h = image.height
    guard let context = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0,
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return image }
    context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: w, height: h))
    context.draw(image, in: CGRect(x: 0, y: 0, width: w, height: h))
    return context.makeImage() ?? image
}

func downscaleCGImage(_ image: CGImage, width: Int) -> CGImage? {
    let targetW = max(width, 1)
    let ratio = Double(targetW) / Double(image.width)
    let targetH = max(Int((Double(image.height) * ratio).rounded()), 1)
    guard let cs = CGColorSpace(name: CGColorSpace.sRGB),
          let ctx = CGContext(data: nil, width: targetW, height: targetH, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
        return nil
    }
    ctx.interpolationQuality = .high
    ctx.draw(image, in: CGRect(x: 0, y: 0, width: targetW, height: targetH))
    return ctx.makeImage()
}

func writePNG(_ image: CGImage, to path: String) {
    let rep = NSBitmapImageRep(cgImage: image)
    guard let data = rep.representation(using: .png, properties: [:]) else { fail("PNG-Export fehlgeschlagen: \(path)") }
    do { try data.write(to: URL(fileURLWithPath: path)) } catch { fail("PNG nicht schreibbar: \(path): \(error)") }
}

func recognize(_ image: CGImage) -> (String, Double, String?) {
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["de-DE", "en-US"]
    request.usesLanguageCorrection = true
    let handler = VNImageRequestHandler(cgImage: image, options: [:])
    do {
        try handler.perform([request])
        let candidates = (request.results ?? []).compactMap { $0.topCandidates(1).first }
        let text = candidates.map { $0.string }.joined(separator: "\n")
        let confidence = candidates.isEmpty ? 0 : candidates.map { Double($0.confidence) }.reduce(0, +) / Double(candidates.count)
        return (text, (confidence * 1000).rounded() / 1000, nil)
    } catch {
        return ("", 0, String(describing: error))
    }
}

func fingerprint(_ page: PDFPage) -> String {
    let side = 32
    guard let image = render(page, width: 256),
          let context = CGContext(data: nil, width: side, height: side, bitsPerComponent: 8, bytesPerRow: side,
                                  space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
        return ""
    }
    context.interpolationQuality = .medium
    context.draw(image, in: CGRect(x: 0, y: 0, width: side, height: side))
    guard let data = context.data else { return "" }
    let bytes = data.bindMemory(to: UInt8.self, capacity: side * side)
    return (0..<(side * side)).map { String(format: "%02x", bytes[$0]) }.joined()
}

func emit<T: Encodable>(_ value: T) {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    guard let data = try? encoder.encode(value) else { fail("JSON-Ausgabe fehlgeschlagen") }
    FileHandle.standardOutput.write(data)
    FileHandle.standardOutput.write(Data("\n".utf8))
}

let arguments = Array(CommandLine.arguments.dropFirst())
guard let command = arguments.first, arguments.count >= 2 else {
    fail("usage: goodnotes_pdf_tool info|extract|fingerprint <pdf> [bild-ordner] [erste-seite]")
}
let pdfPath = arguments[1]
let document = openDocument(pdfPath)

switch command {
case "info":
    emit(FingerprintResult(pdf: pdfPath, pageCount: document.pageCount, fingerprints: []))
case "fingerprint":
    let prints = (0..<document.pageCount).map { index -> String in
        guard let page = document.page(at: index) else { return "" }
        return fingerprint(page)
    }
    emit(FingerprintResult(pdf: pdfPath, pageCount: document.pageCount, fingerprints: prints))
case "extract":
    guard arguments.count >= 3 else { fail("extract benötigt einen Bild-Ordner") }
    let outputDirectory = arguments[2]
    let firstPage = max(Int(arguments.count >= 4 ? arguments[3] : "1") ?? 1, 1)
    do {
        try FileManager.default.createDirectory(atPath: outputDirectory, withIntermediateDirectories: true)
    } catch { fail("Bild-Ordner nicht anlegbar: \(error)") }
    var records: [PageRecord] = []
    if firstPage <= document.pageCount {
        let indices = Array((firstPage - 1)..<document.pageCount)
        var slots = Array<PageRecord?>(repeating: nil, count: indices.count)
        let lock = NSLock()
        DispatchQueue.concurrentPerform(iterations: indices.count) { pos in
            let index = indices[pos]
            guard let localDoc = PDFDocument(url: URL(fileURLWithPath: pdfPath)),
                  let page = localDoc.page(at: index) else { return }
            let number = index + 1
            let imagePath = (outputDirectory as NSString).appendingPathComponent(String(format: "seite-%03d.png", number))
            guard let ocrImage = render(page, width: 2200) else { fail("Seite \(number) nicht renderbar") }
            let reviewImage = downscaleCGImage(ocrImage, width: 1500) ?? ocrImage
            writePNG(reviewImage, to: imagePath)
            let (ocrText, confidence, ocrError) = recognize(ocrImage)
            let layer = (page.string ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let rec = PageRecord(page: number, image: imagePath, textLayer: layer, ocrText: ocrText, ocrConfidence: confidence, ocrError: ocrError)
            lock.lock()
            slots[pos] = rec
            lock.unlock()
        }
        records = slots.compactMap { $0 }
    }
    emit(ExtractResult(pdf: pdfPath, pageCount: document.pageCount, pages: records))
default:
    fail("Unbekannter Befehl: \(command)")
}
