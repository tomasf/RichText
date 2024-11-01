import SwiftSCAD
import AppKit

public struct RichText: Shape2D {
    internal let text: AttributedString
    internal let layout: Layout

    @EnvironmentValue(\.self) var environment
    @EnvironmentValue(\.textBoundaryType) var textBoundaryType

    public init(_ text: AttributedString, layout: Layout = .free) {
        self.text = text
        self.layout = layout
    }

    public init(_ string: String, layout: Layout = .free){
        self.init(.init(string), layout: layout)
    }

    public var body: any Geometry2D {
        let lineFragments = lineFragments(in: environment)

        lineFragments.map {
            $0.glyphs.map { $0.shape.translated($0.location) }
        }
        .modifyingBounds { box in
            if let box, textBoundaryType == .shape {
                box
            } else {
                .init(union: lineFragments.map(\.glyphBox))
            }
        }
        .usingCGPathFillRule(.winding)
    }

    public func readingLineFragments(@UnionBuilder2D _ reader: @escaping ([LineFragment]) -> any Geometry2D) -> any Geometry2D {
        readEnvironment { environment in
            reader(lineFragments(in: environment))
                .usingCGPathFillRule(.winding)
        }
    }
}

public extension RichText {
    enum Layout: Equatable {
        case free
        case constrained (width: Double, height: Double? = nil)

        internal var textContainerSize: CGSize {
            switch self {
            case .constrained (let width, let height):
                    .init(width: width, height: height ?? .infinity)
            case .free:
                    .init(width: 100000, height: CGFloat.infinity)
            }
        }

        internal var containerHeight: Double? {
            if case .constrained(_, let height) = self { height } else { 0 }
        }
    }

    struct LineFragment {
        public let origin: Vector2D
        public let glyphBox: BoundingBox2D
        public let glyphs: [Glyph]
        public let stringRange: Range<String.Index>

        public struct Glyph {
            public let shape: CGPath
            public let location: Vector2D
            public let stringRange: Range<String.Index>
        }
    }

    enum BaselineAlignment: Sendable {
        case first
        case last
    }

    enum BoundaryType: Sendable {
        case shape
        case lineFragments
    }
}

