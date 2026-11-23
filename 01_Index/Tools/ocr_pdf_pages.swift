import AppKit
import Foundation
import PDFKit
import Vision

struct OCRResult: Encodable {
    let pdf: String
    let page: Int
    let text: String
}

func stderr(_ message: String) {
    FileHandle.standardError.write(Data((message + "\n").utf8))
}

func recognize(_ image: CGImage) throws -> String {
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["de-DE", "en-US"]
    request.usesLanguageCorrection = true
    let handler = VNImageRequestHandler(cgImage: image, options: [:])
    try handler.perform([request])
    let observations = request.results ?? []
    return observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
}

let args = CommandLine.arguments.dropFirst()
guard args.count >= 2 else {
    stderr("usage: swift ocr_pdf_pages.swift <pdf> <page> [<page> ...]")
    exit(2)
}

let pdfPath = String(args.first!)
let pageNumbers = args.dropFirst().compactMap { Int($0) }
guard !pageNumbers.isEmpty else {
    stderr("no valid page numbers")
    exit(2)
}

let url = URL(fileURLWithPath: pdfPath)
if ["png", "jpg", "jpeg", "tiff"].contains(url.pathExtension.lowercased()) {
    guard let image = NSImage(contentsOf: url) else {
        stderr("could not open image: \(pdfPath)")
        exit(1)
    }
    var imageRect = NSRect(origin: .zero, size: image.size)
    guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
        stderr("could not render image: \(pdfPath)")
        exit(1)
    }
    let text: String
    do {
        text = try recognize(cgImage)
    } catch {
        stderr("vision error for \(pdfPath): \(error)")
        text = ""
    }
    let data = try JSONEncoder().encode([OCRResult(pdf: pdfPath, page: pageNumbers.first ?? 1, text: text)])
    FileHandle.standardOutput.write(data)
    FileHandle.standardOutput.write(Data("\n".utf8))
    exit(0)
}

guard let document = PDFDocument(url: url) else {
    stderr("could not open PDF: \(pdfPath)")
    exit(1)
}

var results: [OCRResult] = []

for pageNumber in pageNumbers {
    let index = pageNumber - 1
    guard let page = document.page(at: index) else {
        results.append(OCRResult(pdf: pdfPath, page: pageNumber, text: ""))
        continue
    }

    let directText = page.string?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if !directText.isEmpty {
        results.append(OCRResult(pdf: pdfPath, page: pageNumber, text: directText))
        continue
    }

    let bounds = page.bounds(for: .mediaBox)
    let scale: CGFloat = 3.0
    let width = max(Int(bounds.width * scale), 1)
    let height = max(Int(bounds.height * scale), 1)
    let image = page.thumbnail(of: NSSize(width: width, height: height), for: .mediaBox)

    var imageRect = NSRect(origin: .zero, size: image.size)
    guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
        results.append(OCRResult(pdf: pdfPath, page: pageNumber, text: ""))
        continue
    }

    let text: String
    do {
        text = try recognize(cgImage)
    } catch {
        stderr("vision error for \(pdfPath) page \(pageNumber): \(error)")
        text = ""
    }
    results.append(OCRResult(pdf: pdfPath, page: pageNumber, text: text))
}

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
let data = try encoder.encode(results)
FileHandle.standardOutput.write(data)
FileHandle.standardOutput.write(Data("\n".utf8))
