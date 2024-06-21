// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "VisualEffectBlurView",
  platforms: [
    .iOS(.v11),
  ],
  products: [
    .library(
      name: "VisualEffectBlurView",
      targets: ["VisualEffectBlurView"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/dominicstop/DGSwiftUtilities",
      .upToNextMajor(from: "0.23.0")
    ),
  ],
  targets: [
    .target(
      name: "VisualEffectBlurView",
      dependencies: [
        "DGSwiftUtilities",
      ],
      path: "Sources",
      linkerSettings: [
				.linkedFramework("UIKit"),
        .linkedFramework("SwiftUI")
			]
    ),
  ]
)
