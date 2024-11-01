import SwiftSCAD
import Foundation
import QuartzCore

extension QuartzCore.CGPath: SwiftSCAD.Shape2D {
    public var body: any Geometry2D {
        readEnvironment(\.cgPathFillRule) { fillRule in
            self.componentsSeparated(using: fillRule).map { component in
                let (positive, negatives) = component.normalizedPolygons(using: fillRule)
                return positive.subtracting { negatives }
            }
        }
    }
}

internal extension CGPath {
    typealias Polygon = SwiftSCAD.Polygon
    
    func normalizedPolygons(using fillRule: CGPathFillRule) -> (positive: Polygon, negatives: [Polygon]) {
        let polygons = normalized(using: fillRule).polygons()
        guard let first = polygons.first else {
            return (Polygon([] as [Vector2D]), [])
        }
        return (first, Array(polygons[1...]))
    }

    func polygons() -> [Polygon] {
        var polygons: [Polygon] = []
        var currentPath: BezierPath2D? = nil

        applyWithBlock {
            let element = $0.pointee

            switch element.type {
            case .moveToPoint:
                if let currentPath {
                    polygons.append(Polygon(currentPath))
                }
                currentPath = .init(startPoint: .init(element.points[0]))

            case .addLineToPoint,
                    .addQuadCurveToPoint,
                    .addCurveToPoint:
                if let path = currentPath {
                    let points = UnsafeBufferPointer(start: element.points, count: Int(element.type.rawValue))
                        .map(Vector2D.init)
                    currentPath = path.addingCurve(points)
                }

            case .closeSubpath: break
            @unknown default: break
            }
        }

        if let currentPath {
            polygons.append(Polygon(currentPath))
        }
        return polygons
    }
}

