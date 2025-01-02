import Foundation
import SwiftSCAD
@preconcurrency import QuartzCore

extension CGPath {
    static internal let fillRuleEnvironmentKey: EnvironmentValues.Key = .init(rawValue: "CGPath.FillRule")
}


public extension EnvironmentValues {
    var cgPathFillRule: CGPathFillRule {
        (self[CGPath.fillRuleEnvironmentKey] as? CGPathFillRule) ?? .evenOdd
    }

    func usingCGPathFillRule(_ fillRule: CGPathFillRule) -> EnvironmentValues {
        setting(key: CGPath.fillRuleEnvironmentKey, value: fillRule)
    }
}

public extension Geometry2D {
    func usingCGPathFillRule(_ fillRule: CGPathFillRule) -> any Geometry2D {
        withEnvironment { environment in
            environment.usingCGPathFillRule(fillRule)
        }
    }
}

public extension Geometry3D {
    func usingCGPathFillRule(_ fillRule: CGPathFillRule) -> any Geometry3D {
        withEnvironment { environment in
            environment.usingCGPathFillRule(fillRule)
        }
    }
}
