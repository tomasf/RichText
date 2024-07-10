import Foundation
import SwiftSCAD
import QuartzCore

extension CGPath {
    static internal let fillRuleEnvironmentKey: Environment.ValueKey = .init(rawValue: "CGPath.FillRule")
}

public extension Environment {
    var cgPathFillRule: CGPathFillRule {
        (self[CGPath.fillRuleEnvironmentKey] as? CGPathFillRule) ?? .evenOdd
    }

    func usingCGPathFillRule(_ fillRule: CGPathFillRule) -> Environment {
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
