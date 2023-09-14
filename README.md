# VisualEffectBlurView

A subclass of `UIVisualEffectView` that lets you set a custom blur radius + intensity.

<br><br>

## Demo Gifs

TBA

<br><br>

## Installation

### Cocoapods

`VisualEffectBlurView` is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your `Podfile`:

```ruby
pod 'VisualEffectBlurView'
```

<br>

### Swift Package Manager (SPM)

**Method #1**: Via Xcode GUI:

1. File > Swift Packages > Add Package Dependency
2. Add `https://github.com/dominicstop/VisualEffectBlurView.git`

<br>

**Method #2**: Via `Package.swift`:

* Open your project's `Package.swift` file.
* Update `dependencies` in `Package.swift`, and add the following:

```swift
dependencies: [
  .package(url: "https://github.com/dominicstop/VisualEffectBlurView.git",
  .upToNextMajor(from: "1.0.0"))
]
```

<br><br>

## Basic Usage

[🔗 Full Example](./example/Examples/BasicUsage01.swift.swift)

```swift
// ✨ Code omitted for brevity

import UIKit
import VisualEffectBlurView;

class BasicUsage01: UIViewController {

  override func viewDidLoad() {
  	
    let blurView = VisualEffectBlurView(blurEffectStyle: .dark);
    blurView.blurRadius = 15;

    blurView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(blurView);
    
    NSLayoutConstraint.activate([
      blurView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      blurView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
      blurView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      blurView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
    ]);
  };
};

```

<br><br>

## Documentation

TBA

<br><br>

## Misc and Contact

* 🐤 **Twitter/X**: `@GoDominic`
* 💌 **Email**: `dominicgo@dominicgo.dev`
* 🌐 **Website**: [dominicgo.dev](https://dominicgo.dev)
