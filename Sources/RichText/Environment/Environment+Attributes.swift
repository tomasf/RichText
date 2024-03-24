import Foundation
import SwiftSCAD
import AppKit

internal extension Environment {
    var nsFont: NSFont {
        let family = self.fontName ?? "Helvetica"

        var descriptor = NSFontDescriptor().withFamily(family)
        if let fontStyle {
            descriptor = descriptor.withFace(fontStyle)
        }

        if let font = NSFont(descriptor: descriptor, size: fontSize ?? 10) {
            return font
        } else {
            logger.warning("Failed to find font \"\(family)\", style \(fontStyle ?? "-"). Using default.")
            return .userFont(ofSize: fontSize ?? 0) ?? .systemFont(ofSize: fontSize ?? 0)
        }
    }

    var richTextAttributes: AttributeContainer {
        let paragraphStyle = NSMutableParagraphStyle()
        if let horizontalTextAlignment {
            paragraphStyle.alignment = horizontalTextAlignment.nsTextAlignment
        }

        var attributes = AttributeContainer([
            .font: nsFont,
            .paragraphStyle: paragraphStyle
        ])

        if let characterSpacing {
            // Very rough approximation. Use kerning directly for more precision
            attributes.kern = (characterSpacing - 1.0) * nsFont.pointSize * 0.5
        }

        attributes.merge(textAttributeContainer, mergePolicy: .keepNew)
        return attributes

    }
}
