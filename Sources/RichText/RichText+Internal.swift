import SwiftSCAD
import AppKit

internal extension RichText {
    func textOffset(in environment: Environment, contentHeight: CGFloat, firstBaseline: CGFloat, lastBaseline: CGFloat) -> Vector2D {
        var offset = Vector2D.zero
        let boxHeight = layout.containerHeight ?? contentHeight

        offset.y = switch environment.verticalTextAlignment ?? .baseline {
        case .bottom: contentHeight
        case .center: (boxHeight + contentHeight) / 2.0
        case .baseline: environment.baselineAlignment == .last ? lastBaseline : firstBaseline
        default: boxHeight
        }

        if case .free = layout {
            offset.x = -(environment.horizontalTextAlignment ?? .left).offsetFactor * layout.textContainerSize.width
        }

        return offset
    }

    func layoutData(environment: Environment) -> (NSLayoutManager, NSTextStorage, [NSLayoutManager.LineFragment], AffineTransform2D)? {
        let attributedString = effectiveAttributedString(in: environment)
        let textStorage = NSTextStorage(attributedString: .init(attributedString))

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: layout.textContainerSize)
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
        layoutManager.textStorage = textStorage

        let glyphRange = layoutManager.glyphRange(for: textContainer)
        guard glyphRange.length > 0 else {
            return nil
        }

        let fragments = layoutManager.lineFragments(for: textContainer)

        let offset = textOffset(
            in: environment,
            contentHeight: fragments.last?.rect.maxY ?? 0,
            firstBaseline: fragments.first?.baseline(in: layoutManager) ?? 0,
            lastBaseline: fragments.last?.baseline(in: layoutManager) ?? 0
        )

        let transform = AffineTransform2D.scaling(y: -1).translated(offset)
        return (layoutManager, textStorage, fragments, transform)
    }

    func effectiveAttributedString(in environment: Environment) -> AttributedString {
        text.mergingAttributes(environment.richTextAttributes, mergePolicy: .keepCurrent)
    }

    func lineFragments(in environment: Environment) -> [LineFragment] {
        guard let (layoutManager, textStorage, fragments, transform) = layoutData(environment: environment) else {
            return []
        }

        return fragments.compactMap { fragment -> LineFragment? in
            let origin = Vector2D(fragment.rect.origin)

            let glyphs = fragment.glyphRange.compactMap { glyphIndex -> LineFragment.Glyph? in
                layoutManager.glyph(in: textStorage, at: glyphIndex).map { path, location, stringRange in
                    let globalLocation = transform.apply(to: origin + Vector2D(location))
                    return LineFragment.Glyph(shape: path, location: globalLocation, stringRange: stringRange)
                }
            }

            guard let start = glyphs.map(\.stringRange.lowerBound).min(),
                  let end = glyphs.map(\.stringRange.upperBound).max() else{
                return nil
            }

            return LineFragment(
                origin: transform.apply(to: origin),
                glyphBox: fragment.usedRect.boundingBox2D.transformed(transform),
                glyphs: glyphs,
                stringRange: start..<end
            )
        }
    }
}

extension Text.HorizontalAlignment {
    var offsetFactor: Double {
        switch self {
        case .left: 0.0
        case .center: 0.5
        case .right: 1.0
        }
    }
}
