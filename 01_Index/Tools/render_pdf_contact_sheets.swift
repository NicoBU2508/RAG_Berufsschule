import AppKit
import Foundation
import PDFKit

struct SheetRecord: Encodable {
    let path: String
    let firstPage: Int
    let lastPage: Int
}

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data((message + "\n").utf8))
    exit(1)
}

let arguments = Array(CommandLine.arguments.dropFirst())
guard arguments.count >= 2 else {
    fail("usage: swift render_pdf_contact_sheets.swift <pdf> <output-dir> [pages-per-sheet] [columns] [page-width]")
}

let pdfPath = arguments[0]
let outputPath = arguments[1]
let pagesPerSheet = max(Int(arguments[safe: 2] ?? "4") ?? 4, 1)
let columns = max(Int(arguments[safe: 3] ?? "2") ?? 2, 1)
let pageWidth = max(CGFloat(Double(arguments[safe: 4] ?? "1200") ?? 1200), 300)
let rows = Int(ceil(Double(pagesPerSheet) / Double(columns)))
let labelHeight: CGFloat = 42
let margin: CGFloat = 24
let requestedHeight = pageWidth * 1.45
let cellWidth = pageWidth + margin
let cellHeight = requestedHeight + labelHeight + margin
let canvasSize = NSSize(
    width: CGFloat(columns) * cellWidth + margin,
    height: CGFloat(rows) * cellHeight + margin
)

let pdfURL = URL(fileURLWithPath: pdfPath)
guard let document = PDFDocument(url: pdfURL) else {
    fail("could not open PDF: \(pdfPath)")
}

do {
    try FileManager.default.createDirectory(
        at: URL(fileURLWithPath: outputPath),
        withIntermediateDirectories: true
    )
} catch {
    fail("could not create output directory: \(error)")
}

let paragraphStyle = NSMutableParagraphStyle()
paragraphStyle.alignment = .left
let labelAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.monospacedSystemFont(ofSize: 24, weight: .semibold),
    .foregroundColor: NSColor.black,
    .paragraphStyle: paragraphStyle
]

var records: [SheetRecord] = []

for chunkStart in stride(from: 0, to: document.pageCount, by: pagesPerSheet) {
    let chunkEnd = min(chunkStart + pagesPerSheet, document.pageCount)
    let canvas = NSImage(size: canvasSize)
    canvas.lockFocus()
    NSColor.white.setFill()
    NSRect(origin: .zero, size: canvasSize).fill()

    for pageIndex in chunkStart..<chunkEnd {
        guard let page = document.page(at: pageIndex) else { continue }
        let offset = pageIndex - chunkStart
        let row = offset / columns
        let column = offset % columns
        let x = margin + CGFloat(column) * cellWidth
        let top = canvasSize.height - margin - CGFloat(row) * cellHeight
        let label = "PDF page \(pageIndex + 1)"
        label.draw(
            in: NSRect(x: x, y: top - labelHeight, width: pageWidth, height: labelHeight),
            withAttributes: labelAttributes
        )

        let thumbnail = page.thumbnail(
            of: NSSize(width: pageWidth, height: requestedHeight),
            for: .mediaBox
        )
        let thumbSize = thumbnail.size
        let scale = min(pageWidth / max(thumbSize.width, 1), requestedHeight / max(thumbSize.height, 1))
        let drawSize = NSSize(width: thumbSize.width * scale, height: thumbSize.height * scale)
        let drawRect = NSRect(
            x: x + (pageWidth - drawSize.width) / 2,
            y: top - labelHeight - drawSize.height,
            width: drawSize.width,
            height: drawSize.height
        )
        thumbnail.draw(in: drawRect)
        NSColor.lightGray.setStroke()
        drawRect.frame(withWidth: 1)
    }

    canvas.unlockFocus()
    guard
        let tiff = canvas.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let png = bitmap.representation(using: .png, properties: [:])
    else {
        fail("could not encode contact sheet beginning at page \(chunkStart + 1)")
    }

    let filename = String(format: "sheet_%04d-%04d.png", chunkStart + 1, chunkEnd)
    let target = URL(fileURLWithPath: outputPath).appendingPathComponent(filename)
    do {
        try png.write(to: target, options: .atomic)
    } catch {
        fail("could not write \(target.path): \(error)")
    }
    records.append(SheetRecord(path: target.path, firstPage: chunkStart + 1, lastPage: chunkEnd))
}

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
let data = try encoder.encode(records)
FileHandle.standardOutput.write(data)
FileHandle.standardOutput.write(Data("\n".utf8))

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
