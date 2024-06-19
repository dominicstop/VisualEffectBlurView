//
//  SwiftUIBasicUsage01.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 9/14/23.
//

import UIKit
import SwiftUI
import VisualEffectBlurView

struct SwiftUIBasicUsage01: View {

  var body: some View {
    Text("🖼️\n🌆\n🌄")
      .font(.system(size: 128))
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity
      )
      .overlay(self.overlay, alignment: .center)
  }
  
  var overlay: some View {
    VisualEffectBlur(
      blurEffectStyle: .constant(.regular),
      blurRadius: .constant(nil)
    )
  };
}

class BlurViewSwiftUIBasicUsage01ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad();
    
    let swiftUIView = SwiftUIBasicUsage01();
    let hostingController = UIHostingController(rootView: swiftUIView);
    
    self.view.addSubview(hostingController.view);
    self.addChild(hostingController);
    
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      hostingController.view.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      hostingController.view.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
      hostingController.view.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
    ]);

    hostingController.didMove(toParent: self);
  };
};
