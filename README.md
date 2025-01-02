# RichText

RichText is a macOS-specific companion library for SwiftSCAD that adds TextKit-based text generation. This enables proper Unicode support, richer typography, attribute ranges, multi-line text, constrained layout, bounding boxes, glyph-level manipulation and more.

This package also contains a `Geometry2D` extension for `CGPath` that can be used for other Core Graphics-related purposes.

<pre>
let package = Package(
    name: "thingamajig",
    dependencies: [
        .package(url: "https://github.com/tomasf/SwiftSCAD.git", .upToNextMinor(from: "0.9.0")),
        <b><i>.package(url: "https://github.com/tomasf/RichText.git", from: "0.2.0")</i></b>
    ],
    targets: [
        .executableTarget(name: "thingamajig", dependencies: ["SwiftSCAD", <b><i>"RichText"</i></b>])
    ]
)
</pre>
