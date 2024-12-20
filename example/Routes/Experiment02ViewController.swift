//
//  Experiment02ViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 12/9/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView

class Experiment02ViewController: UIViewController {

  weak var visualEffectView: VisualEffectView?;
  
  weak var blurRadiusLabel: UILabel?;
  weak var intensityLabel: UILabel?;
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  override func viewDidLoad() {
  
    self.setupBackgroundView();
    
    let blurContainerView: UIView = {
      let containerView = UIView();
      
      func test01(){
        let effect = UIBlurEffect(style: .systemThickMaterial);
        
        let effectSettings = effect.value(forKey: "effectSettings") as! NSObject;
        effectSettings.setValue(1.0, forKey: "grayscaleTintLevel");
        
        
        
        //effect.perform(NSSelectorFromString("setEffectSettings:"), with: effectSettings);
        // effect.setValue(effectSettings, forKey: "effectSettings")
        
        
        
        print(effect);
      };
      
      func test02(){
        let effectView = try! VisualEffectView(withEffect: CustomEffect());
        //self.visualEffectView = effectView;
      
      };
      
      
      // test01();
      
      let effectView = try! VisualEffectView(withEffect: CustomEffect());
      effectView.backgroundLayerSamplingSizeScale = 1;
      self.visualEffectView = effectView;
      
      
    
      let gradientImage1 = {
        let imageConfig: ImageConfigGradient = ImageConfigGradient(
          colors: [.black, .clear],
          startPointPreset: .top,
          endPointPreset: .bottom,
          size: UIScreen.main.bounds.size
        );
        
        return try! imageConfig.makeImage();
      }();
      
      let gradientImage2 = {
        let imageConfig: ImageConfigGradient = ImageConfigGradient(
          colors: [.clear, .black],
          startPointPreset: .left,
          endPointPreset: .right,
          size: UIScreen.main.bounds.size
        );
        
        return try! imageConfig.makeImage();
      }();
      
      let gradientImage3 = {
        let imageConfig: ImageConfigGradient = ImageConfigGradient(
          colors: [.clear, .black],
          startPointPreset: .top,
          endPointPreset: .bottom,
          size: UIScreen.main.bounds.size
        );
        
        return try! imageConfig.makeImage();
      }();
      
      let gradientImage4 = {
        let imageConfig: ImageConfigGradient = ImageConfigGradient(
          colors: [.black, .clear],
          startPointPreset: .left,
          endPointPreset: .right,
          size: UIScreen.main.bounds.size
        );
        
        return try! imageConfig.makeImage();
      }();
      
      try! effectView.setFiltersViaEffectDesc(
        withFilterTypes: [
          .gaussianBlur(radius: 0, shouldNormalizeEdges: true),
          .colorBlackAndWhite(amount: 0),
          .contrastColors(amount: 1),
          .saturateColors(amount: 1),
          .variadicBlur(
            radius: 0,
            maskImage: gradientImage1.cgImage,
            shouldNormalizeEdges: true
          ),
          .brightenColors(amount: 0),
          .luminanceCompression(amount: 1),
          .colorMatrix(.identity),
        ],
        shouldImmediatelyApplyFilter: true
      );
      
      var batchesOfFiltersToApply1: [[LayerFilterType]] = [
        [
          .gaussianBlur(radius: 32, shouldNormalizeEdges: true),
          .colorBlackAndWhite(amount: 1),
        ],
        [
          .gaussianBlur(radius: 0, shouldNormalizeEdges: true),
          .colorBlackAndWhite(amount: 0),
          .saturateColors(amount: 2),
          .contrastColors(amount: 2),
        ],
        [
          .saturateColors(amount: 1),
          .contrastColors(amount: 0.5),
          .brightenColors(amount: -0.5),
          .variadicBlur(
            radius: 24,
            maskImage: gradientImage1.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .contrastColors(amount: 1),
          .brightenColors(amount: 0.3),
          .variadicBlur(
            radius: 0,
            maskImage: gradientImage1.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .brightenColors(amount: 0),
          .variadicBlur(
            radius: 32,
            maskImage: gradientImage2.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .luminanceCompression(amount: 0.4),
          .variadicBlur(
            radius: 0,
            maskImage: gradientImage2.cgImage,
            shouldNormalizeEdges: true
          ),
        ]
      ];
      
      var batchesOfFiltersToApply2: [[LayerFilterType]] = [
        [
          .luminanceCompression(amount: 1),
          .colorMatrix(ColorMatrixRGBAPreset.preset01.colorMatrix),
          .variadicBlur(
            radius: 16,
            maskImage: gradientImage1.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset02.colorMatrix),
          .variadicBlur(
            radius: 0,
            maskImage: gradientImage1.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset03.colorMatrix),
          .variadicBlur(
            radius: 16,
            maskImage: gradientImage2.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset04.colorMatrix),
          .variadicBlur(
            radius: 0,
            maskImage: gradientImage2.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset05.colorMatrix),
          .variadicBlur(
            radius: 16,
            maskImage: gradientImage3.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset06.colorMatrix),
          .variadicBlur(
            radius: 0,
            maskImage: gradientImage3.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset07.colorMatrix),
          .variadicBlur(
            radius: 16,
            maskImage: gradientImage4.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset09.colorMatrix),
          .variadicBlur(
            radius: 0,
            maskImage: gradientImage4.cgImage,
            shouldNormalizeEdges: true
          ),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset11.colorMatrix),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset12.colorMatrix),
        ],
        [
          .colorMatrix(ColorMatrixRGBAPreset.preset14.colorMatrix),
        ],
        [
          .colorMatrix(.identity),
        ],
      ];
      
      func animateFilters(
        filterBatch: [[LayerFilterType]],
        duration: CGFloat,
        pauseTime: CGFloat = 0.1,
        completion: Optional<() -> Void> = nil
      ) {
        for (index, nextFilters) in filterBatch.enumerated() {
          let waitTime = ((CGFloat(index) + 1.0) * duration) + pauseTime;
          let isLast = index == (batchesOfFiltersToApply1.count - 1);
          
          DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            try! effectView.updateCurrentFiltersViaEffectDesc(
              withFilterTypes: nextFilters
            );
            
            UIView.animate(withDuration: duration) {
              try! effectView.applyRequestedFilterEffects();
            }
            completion: { _ in
              print(index);
              if isLast {
                completion?();
              };
            }
          };
        };
      };
      
      animateFilters(
        filterBatch: batchesOfFiltersToApply1,
        duration: 1.5
      ) {
        animateFilters(
          filterBatch: batchesOfFiltersToApply2,
          duration: 0.5,
          completion: nil
        )
      };
      
      effectView.translatesAutoresizingMaskIntoConstraints = false;
      containerView.addSubview(effectView);
      
      NSLayoutConstraint.activate([
        effectView.heightAnchor.constraint(
          equalTo: containerView.heightAnchor
        ),
        effectView.widthAnchor.constraint(
          equalTo: containerView.widthAnchor
        ),
        
        effectView.centerXAnchor.constraint(
          equalTo: containerView.centerXAnchor
        ),
        
        effectView.centerYAnchor.constraint(
          equalTo: containerView.centerYAnchor
        ),
      ]);
      
      return containerView;
    }();
 
    blurContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(blurContainerView);
    
    NSLayoutConstraint.activate([
      blurContainerView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      blurContainerView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
      blurContainerView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      blurContainerView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
    ]);
    
    let nextBlurEffectButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Next Effect", for: .normal);
      
      if #available(iOS 15.0, *) {
        button.configuration = .filled();
        
      } else {
        button.backgroundColor = .blue;
      };
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonNextEffect(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    let controlStack: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .fill;
      stack.spacing = 20;
      
      stack.addArrangedSubview(nextBlurEffectButton);
    
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
  };
  
