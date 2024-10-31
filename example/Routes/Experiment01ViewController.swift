//
//  Experiment01ViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 10/24/24.
//

import UIKit
import SwiftUI
import DGSwiftUtilities


class Experiment01ViewController: UIViewController {
  
  var backgroundContainerView: UIView?;
  weak var overlayLabel: UILabel?;
  
  var cardVC: CardViewController?;
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  override func viewDidLoad() {
    let backgroundContainerView: UIView = .init();
    self.backgroundContainerView = backgroundContainerView;
    
    backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(backgroundContainerView);
    
    NSLayoutConstraint.activate([
      backgroundContainerView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      backgroundContainerView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
      backgroundContainerView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      backgroundContainerView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
    ]);
    
    self.setupBackground();
  
    let controlStack: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .fill;
      stack.spacing = 20;
      
      return stack;
    }();
    
    let cardVC = CardViewController(
      cardConfig: .init(
        title: "TBA",
        subtitle: "TBA",
        desc: [
          .init(text: "N/A")
        ],
        index: nil,
        content: []
      )
    );
    
    self.cardVC = cardVC;
    controlStack.addArrangedSubview(cardVC.view);
    
    let prevButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Prev Preset", for: .normal);
      if #available(iOS 15.0, *) {
        button.configuration = .filled();
        button.configuration?.baseBackgroundColor = .init(hexString: "#8ace00")!;
        
      } else {
        button.backgroundColor = .init(hexString: "#8ace00")!;
      };
      
      button.addAction(for: .primaryActionTriggered){
        // no-op
      };
      
      return button;
    }();
    
    // controlStack.addArrangedSubview(prevButton);
    
    let nextButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Next Preset", for: .normal);
      if #available(iOS 15.0, *) {
        button.configuration = .filled();
        button.configuration?.baseBackgroundColor = .init(hexString: "#8ace00")!;
        
      } else {
        button.backgroundColor = .init(hexString: "#8ace00")!;
      };
      
      button.addAction(for: .primaryActionTriggered){
        // no-op
      };
      
      return button;
    }();
    
    // controlStack.addArrangedSubview(nextButton);
    
    controlStack.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(controlStack);
    
    NSLayoutConstraint.activate([
      controlStack.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
        constant: -20
      ),
      controlStack.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      controlStack.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
        constant: -20
      ),
    ]);
    
    let overlayLabel: UIView = {
      let containerView = UIView();
      containerView.backgroundColor = UIColor(
        red: 0/255,
        green: 0/255,
        blue: 0/255,
        alpha: 0.4
      );
      
      containerView.layer.cornerRadius = 15;
      
      let label = UILabel();
      self.overlayLabel = label;
      
      label.text = "TBA";
      label.font = .boldSystemFont(ofSize: 32);
      
      label.textColor = UIColor(
        red: 255/255,
        green: 255/255,
        blue: 255/255,
        alpha: 0.8
      );
      
      label.translatesAutoresizingMaskIntoConstraints = false;
      containerView.addSubview(label);
      
      NSLayoutConstraint.activate([
        
        label.centerXAnchor.constraint(
          equalTo: containerView.centerXAnchor
        ),
        label.centerYAnchor.constraint(
          equalTo: containerView.centerYAnchor
        ),
      ]);


      return containerView;
    }();

    overlayLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(overlayLabel);
    
    NSLayoutConstraint.activate([
      overlayLabel.heightAnchor.constraint(
        equalToConstant: 125
      ),
      overlayLabel.widthAnchor.constraint(
        equalToConstant: 125
      ),
      overlayLabel.centerXAnchor.constraint(
        equalTo: self.view.centerXAnchor
      ),
      
      overlayLabel.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor
      ),
    ]);
    
    overlayLabel.isHidden = true;
    self.updateDebugCard();
  };
  
  func setupBackground(){
    guard #available(iOS 17.0, *) else {
      return;
    };
  
    guard let backgroundContainerView = self.backgroundContainerView else {
      return;
    };
    
    let effectOverlay = OverlayView();
    let hostingController = UIHostingController(rootView: effectOverlay);
    hostingController.view.backgroundColor = .clear;
    
    self.view.addSubview(hostingController.view);
    self.addChild(hostingController);
    
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      hostingController.view.heightAnchor.constraint(
        equalTo: backgroundContainerView.heightAnchor
      ),
      hostingController.view.widthAnchor.constraint(
        equalTo: backgroundContainerView.widthAnchor
      ),
      
      hostingController.view.centerXAnchor.constraint(
        equalTo: backgroundContainerView.centerXAnchor
      ),
      
      hostingController.view.centerYAnchor.constraint(
        equalTo: backgroundContainerView.centerYAnchor
      ),
    ]);
    
    backgroundContainerView.updateConstraints();
    backgroundContainerView.setNeedsLayout();
  };
  
  func updateDebugCard(){
    self.cardVC?.cardConfig = .init(
      title: "Preset Information",
      subtitle: "Test for blur mode transitions",
      desc: [
        .init(text: "N/A"),
      ],
      index: nil,
      colorThemeConfig: .presetPurple,
      content: []
    );
    
    self.cardVC?.applyCardConfig();
  };

  @objc func onPressLabel(_ sender: UILabel!){
    // TBA
  };
};

