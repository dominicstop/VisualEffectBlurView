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
  
  var counter = 0;
  var filterPresets: [LayerFilterType] = [
    .averageColor,
    .luminanceToAlpha,
    
    .bias(inputAmount: 0.0),
    .bias(inputAmount: 0.2),
    .bias(inputAmount: 0.4),
    .bias(inputAmount: 0.6),
    .bias(inputAmount: 0.8),
    .bias(inputAmount: 1.0),
    
    .colorBrightness(inputAmount: 0.0),
    .colorBrightness(inputAmount: 0.2),
    .colorBrightness(inputAmount: 0.4),
    .colorBrightness(inputAmount: 0.6),
    .colorBrightness(inputAmount: 0.8),
    .colorBrightness(inputAmount: 1.0),
    
    .colorContrast(inputAmount: 0.0),
    .colorContrast(inputAmount: 0.2),
    .colorContrast(inputAmount: 0.4),
    .colorContrast(inputAmount: 0.6),
    .colorContrast(inputAmount: 0.8),
    .colorContrast(inputAmount: 1.0),
    
    .colorMonochrome(inputAmount: 0.0),
    .colorMonochrome(inputAmount: 0.2),
    .colorMonochrome(inputAmount: 0.4),
    .colorMonochrome(inputAmount: 0.6),
    .colorMonochrome(inputAmount: 0.8),
    .colorMonochrome(inputAmount: 1.0),
    
    .colorSaturate(inputAmount: 0.0),
    .colorSaturate(inputAmount: 0.2),
    .colorSaturate(inputAmount: 0.4),
    .colorSaturate(inputAmount: 0.6),
    .colorSaturate(inputAmount: 0.8),
    .colorSaturate(inputAmount: 1.0),
    
    .compressLuminance(inputAmount: 0.0),
    .compressLuminance(inputAmount: 0.2),
    .compressLuminance(inputAmount: 0.4),
    .compressLuminance(inputAmount: 0.6),
    .compressLuminance(inputAmount: 0.8),
    .compressLuminance(inputAmount: 1.0),
    
    .gaussianBlur(inputRadius: 0.0),
    .gaussianBlur(inputRadius: 1.0),
    .gaussianBlur(inputRadius: 2.0),
    .gaussianBlur(inputRadius: 4.0),
    .gaussianBlur(inputRadius: 8.0),
    .gaussianBlur(inputRadius: 16.0),
    
    .vibrantDark(
      inputReversed: true,
      inputColor0: UIColor.red.cgColor,
      inputColor1: UIColor.orange.cgColor
    ),
    .vibrantDark(
      inputReversed: true,
      inputColor0: UIColor.orange.cgColor,
      inputColor1: UIColor.yellow.cgColor
    ),
    .vibrantDark(
      inputReversed: true,
      inputColor0: UIColor.yellow.cgColor,
      inputColor1: UIColor.green.cgColor
    ),
    .vibrantDark(
      inputReversed: true,
      inputColor0: UIColor.green.cgColor,
      inputColor1: UIColor.blue.cgColor
    ),
    .vibrantDark(
      inputReversed: true,
      inputColor0: UIColor.blue.cgColor,
      inputColor1: UIColor.cyan.cgColor
    ),
    
    .vibrantLight(
      inputReversed: true,
      inputColor0: UIColor.red.cgColor,
      inputColor1: UIColor.orange.cgColor
    ),
    .vibrantLight(
      inputReversed: true,
      inputColor0: UIColor.orange.cgColor,
      inputColor1: UIColor.yellow.cgColor
    ),
    .vibrantLight(
      inputReversed: true,
      inputColor0: UIColor.yellow.cgColor,
      inputColor1: UIColor.green.cgColor
    ),
    .vibrantLight(
      inputReversed: true,
      inputColor0: UIColor.green.cgColor,
      inputColor1: UIColor.blue.cgColor
    ),
    .vibrantLight(
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
    
    .luminanceCurveMap(
      inputAmount: 0.3,
      inputValues: [0.16, 0.26, 0.10, 0.10]
    ),
    .luminanceCurveMap(
      inputAmount: 0.6,
      inputValues: [0.16, 0.26, 0.10, 0.10]
    ),
    .luminanceCurveMap(
      inputAmount: 0.9,
      inputValues: [0.16, 0.26, 0.10, 0.10]
    ),

    .colorMatrix(colorMatrix: .init(
      m11: 1.0, m12: 0.0, m13: 0.0, m14: 0.0, m15: 0.0,
      m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0, m25: 0.0,
      m31: 0.0, m32: 0.0, m33: 1.0, m34: 0.0, m35: 0.0,
      m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0, m45: 0.0
    )),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset01.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset02.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset03.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset04.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset05.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset06.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset07.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset08.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset09.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset10.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset11.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset12.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset13.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset14.colorMatrix),
    .colorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset15.colorMatrix),
    
    .vibrantColorMatrix(colorMatrix: .init(
      m11: 1.0, m12: 0.0, m13: 0.0, m14: 0.0, m15: 0.0,
      m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0, m25: 0.0,
      m31: 0.0, m32: 0.0, m33: 1.0, m34: 0.0, m35: 0.0,
      m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0, m45: 0.0
    )),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset01.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset02.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset03.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset04.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset05.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset06.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset07.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset08.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset09.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset10.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset11.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset12.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset13.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset14.colorMatrix),
    .vibrantColorMatrix(colorMatrix: ColorMatrixRGBAPreset.preset15.colorMatrix),
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
        let box = UIView();
        box.backgroundColor = .red;
        box.alpha = 0.5;
        
        visualEffectView.contentView.addSubview(box);
        box.translatesAutoresizingMaskIntoConstraints = false;
        
        NSLayoutConstraint.activate([
          box.heightAnchor.constraint(
            equalToConstant: 200
          ),
          box.widthAnchor.constraint(
            equalToConstant: 200
          ),
          
          box.centerXAnchor.constraint(
            equalTo: visualEffectView.centerXAnchor
          ),
          
          box.centerYAnchor.constraint(
            equalTo: visualEffectView.centerYAnchor
          ),
        ]);
      
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
        guard let _ = self.visualEffectView,
              let overlayLabel = self.overlayLabel
        else { return };

        overlayLabel.text = "Counter: \(self.counter)";
        self.updateFilterPreset();
        self.counter += 1;
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
