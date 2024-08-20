import Foundation
import AppKit
import SwiftSCAD

internal extension Vector2D {
    init(_ cgPoint: CGPoint) {
        self.init(cgPoint.x, cgPoint.y)
    }

    init(_ cgSize: CGSize) {
        self.init(cgSize.width, cgSize.height)
    }
}

internal extension Color {
    init(_ nsColor: NSColor) {
        guard let rgb = nsColor.usingColorSpace(.deviceRGB) else {
            self = .black
            return
        }
        self = .init(
            red: rgb.redComponent,
            green: rgb.greenComponent,
            blue: rgb.blueComponent,
            alpha: rgb.alphaComponent
        )
    }
}

internal extension Text.HorizontalAlignment {
    var nsTextAlignment: NSTextAlignment {
        switch self {
        case .left: .left
        case .center: .center
        case .right: .right
        }
    }
}

internal extension CGRect {
    var boundingBox2D: BoundingBox2D {
        .init(minimum: .init(origin), maximum: .init(origin) + .init(size))
    }
}
