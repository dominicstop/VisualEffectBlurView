//
//  VisualEffectViewExperiment01ViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView
import CoreImage




class VisualEffectViewExperiment01ViewController: UIViewController {
  
  var visualEffectView: VisualEffectView?;
  weak var overlayLabel: UILabel?;
  
  var cardVC: CardContainerViewController?;
  
  var counter = 0;
  var filterPresets: [LayerFilterType] = [
    .averagedColor,
    .alphaFromLuminance,
    
    .bias(inputAmount: 0.0),
    .bias(inputAmount: 0.2),
    .bias(inputAmount: 0.4),
    .bias(inputAmount: 0.6),
    .bias(inputAmount: 0.8),
    .bias(inputAmount: 1.0),
    
    .brightness(inputAmount: 0.0),
    .brightness(inputAmount: 0.2),
    .brightness(inputAmount: 0.4),
    .brightness(inputAmount: 0.6),
    .brightness(inputAmount: 0.8),
    .brightness(inputAmount: 1.0),
    
    .contrast(inputAmount: 0.2),
    .contrast(inputAmount: 0.6),
    .contrast(inputAmount: 1.2),
    .contrast(inputAmount: 1.6),
    .contrast(inputAmount: 2.0),
    
    .blackAndWhiteColor(inputAmount: 0.0),
    .blackAndWhiteColor(inputAmount: 0.3),
    .blackAndWhiteColor(inputAmount: 0.6),
    .blackAndWhiteColor(inputAmount: 1.0),
    
    .saturateColor(inputAmount: 0.0),
    .saturateColor(inputAmount: 0.6),
    .saturateColor(inputAmount: 1.0),
    .saturateColor(inputAmount: 2.0),
    .saturateColor(inputAmount: 4.0),
    
    .luminanceCompression(inputAmount: 0.0),
    .luminanceCompression(inputAmount: 0.2),
    .luminanceCompression(inputAmount: 0.4),
    .luminanceCompression(inputAmount: 0.6),
    .luminanceCompression(inputAmount: 0.8),
    .luminanceCompression(inputAmount: 1.0),
    
    .gaussianBlur(inputRadius: 0.0),
    .gaussianBlur(inputRadius: 1.0),
    .gaussianBlur(inputRadius: 2.0),
    .gaussianBlur(inputRadius: 4.0),
    .gaussianBlur(inputRadius: 8.0),
    .gaussianBlur(inputRadius: 16.0),
    
    .darkVibrant(
      inputReversed: true,
      inputColor0: UIColor.red.cgColor,
      inputColor1: UIColor.orange.cgColor
    ),
    .darkVibrant(
      inputReversed: true,
      inputColor0: UIColor.orange.cgColor,
      inputColor1: UIColor.yellow.cgColor
    ),
    .darkVibrant(
      inputReversed: true,
      inputColor0: UIColor.yellow.cgColor,
      inputColor1: UIColor.green.cgColor
    ),
    .darkVibrant(
      inputReversed: true,
      inputColor0: UIColor.green.cgColor,
      inputColor1: UIColor.blue.cgColor
    ),
    .darkVibrant(
      inputReversed: true,
      inputColor0: UIColor.blue.cgColor,
      inputColor1: UIColor.cyan.cgColor
    ),
    
    .lightVibrant(
      inputReversed: true,
      inputColor0: UIColor.red.cgColor,
      inputColor1: UIColor.orange.cgColor
    ),
    .lightVibrant(
      inputReversed: true,
      inputColor0: UIColor.orange.cgColor,
      inputColor1: UIColor.yellow.cgColor
    ),
    .lightVibrant(
      inputReversed: true,
      inputColor0: UIColor.yellow.cgColor,
      inputColor1: UIColor.green.cgColor
    ),
    .lightVibrant(
      inputReversed: true,
      inputColor0: UIColor.green.cgColor,
      inputColor1: UIColor.blue.cgColor
    ),
    .lightVibrant(
      inputReversed: true,
      inputColor0: UIColor.blue.cgColor,
      inputColor1: UIColor.cyan.cgColor
    ),
    
    .curves(
      inputAmount: 0.3,
      inputValues: [0.2, 0.2, 0.1, 0.1]
    ),
    .curves(
      inputAmount: 0.6,
      inputValues: [0.2, 0.2, 0.1, 0.1]
    ),
    .curves(
      inputAmount: 0.9,
      inputValues: [0.2, 0.2, 0.1, 0.1]
    ),
    
    .luminosityCurveMap(
      inputAmount: 0.3,
      inputValues: [0.16, 0.26, 0.10, 0.10]
    ),
    .luminosityCurveMap(
      inputAmount: 0.6,
      inputValues: [0.16, 0.26, 0.10, 0.10]
    ),
    .luminosityCurveMap(
      inputAmount: 0.9,
      inputValues: [0.16, 0.26, 0.10, 0.10]
    ),

    .matrixRGBA(matrixRGBA: .init(
      m11: 1.0, m12: 0.0, m13: 0.0, m14: 0.0, m15: 0.0,
      m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0, m25: 0.0,
      m31: 0.0, m32: 0.0, m33: 1.0, m34: 0.0, m35: 0.0,
      m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0, m45: 0.0
    )),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset01.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset02.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset03.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset04.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset05.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset06.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset07.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset08.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset09.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset10.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset11.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset12.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset13.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset14.matrixRGBA),
    .matrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset15.matrixRGBA),
    
    .vibrantMatrixRGBA(matrixRGBA: .init(
      m11: 1.0, m12: 0.0, m13: 0.0, m14: 0.0, m15: 0.0,
      m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0, m25: 0.0,
      m31: 0.0, m32: 0.0, m33: 1.0, m34: 0.0, m35: 0.0,
      m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0, m45: 0.0
    )),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset01.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset02.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset03.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset04.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset05.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset06.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset07.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset08.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset09.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset10.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset11.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset12.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset13.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset14.matrixRGBA),
    .vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBAPreset.preset15.matrixRGBA),
  ];
  
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
      
      let transformStart = Transform3D(
        translateX: -200
      );
      
      let transformEnd = Transform3D(
        translateX: 200
      );
      
      UIView.animateKeyframes(
        withDuration: 4.0,
        delay: 0.0,
        options: [.autoreverse, .repeat],
        animations: {
          UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
            label.layer.transform = transformStart.transform;
          })

          UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: {
            label.layer.transform = transformEnd.transform;
          })
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
//        let box = UIView();
//        box.backgroundColor = .red;
//        box.alpha = 0.5;
//        
//        visualEffectView.contentView.addSubview(box);
//        box.translatesAutoresizingMaskIntoConstraints = false;
//        
//        NSLayoutConstraint.activate([
//          box.heightAnchor.constraint(
//            equalToConstant: 200
//          ),
//          box.widthAnchor.constraint(
//            equalToConstant: 200
//          ),
//          box.centerXAnchor.constraint(
//            equalTo: visualEffectView.centerXAnchor
//          ),
//          box.centerYAnchor.constraint(
//            equalTo: visualEffectView.centerYAnchor
//          ),
//        ]);
      
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
  
    let controlStack: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .fill;
      stack.spacing = 20;
      
      return stack;
    }();
    
    let cardVC = CardContainerViewController(
      cardConfig: .init(
        title: "Filter Details",
        subtitle: "Filter information",
        desc: [
          .init(text: "N/A")
        ],
        index: self.counter,
        content: []
      )
    );
    
    self.cardVC = cardVC;
    controlStack.addArrangedSubview(cardVC.view);
    
    let nextButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Next Effect", for: .normal);
      button.configuration = .filled();
      
      button.addAction(for: .primaryActionTriggered){
        guard let _ = self.visualEffectView,
              let overlayLabel = self.overlayLabel
        else { return };

        overlayLabel.text = "Counter: \(self.counter)";
        self.updateFilterPreset();
        self.counter += 1;
      };
      
      return button;
    }();
    
    controlStack.addArrangedSubview(nextButton);
    
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
  };
  
  @objc func onPressLabel(_ sender: UILabel!){
    // TBA
  };
  
  func updateFilterPreset(){
    guard let visualEffectView = self.visualEffectView,
          let visualEffectViewWrapper = visualEffectView.wrapper,
          let backgroundHostWrapper = visualEffectViewWrapper.backgroundHostWrapper,
          let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
          let backdropLayerWrapper = contentViewWrapper.backdropLayerWrapper,
          let backdropLayer = backdropLayerWrapper.wrappedObject
    else {
      return;
    };
    
    let prevFilterType =
      self.filterPresets[cyclicIndex: max(self.counter - 1, 0)];
      
    let filterType =
      self.filterPresets[cyclicIndex: self.counter];
      
    print(
      "filterType:", filterType.decodedFilterName ?? "N/A",
      "\n - counter:", self.counter,
      "\n - filterType:", filterType,
      "\n"
    );
    
    self.cardVC?.cardConfig = .init(
      title: "Filter Details",
      subtitle: "Filter information",
      desc: [],
      index: self.counter,
      content: {
        var items: [CardContentItem] = [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "filter",
              value: filterType.decodedFilterName ?? "N/A"
            )
          ])
        ];
        
        items += filterType.filterDescAsAttributedConfig;
        return items;
      }()
    );
    
    self.cardVC?.applyCardConfig();
      
    if prevFilterType.decodedFilterName == filterType.decodedFilterName,
       let layerFilter = backdropLayer.filters?.first as? AnyObject,
       let layerFilterWrapper = LayerFilterWrapper(objectToWrap: layerFilter)
    {
      
      filterType.applyTo(layerFilterWrapper: layerFilterWrapper);
      UIView.animate(withDuration: 0.5){
        try! contentViewWrapper.applyRequestedFilterEffects();
      };
    
    } else if let layerFilterWrapper = filterType.createFilterWrapper(),
              let layerFilter = layerFilterWrapper.wrappedObject
    {
      UIView.animate(withDuration: 0.5){
        backdropLayer.filters = [layerFilter];
        try! contentViewWrapper.applyRequestedFilterEffects();
      };
    };
  };
};

extension Data { 
    var hex: String {
        var hexString = ""
        for byte in self {
            hexString += String(format: "%02X", byte)
        }

        return hexString
    }
}


