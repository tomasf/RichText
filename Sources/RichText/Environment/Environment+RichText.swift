import Foundation
import SwiftSCAD

internal extension Environment {
    static private var baselineAlignmentEnvironmentKey: Environment.ValueKey = .init(rawValue: "RichText.BaselineAlignment")

    var baselineAlignment: RichText.BaselineAlignment {
        self[Self.baselineAlignmentEnvironmentKey] as? RichText.BaselineAlignment ?? .first
    }

    func withBaselineAlignment(_ alignment: RichText.BaselineAlignment) -> Environment {
        setting(key: Self.baselineAlignmentEnvironmentKey, value: alignment)
    }
}

internal extension Environment {
    static private var textBoundaryTypeEnvironmentKey: Environment.ValueKey = .init(rawValue: "RichText.TextBoundaryType")

    var textBoundaryType: RichText.BoundaryType {
        self[Self.textBoundaryTypeEnvironmentKey] as? RichText.BoundaryType ?? .shape
    }

    func withTextBoundaryType(_ type: RichText.BoundaryType) -> Environment {
        setting(key: Self.textBoundaryTypeEnvironmentKey, value: type)
    }
}

internal extension Environment {
    static private var textAttributeContainerEnvironmentKey: Environment.ValueKey = .init(rawValue: "RichText.RextAttributeContainer")

    var textAttributeContainer: AttributeContainer {
        self[Self.textAttributeContainerEnvironmentKey] as? AttributeContainer ?? .init()
    }

    func withTextAttributeContainer(_ container: AttributeContainer) -> Environment {
        setting(key: Self.textAttributeContainerEnvironmentKey, value: container)
    }
}

public extension Geometry2D {
    func usingTextBoundaryType(_ type: RichText.BoundaryType) -> any Geometry2D {
        withEnvironment { $0.withTextBoundaryType(type) }
    }

    func usingBaselineAlignment(_ alignment: RichText.BaselineAlignment) -> any Geometry2D {
        withEnvironment { $0.withBaselineAlignment(alignment) }
    }

    func usingTextAttribute<K: AttributedStringKey>(_ key: K.Type, value: K.Value?) -> any Geometry2D {
        withEnvironment { environment in
            var container = environment.textAttributeContainer
            container[K.self] = value
            return environment.withTextAttributeContainer(container)
        }
    }
}

public extension Geometry3D {
    func usingTextBoundaryType(_ type: RichText.BoundaryType) -> any Geometry3D {
        withEnvironment { $0.withTextBoundaryType(type) }
    }
    
    func usingBaselineAlignment(_ alignment: RichText.BaselineAlignment) -> any Geometry3D {
        withEnvironment { $0.withBaselineAlignment(alignment) }
    }

    func usingTextAttribute<K: AttributedStringKey>(_ key: K.Type, value: K.Value?) -> any Geometry3D {
        withEnvironment { environment in
            var container = environment.textAttributeContainer
            container[K.self] = value
            return environment.withTextAttributeContainer(container)
        }
    }
}
