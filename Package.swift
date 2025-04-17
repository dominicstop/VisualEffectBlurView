// swift-tools-version: 5.7

import Foundation
import PackageDescription


let shouldInstallDepLocally: Bool = {
  let shouldInstallDepLocally =
    ProcessInfo.processInfo.environment["SHOULD_INSTALL_DEV_LIBRARIES_LOCALLY"];
    
  guard let shouldInstallDepLocally = shouldInstallDepLocally,
        shouldInstallDepLocally == "1"
  else {
    return false;
  };
  
  return true;
}();

/// `DGSwiftUtilities`
let swiftUtilitiesPackage: Package.Dependency = {
  let libPath =
    ProcessInfo.processInfo.environment["PATH_DEV_LIBRARY_SWIFT_UTILITIES"];
    
  guard let libPath = libPath,
        shouldInstallDepLocally
  else {
    return .package(
      url: "https://github.com/dominicstop/DGSwiftUtilities",
      from: "0.46.4"
    );
  };
  
  return .package(path: libPath);
}();

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
    swiftUtilitiesPackage,
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
