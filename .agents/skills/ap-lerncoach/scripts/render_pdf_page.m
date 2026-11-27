// Rendert einzelne PDF-Seiten als PNG (lokal, ohne externe Dienste) mit 1x CoreGraphics & mtime-Cache.
// Wird von vault_lookup.rb `render` automatisch nach /tmp kompiliert:
//   clang -O2 -fobjc-arc -framework Foundation -framework CoreGraphics -framework ImageIO -framework PDFKit render_pdf_page.m -o <bin>
// Aufruf: render_pdf_page <pdf> <ausgabe-ordner> <seiten,komma,getrennt> [breite] [slug]
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <PDFKit/PDFKit.h>
#import <sys/stat.h>

static NSString *sanitizeSlug(NSString *raw) {
    NSMutableString *out = [NSMutableString stringWithCapacity:raw.length];
    for (NSUInteger i = 0; i < raw.length; i++) {
        unichar c = [raw characterAtIndex:i];
        if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' || c == '-') {
            [out appendFormat:@"%C", c];
        } else {
            [out appendString:@"_"];
        }
    }
    return out.length > 0 ? out : @"pdf";
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        if (argc < 4) {
            fprintf(stderr, "usage: render_pdf_page <pdf> <out-dir> <pages> [width] [slug]\n");
            return 1;
        }
        NSString *pdfPath = [NSString stringWithUTF8String:argv[1]];
        NSString *outDir = [NSString stringWithUTF8String:argv[2]];
        NSString *spec = [NSString stringWithUTF8String:argv[3]];
        NSInteger widthPx = argc >= 5 ? MAX(400, atoi(argv[4])) : 1500;
        NSString *rawSlug = argc >= 6 ? [NSString stringWithUTF8String:argv[5]]
                                      : [[pdfPath lastPathComponent] stringByDeletingPathExtension];
        NSString *slug = sanitizeSlug(rawSlug);

        struct stat pdfStat;
        if (stat(pdfPath.UTF8String, &pdfStat) != 0) {
            fprintf(stderr, "PDF nicht gefunden: %s\n", argv[1]);
            return 2;
        }

        [[NSFileManager defaultManager] createDirectoryAtPath:outDir withIntermediateDirectories:YES attributes:nil error:nil];

        NSMutableArray<NSNumber *> *pages = [NSMutableArray array];
        for (NSString *part in [spec componentsSeparatedByString:@","]) {
            NSInteger p = [part integerValue];
            if (p >= 1) [pages addObject:@(p)];
        }
        if (pages.count == 0) return 0;

        // Pruefe Cache vor dem Oeffnen von PDFDocument
        NSMutableArray<NSNumber *> *missingPages = [NSMutableArray array];
        NSMutableDictionary<NSNumber *, NSString *> *outFiles = [NSMutableDictionary dictionary];
        for (NSNumber *pNum in pages) {
            NSString *outFile = [outDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@_p%ld_w%ld.png", slug, (long)pNum.integerValue, (long)widthPx]];
            outFiles[pNum] = outFile;
            struct stat pngStat;
            if (stat(outFile.UTF8String, &pngStat) == 0 && pngStat.st_size > 0 && pngStat.st_mtime >= pdfStat.st_mtime) {
                continue;
            }
            [missingPages addObject:pNum];
        }

        if (missingPages.count > 0) {
            PDFDocument *doc = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:pdfPath]];
            if (!doc || doc.isLocked) {
                fprintf(stderr, "PDF nicht lesbar: %s\n", argv[1]);
                return 2;
            }
            CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
            for (NSNumber *pNum in missingPages) {
                NSInteger p = pNum.integerValue;
                if (p < 1 || p > (NSInteger)doc.pageCount) continue;
                PDFPage *page = [doc pageAtIndex:p - 1];
                CGRect box = [page boundsForBox:kPDFDisplayBoxMediaBox];
                NSInteger rot = page.rotation % 360;
                if (rot < 0) rot += 360;
                CGFloat rotW = (rot == 90 || rot == 270) ? box.size.height : box.size.width;
                CGFloat rotH = (rot == 90 || rot == 270) ? box.size.width : box.size.height;
                if (rotW < 1.0 || rotH < 1.0) continue;

                NSInteger heightPx = MAX(1, (NSInteger)llround(((CGFloat)widthPx / rotW) * rotH));
                CGContextRef ctx = CGBitmapContextCreate(
                    NULL, (size_t)widthPx, (size_t)heightPx, 8, (size_t)widthPx * 4, cs,
                    (CGBitmapInfo)(kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big)
                );
                if (!ctx) continue;

                CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
                CGContextFillRect(ctx, CGRectMake(0, 0, (CGFloat)widthPx, (CGFloat)heightPx));

                CGFloat scale = (CGFloat)widthPx / rotW;
                CGContextSaveGState(ctx);
                CGContextScaleCTM(ctx, scale, scale);
                [page drawWithBox:kPDFDisplayBoxMediaBox toContext:ctx];
                CGContextRestoreGState(ctx);

                CGImageRef cgImg = CGBitmapContextCreateImage(ctx);
                CGContextRelease(ctx);
                if (!cgImg) continue;

                NSString *outFile = outFiles[pNum];
                NSURL *outURL = [NSURL fileURLWithPath:outFile];
                CGImageDestinationRef dest = CGImageDestinationCreateWithURL((__bridge CFURLRef)outURL, CFSTR("public.png"), 1, NULL);
                if (!dest) {
                    CGImageRelease(cgImg);
                    fprintf(stderr, "PNG nicht schreibbar: %s\n", outFile.UTF8String);
                    CGColorSpaceRelease(cs);
                    return 3;
                }
                CGImageDestinationAddImage(dest, cgImg, NULL);
                BOOL ok = CGImageDestinationFinalize(dest);
                CFRelease(dest);
                CGImageRelease(cgImg);
                if (!ok) {
                    fprintf(stderr, "PNG-Finalisierung fehlgeschlagen: %s\n", outFile.UTF8String);
                    CGColorSpaceRelease(cs);
                    return 3;
                }
            }
            CGColorSpaceRelease(cs);
        }

        for (NSNumber *pNum in pages) {
            NSString *outFile = outFiles[pNum];
            if (outFile && [[NSFileManager defaultManager] fileExistsAtPath:outFile]) {
                printf("%s\n", outFile.UTF8String);
            }
        }
    }
    return 0;
}
