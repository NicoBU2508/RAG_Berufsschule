// Rendert einzelne PDF-Seiten als PNG (lokal, ohne externe Dienste).
// Wird von vault_lookup.rb `render` automatisch nach /tmp kompiliert:
//   clang -fobjc-arc -framework Foundation -framework AppKit -framework PDFKit render_pdf_page.m -o <bin>
// Aufruf: render_pdf_page <pdf> <ausgabe-ordner> <seiten,komma,getrennt> [breite]
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <PDFKit/PDFKit.h>

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        if (argc < 4) {
            fprintf(stderr, "usage: render_pdf_page <pdf> <out-dir> <pages> [width]\n");
            return 1;
        }
        NSString *pdfPath = [NSString stringWithUTF8String:argv[1]];
        NSString *outDir = [NSString stringWithUTF8String:argv[2]];
        NSString *spec = [NSString stringWithUTF8String:argv[3]];
        CGFloat width = argc >= 5 ? MAX(400.0, atof(argv[4])) : 1400.0;

        [[NSFileManager defaultManager] createDirectoryAtPath:outDir withIntermediateDirectories:YES attributes:nil error:nil];
        PDFDocument *doc = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:pdfPath]];
        if (!doc || doc.isLocked) {
            fprintf(stderr, "PDF nicht lesbar: %s\n", argv[1]);
            return 2;
        }
        for (NSString *part in [spec componentsSeparatedByString:@","]) {
            NSInteger p = [part integerValue];
            if (p < 1 || p > (NSInteger)doc.pageCount) continue;
            PDFPage *page = [doc pageAtIndex:p - 1];
            NSRect b = [page boundsForBox:kPDFDisplayBoxMediaBox];
            if (page.rotation % 180 != 0) b = NSMakeRect(0, 0, b.size.height, b.size.width);
            CGFloat h = MAX(1.0, (width / MAX(1.0, b.size.width)) * b.size.height);
            NSImage *thumb = [page thumbnailOfSize:NSMakeSize(width, h) forBox:kPDFDisplayBoxMediaBox];
            NSImage *canvas = [[NSImage alloc] initWithSize:thumb.size];
            [canvas lockFocus];
            [[NSColor whiteColor] setFill];
            NSRectFill(NSMakeRect(0, 0, thumb.size.width, thumb.size.height));
            [thumb drawInRect:NSMakeRect(0, 0, thumb.size.width, thumb.size.height)];
            [canvas unlockFocus];
            NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:[canvas TIFFRepresentation]];
            NSData *png = [rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
            NSString *outFile = [outDir stringByAppendingPathComponent:[NSString stringWithFormat:@"p%ld.png", (long)p]];
            if (![png writeToFile:outFile atomically:YES]) {
                fprintf(stderr, "PNG nicht schreibbar: %s\n", outFile.UTF8String);
                return 3;
            }
            printf("%s\n", outFile.UTF8String);
        }
    }
    return 0;
}