fileprivate class DummyContentController: UIViewController {
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  override func viewDidLoad() {
    let bgView: UIView = {
      let rootView = UIView();
      
      let gradientConfig = ImageConfigGradient(
        colors: [
          ColorPreset.green900.color,
          .white
        ],
        size: .init(width: 100, height: 100)
      );
      
      let gradientImage = try! gradientConfig.makeImage();
      let bgGradient = UIImageView(image: gradientImage);
      
      rootView.addSubview(bgGradient);
      bgGradient.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        bgGradient.topAnchor.constraint(
          equalTo: rootView.topAnchor
        ),
        bgGradient.bottomAnchor.constraint(
          equalTo: rootView.bottomAnchor
        ),
        bgGradient.leadingAnchor.constraint(
          equalTo: rootView.leadingAnchor
        ),
        bgGradient.trailingAnchor.constraint(
          equalTo: rootView.trailingAnchor
        ),
      ]);
      
      let label = UILabel();
      label.text = "💚\n🖼️\n🌆\n🌄";
      label.font = .systemFont(ofSize: 128);
      
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping;
      label.sizeToFit();
      
      rootView.addSubview(label);
      label.translatesAutoresizingMaskIntoConstraints = false;
      
      let extraOffsetX: CGFloat = 30;
      let extraOffsetY: CGFloat = -75;
      
      let transformStart = Transform3D(
        translateX: -extraOffsetX,
        translateY: extraOffsetY
      );
      
      let transformEnd = Transform3D(
        translateX: UIScreen.main.bounds.width + extraOffsetX,
        translateY: extraOffsetY
      );
      
      label.layer.transform = transformStart.transform;
      
      UIView.animateKeyframes(
        withDuration: 3.0,
        delay: 0.0,
        options: [.autoreverse, .repeat],
        animations: {
          label.layer.transform = transformEnd.transform;
        },
        completion: nil
      );
      
      NSLayoutConstraint.activate([
        label.topAnchor.constraint(
          equalTo: rootView.topAnchor
        ),
        label.bottomAnchor.constraint(
          equalTo: rootView.bottomAnchor
        ),
        label.centerXAnchor.constraint(
          equalTo: rootView.leadingAnchor
        ),
        label.centerYAnchor.constraint(
          equalTo: rootView.centerYAnchor
        ),
      ]);
      
      return rootView;
    }();
  
    bgView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(bgView);
    
    NSLayoutConstraint.activate([
      bgView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
      bgView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
      bgView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      bgView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
    ]);
  };
};

fileprivate struct DummyContent: UIViewRepresentable {

  func makeUIView(context: Context) -> UIView {
    let controller: DummyContentController = .init();
    return controller.view;
  }
  
  func updateUIView(_ view: UIView, context: Context) {
    // no-op
  };
}

@available(iOS 17.0, *)
fileprivate struct OverlayView: View {

  var body: some View {
    VStack {
      DummyContent()
        .visualEffect { content, geometryProxy in
          content.blur(radius: 24);
          //content.brightness(0.5);
        }
    }
  }
}
