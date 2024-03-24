import Foundation
import AppKit

internal extension NSLayoutManager {
    struct LineFragment {
        let glyphRange: Range<Int>
        let rect: CGRect
        let usedRect: CGRect

        func baseline(in layoutManager: NSLayoutManager) -> CGFloat {
            let offset = layoutManager.typesetter.baselineOffset(in: layoutManager, glyphIndex: glyphRange.lowerBound)
            return rect.maxY - offset
        }
    }

    func lineFragments(for textContainer: NSTextContainer) -> [LineFragment] {
        var fragments: [LineFragment] = []
        enumerateLineFragments(forGlyphRange: glyphRange(for: textContainer)) { rect, usedRect, textContainer, glyphRange, _ in
            guard let range = Range(glyphRange) else {
                assertionFailure("Invalid glyph range")
                return
            }
            fragments.append(.init(glyphRange: range, rect: rect, usedRect: usedRect))
        }
        return fragments
    }

    func glyph(in storage: NSTextStorage, at glyphIndex: Int) -> (CGPath, CGPoint, Range<String.Index>)? {
        let range = characterRange(forGlyphRange: NSMakeRange(glyphIndex, 1), actualGlyphRange: nil)
        let stringRange = Range(range, in: storage.string)
        let glyph = cgGlyph(at: glyphIndex)

        guard notShownAttribute(forGlyphAt: glyphIndex) == false,
              let stringRange,
              let font = storage.attribute(.font, at: range.location, effectiveRange: nil) as? NSFont,
              let path = CTFontCreatePathForGlyph(font, glyph, nil) else {
            return nil
        }

        return (path, location(forGlyphAt: glyphIndex), stringRange)
    }
}
