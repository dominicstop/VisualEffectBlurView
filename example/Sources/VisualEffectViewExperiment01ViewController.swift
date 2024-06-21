//
//  VisualEffectViewExperiment01ViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView

class VisualEffectViewExperiment01ViewController: UIViewController {
  
  var visualEffectView: VisualEffectView?;
  weak var overlayLabel: UILabel?;
  
  var counter = 0;
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  override func viewDidLoad() {
  
    let bgView: UIView = {
      let rootView = UIView();
      
      let gradientConfig = ImageConfigGradient(
        colors: [.black, .white],
        size: .init(width: 100, height: 100)
      );
      
      let gradientImage = gradientConfig.makeImage();
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
      label.text = "🖼️\n🌆\n🌄";
      label.font = .systemFont(ofSize: 128);
      
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping;
      label.sizeToFit();
      
      rootView.addSubview(label);
      label.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        label.topAnchor.constraint(
          equalTo: rootView.topAnchor
        ),
        label.bottomAnchor.constraint(
          equalTo: rootView.bottomAnchor
        ),
        label.centerXAnchor.constraint(
          equalTo: rootView.centerXAnchor
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
    
    let overlayContainerView: UIView = {
      let containerView = UIView();
      
      let visualEffectView = VisualEffectView();
      self.visualEffectView = visualEffectView;
      
      if let visualEffectView = visualEffectView {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false;
        containerView.addSubview(visualEffectView);
        
        NSLayoutConstraint.activate([
          visualEffectView.heightAnchor.constraint(
            equalTo: containerView.heightAnchor
          ),
          visualEffectView.widthAnchor.constraint(
            equalTo: containerView.widthAnchor
          ),
          
          visualEffectView.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor
          ),
          
          visualEffectView.centerYAnchor.constraint(
            equalTo: containerView.centerYAnchor
          ),
        ]);
      };
      
      return containerView;
    }();
 
    overlayContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(overlayContainerView);
    
    NSLayoutConstraint.activate([
      overlayContainerView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      overlayContainerView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
      overlayContainerView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      overlayContainerView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
    ]);
    
    let nextButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Next Effect", for: .normal);
      button.configuration = .filled();
      
      button.addAction(for: .primaryActionTriggered){
        self.counter += 1;
    
        guard let _ = self.visualEffectView,
              let overlayLabel = self.overlayLabel
        else { return };

        overlayLabel.text = "Counter: \(self.counter)";
      };
      
      return button;
    }();
    
    let controlStack: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .fill;
      stack.spacing = 20;
      
      //stack.addArrangedSubview(blurSliderControl);
      stack.addArrangedSubview(nextButton);
    
      return stack;
    }();
    
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
      
