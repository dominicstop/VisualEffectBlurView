//
//  VisualEffectCustomFilterViewTest02Controller.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 12/22/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView


class VisualEffectCustomFilterViewTest02Controller: UIViewController {

  weak var visualEffectView: VisualEffectCustomFilterView?;
  
  weak var blurRadiusLabel: UILabel?;
  weak var intensityLabel: UILabel?;
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  var counterForCurrentEffectGroup: Int = 0;
  
  var indexForCurrentEffectGroup: Int {
    self.counterForCurrentEffectGroup % effectGroups.count;
  };
  
  var currentBackgroundEffectGroup: [LayerFilterConfig] {
    self.effectGroups[self.indexForCurrentEffectGroup].backgroundFilters;
  };
  
  var currentForegroundEffectGroup: [LayerFilterConfig] {
    self.effectGroups[self.indexForCurrentEffectGroup].foregroundFilters;
  };
  
  var effectGroups: [(
    backgroundFilters: [LayerFilterConfig],
    foregroundFilters: [LayerFilterConfig]
  )] = {
    let gradientImageConfig1: ImageConfigGradient = ImageConfigGradient(
      colors: [.black, .clear],
      startPointPreset: .top,
      endPointPreset: .bottom,
      size: UIScreen.main.bounds.size
    );
    
    let gradientImageConfig2 = ImageConfigGradient(
      colors: [.clear, .black],
      startPointPreset: .left,
      endPointPreset: .right,
      size: UIScreen.main.bounds.size
    );
    
    let gradientImageConfig3 = ImageConfigGradient(
      colors: [.clear, .black],
      startPointPreset: .top,
      endPointPreset: .bottom,
      size: UIScreen.main.bounds.size
    );
    
    let gradientImageConfig4 = ImageConfigGradient(
      colors: [.black, .clear],
      startPointPreset: .left,
      endPointPreset: .right,
      size: UIScreen.main.bounds.size
    );
    
    return [
      (
        backgroundFilters: [
          .gaussianBlur(radius: 32, shouldNormalizeEdges: true),
          .colorBlackAndWhite(amount: 1),
        ],
        foregroundFilters: [
          .brightenColors(amount: -1)
        ]
      ),
      (
        backgroundFilters: [
          .gaussianBlur(radius: 0, shouldNormalizeEdges: true),
          .colorBlackAndWhite(amount: 0),
          .saturateColors(amount: 2),
          .contrastColors(amount: 2),
        ],
        foregroundFilters: [
          .gaussianBlur(radius: 8, shouldNormalizeEdges: false),
        ]
      ),
      (
        backgroundFilters: [
          .saturateColors(amount: 1),
          .contrastColors(amount: 0.5),
          .brightenColors(amount: -0.5),
          .variadicBlur(
            radius: 24,
            imageGradientConfig: gradientImageConfig1,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset01.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .contrastColors(amount: 1),
          .brightenColors(amount: 0.3),
          .variadicBlur(
            radius: 0,
            imageGradientConfig: gradientImageConfig1,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset02.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .brightenColors(amount: 0),
          .variadicBlur(
            radius: 32,
            imageGradientConfig: gradientImageConfig2,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
        .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset03.colorMatrix
          )]
      ),
      (
        backgroundFilters: [
          .luminanceCompression(amount: 0.4),
          .variadicBlur(
            radius: 0,
            imageGradientConfig: gradientImageConfig2,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset04.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .luminanceCompression(amount: 1),
          .colorMatrix(ColorMatrixRGBAPreset.preset01.colorMatrix),
          .variadicBlur(
            radius: 16,
            imageGradientConfig: gradientImageConfig1,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset05.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset02.colorMatrix),
          .variadicBlur(
            radius: 0,
            imageGradientConfig: gradientImageConfig1,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset06.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset03.colorMatrix),
          .variadicBlur(
            radius: 16,
            imageGradientConfig: gradientImageConfig2,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset07.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset04.colorMatrix),
          .variadicBlur(
            radius: 0,
            imageGradientConfig: gradientImageConfig2,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset08.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset05.colorMatrix),
          .variadicBlur(
            radius: 16,
            imageGradientConfig: gradientImageConfig3,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset09.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset06.colorMatrix),
          .variadicBlur(
            radius: 0,
            imageGradientConfig: gradientImageConfig3,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset10.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset07.colorMatrix),
          .variadicBlur(
            radius: 16,
            imageGradientConfig: gradientImageConfig4,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset11.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset09.colorMatrix),
          .variadicBlur(
            radius: 0,
            imageGradientConfig: gradientImageConfig4,
            shouldNormalizeEdges: true
          ),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset12.colorMatrix
          )
        ]
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset11.colorMatrix),
        ],
        foregroundFilters: []
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset12.colorMatrix),
        ],
        foregroundFilters: []
      ),
      (
        backgroundFilters:[
          .colorMatrix(ColorMatrixRGBAPreset.preset14.colorMatrix),
        ],
        foregroundFilters: []
      ),
      (
        backgroundFilters: [
          .colorMatrix(.identity),
        ],
        foregroundFilters: []
      ),
    ];
  }();
  
  override func viewDidLoad() {
    self.preloadEffects();
    self.setupBackgroundView();
    
    let blurContainerView: UIView = {
      let containerView = UIView();
      
      let effectView = try! VisualEffectCustomFilterView(
        withInitialBackgroundFilters: self.currentBackgroundEffectGroup,
        initialForegroundFilters: self.currentForegroundEffectGroup
      );
      
      self.visualEffectView = effectView;
      
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
    
    self.setupEffectContents();
  };
  
  func preloadEffects(){
    for (effectGroupIndex, effectGroup) in self.effectGroups.enumerated() {
      for (filterIndex, filter) in effectGroup.backgroundFilters.enumerated() {
        filter.preloadIfNeeded(shouldAlwaysInvokeCompletion: false) {
          print("loaded-\(effectGroupIndex)-\(filterIndex) backgroundFilters");
          self.effectGroups[effectGroupIndex].backgroundFilters[filterIndex] = $0;
        };
      };
      
      for (filterIndex, filter) in effectGroup.foregroundFilters.enumerated() {
        filter.preloadIfNeeded(shouldAlwaysInvokeCompletion: false) {
          print("loaded-\(effectGroupIndex)-\(filterIndex) foregroundFilters");
          self.effectGroups[effectGroupIndex].foregroundFilters[filterIndex] = $0;
        };
      };
    };
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
  
  func setupEffectContents(){
    guard let visualEffectView = self.visualEffectView else {
      return;
    };
    
    let contentView: UIView = {
      let label = UILabel();
      
      let dummyString: [AttributedStringConfig]  = (0..<15).map {
        .init(
          text: "\n \($0 + 1)-hello world, hello",
          fontConfig: .init(
            size: 40,
            weight: [.light, .medium, .regular, .bold, .heavy][cyclicIndex: $0],
            symbolicTraits: nil
          ),
          color: [.black, .init(white: 0.5, alpha: 1)][cyclicIndex: $0]
        )
      };

      label.attributedText = dummyString.makeAttributedString();
      
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping;
      label.sizeToFit();
      
      return label;
    }();
  
    contentView.translatesAutoresizingMaskIntoConstraints = false;
    visualEffectView.contentView.addSubview(contentView);
    
    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
      contentView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
      
      contentView.centerXAnchor.constraint(
        equalTo: self.view.centerXAnchor
      ),
      
      contentView.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor
      ),
    ]);
  };

  @objc func onPressButtonNextEffect(_ sender: UIButton){
    self.counterForCurrentEffectGroup += 1;
    print(
      "counterForCurrentEffectGroup:", self.counterForCurrentEffectGroup,
      "currentEffectGroup:", self.currentBackgroundEffectGroup,
      "\n"
    );
    
    try! self.visualEffectView!.immediatelyApplyFilters(
      backgroundFilters: self.currentBackgroundEffectGroup,
      foregroundFilters: self.currentForegroundEffectGroup
    );
  };
};