  func setupBackgroundView(){
    let bgView: UIView = {
      let label = UILabel();
      label.text = "🖼️❤️\n🌆🧡\n🌄💚\n🏞️💛\n🌉💙";
      label.font = .systemFont(ofSize: 128);
      
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping;
      label.sizeToFit();
      
      return label;
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
      
      bgView.centerXAnchor.constraint(
        equalTo: self.view.centerXAnchor
      ),
      
      bgView.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor
      ),
    ]);
  };

  @objc func onPressButtonNextEffect(_ sender: UIButton){
  };
};

public class CustomEffect: UIVisualEffect {
  
  /// `-(void)_updateEffectDescriptor:(id)arg1 forEnvironment:(id)arg2 usage:(long long)arg3 ;`
  @objc(_updateEffectDescriptor:forEnvironment:usage:)
  func updateEffectDescriptor(
    _ effectDescriptor: NSObject,
    enviroment: NSObject,
    usage: Int
  ) -> NSObject {
  
    let effectDescWrapped = UVEDescriptorWrapper(objectToWrap: effectDescriptor)!;
    
    let filterEntryWrapped = UVEFilterEntryWrapper()!;
    
    let filter: LayerFilterType = .colorBlackAndWhite(amount: 1);
    try! filter.applyTo(
      filterEntryWrapper: filterEntryWrapped,
      shouldSetValuesIdentity: false
    );
    
    try! effectDescWrapped.setFilterItems([filterEntryWrapped]);
    
    
    return effectDescriptor;
  };
  
  @objc(effectSettings)
  func effectSettings() -> NSObject {
    let effect = UIBlurEffect(style: .systemThickMaterial);
        
      let effectSettings = effect.value(forKey: "effectSettings") as! NSObject;
      effectSettings.setValue(1.0, forKey: "grayscaleTintLevel");
      
      return effectSettings;
  };
};