      let tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(Self.onPressLabel(_:))
      );
      
      containerView.addGestureRecognizer(tapGesture);

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
    
    // exp-1
    block:
    if let visualEffectView = self.visualEffectView,
       let visualEffectViewWrapper = visualEffectView.wrapper,
       let backgroundHostWrapper = visualEffectViewWrapper.backgroundHostWrapper,
       let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
       let backdropLayerWrapper = contentViewWrapper.backdropLayerWrapper
    {
      break block;
      let backdropLayer =
        visualEffectView.subviews.first!.layer;
        // backdropLayerWrapper.wrappedObject
       
      // CAFilter
      // filterWithType:
      
      backdropLayer.filters = [];
      // try? contentViewWrapper.applyRequestedFilterEffects();
      
      let filterClass = NSClassFromString("CAFilter") as AnyObject;
      let selector = NSSelectorFromString("filterWithType:");
      let filterType = "variableBlur";
      
      let filter = filterClass
        .perform(selector, with: filterType)
        .takeUnretainedValue();
        
      let gradientConfig = ImageConfigGradient(
        colors: [.white, .white],
        size: self.view.bounds.size
      );
      
      let gradientImage = gradientConfig.makeImage();
      
      UIBlurEffect.Style.allCases.forEach {
        print(
          "UIBlurEffect.Style:", $0.caseString,
          "\n - defaultFilterEntries:",
          $0.defaultFilterEntries,
          "\n"
        );
      };
        
      filter.setValue(1, forKey: "inputRadius")
      filter.setValue(gradientImage, forKey: "inputMaskImage")
      filter.setValue(true, forKey: "inputNormalizeEdges")
      
      if visualEffectView.subviews.indices.contains(1) {
        let tintOverlayView = visualEffectView.subviews[1]
        tintOverlayView.alpha = 0
      };
      
      
      backdropLayer.filters = [filter];
      
      
      
      // let blendingLayer = CALayer();
      // blendingLayer.setValue(false, forKey: "allowsGroupBlending" )
      // blendingLayer.compositingFilter = "screenBlendMode"
      // blendingLayer.allowsGroupOpacity = false
      // backdropLayer.addSublayer(blendingLayer)
            
      // try gaussianBlurFilterEntryWrapped.setRequestedValues(requestedValuesCopy);
      // try backgroundHostWrapper.setCurrentEffectDescriptor(effectDescriptorWrapper);
      try? contentViewWrapper.applyRequestedFilterEffects();
    };
    
    block:
    if let visualEffectView = self.visualEffectView,
       let visualEffectViewWrapper = visualEffectView.wrapper,
       let backgroundHostWrapper = visualEffectViewWrapper.backgroundHostWrapper,
       let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
       let backdropLayerWrapper = contentViewWrapper.backdropLayerWrapper,
       let backdropLayer = backdropLayerWrapper.wrappedObject
    {
        
      break block;
      let blurEffect = UIBlurEffect(style: .systemThinMaterialDark);
      let effectDescriptorWrapper = try! visualEffectViewWrapper.effectDescriptor(
        forEffects: [blurEffect],
        usage: true
      );
      
      let gradientConfig = ImageConfigGradient(
        colors: [.white, .white],
        size: self.view.bounds.size
      );
      
      let gradientImage = gradientConfig.makeImage();

      let filter: [String: Any] = [
        "filterType": "variableBlur",
        "requestedValues": [
          "inputRadius": 24,
          "inputMaskImage": gradientImage,
          "inputNormalizeEdges": true,
        ],
      ];
      
      let test = effectDescriptorWrapper!.wrappedObject!.value(forKey: "_filterEntries");
      let test2 = effectDescriptorWrapper!.wrappedObject!.value(forKey: "_viewEffects");
      //try filterEntryWrapped.setRequestedValues(requestedValuesCopy);
      
      // try? backgroundHostWrapper.performSelector(
      //   usingEncodedString: .setCurrentEffectDescriptor,
      //   withArg1: filter
      // );
      
      
      try? contentViewWrapper.applyRequestedFilterEffects();
    };
    
    // exp-3
    block:
    if let visualEffectView = self.visualEffectView,
       let visualEffectViewWrapper = visualEffectView.wrapper,
       let backgroundHostWrapper = visualEffectViewWrapper.backgroundHostWrapper,
       let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
       let backdropLayerWrapper = contentViewWrapper.backdropLayerWrapper
    {
      break block;
      let layerFilterWrapper = LayerFilterWrapper(rawFilterType: "colorSaturate");
      guard let layerFilterWrapper = layerFilterWrapper,
            let layerFilter = layerFilterWrapper.wrappedObject
      else {
        break block;
      };
      
      layerFilterWrapper.setInputAmount(0);
      self.view.layer.filters = [layerFilter];
    };
    
    // exp-4
    block:
    if let visualEffectView = self.visualEffectView,
       let visualEffectViewWrapper = visualEffectView.wrapper,
       let backgroundHostWrapper = visualEffectViewWrapper.backgroundHostWrapper,
       let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
       let backdropLayerWrapper = contentViewWrapper.backdropLayerWrapper,
       let backdropLayer = backdropLayerWrapper.wrappedObject
    {
      visualEffectView.shouldOnlyShowBackdropLayer = true;

      let layerFilterWrapper = LayerFilterWrapper(rawFilterType: "colorSaturate");
      guard let layerFilterWrapper = layerFilterWrapper,
            let layerFilter = layerFilterWrapper.wrappedObject
      else {
        break block;
      };
      
      layerFilterWrapper.setInputAmount(0);
      backdropLayer.filters = [layerFilter];
    };
  };
  
  @objc func onPressLabel(_ sender: UILabel!){

  };
};
