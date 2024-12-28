//
//  VisualEffectAnimatableCustomFilterViewTest01Controller.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 12/28/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView


fileprivate struct GradientPresets {

  static var allGradients = [
    Self.leftToRightGradient01,
    Self.leftToRightGradient02,
    Self.leftToRightGradient03,
    Self.rightToLeftGradient01,
    Self.rightToLeftGradient02,
    Self.radialGradient01,
    Self.radialGradient02,
    Self.radialGradient03,
    Self.radialGradient04,
    Self.topDownGradient01,
    Self.topDownGradient02,
    Self.bottomToTopGradient01,
    Self.bottomToTopGradient02,
  ];
  

  static let leftToRightGradient01: ImageConfigGradient = .leftToRightGradient(
    colors: [
      .init(white: 0, alpha: 0),
      .init(white: 0, alpha: 0.2),
      .init(white: 0, alpha: 1),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let leftToRightGradient02: ImageConfigGradient = .leftToRightGradient(
    colors: [
      .init(white: 0, alpha: 0),
      .init(white: 0, alpha: 0.3),
      .init(white: 0, alpha: 1),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let leftToRightGradient03: ImageConfigGradient = .leftToRightGradient(
    colors: [
      .init(white: 0, alpha: 0),
      .init(white: 0, alpha: 0.3),
      .init(white: 0, alpha: 1),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let rightToLeftGradient01: ImageConfigGradient = .leftToRightGradient(
    colors: [
      .init(white: 0, alpha: 1),
      .init(white: 0, alpha: 0.25),
      .init(white: 0, alpha: 0),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let rightToLeftGradient02: ImageConfigGradient = .leftToRightGradient(
    colors: [
      .init(white: 0, alpha: 1),
      .init(white: 0, alpha: 0),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let radialGradient01: ImageConfigGradient = .centerToOuterEdgeGradient(
    colors: [
      .init(white: 0, alpha: 0),
      .init(white: 0, alpha: 0.15),
      .init(white: 0, alpha: 1),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let radialGradient02: ImageConfigGradient = .centerToOuterEdgeGradient(
    colors: [
      .init(white: 0, alpha: 1),
      .init(white: 0, alpha: 0.8),
      .init(white: 0, alpha: 0),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let radialGradient03: ImageConfigGradient = .centerToOuterEdgeGradient(
    colors: [
      .init(white: 0, alpha: 0),
      .init(white: 0, alpha: 1),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let radialGradient04: ImageConfigGradient = .centerToOuterEdgeGradient(
    colors: [
      .init(white: 0, alpha: 1),
      .init(white: 0, alpha: 0),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let topDownGradient01: ImageConfigGradient = .topDownGradient(
    colors: [
      .init(white: 0, alpha: 0),
      .init(white: 0, alpha: 0.2),
      .init(white: 0, alpha: 1),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let topDownGradient02: ImageConfigGradient = .topDownGradient(
    colors: [
      .init(white: 0, alpha: 0),
      .init(white: 0, alpha: 1),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let bottomToTopGradient01: ImageConfigGradient = .topDownGradient(
    colors: [
      .init(white: 0, alpha: 1),
      .init(white: 0, alpha: 0.1),
      .init(white: 0, alpha: 0),
    ],
    size: UIScreen.main.bounds.size
  );
  
  static let bottomToTopGradient02: ImageConfigGradient = .topDownGradient(
    colors: [
      .init(white: 0, alpha: 1),
      .init(white: 0, alpha: 0),
    ],
    size: UIScreen.main.bounds.size
  );

};


class VisualEffectAnimatableCustomFilterViewTest01Controller: UIViewController {
  
  static let identityBackgroundFilterConfigs: [LayerFilterConfig] = [
    .bias(amount: 0.5),
    .luminanceCompression(amount: 1),
    .gaussianBlur(
      radius: 0,
      shouldNormalizeEdges: true
    ),
    .colorBlackAndWhite(amount: 0),
    .contrastColors(amount: 1),
    .saturateColors(amount: 1),
    
    .brightenColors(amount: 0),
    .colorMatrix(.identity),
    .luminosityCurveMap(
      amount: 0,
      point1: 0,
      point2: 0.3,
      point3: 0.6,
      point4: 1
    ),
  ] + GradientPresets.allGradients.map {
    .variadicBlur(
      radius: 0,
      imageGradientConfig: $0,
      shouldNormalizeEdges: true
    );
  };
  
  static var identityForegroundFilterConfigs: [LayerFilterConfig] {
    Self.identityBackgroundFilterConfigs.filter {
      switch $0 {
        case .variadicBlur,
             .luminanceCompression:
          return false;
        
        default:
          return true;
      };
    };
  };

  weak var visualEffectView: VisualEffectAnimatableCustomFilterView?;
  
  weak var blurRadiusLabel: UILabel?;
  weak var intensityLabel: UILabel?;
  
  var currentAnimator: UIViewPropertyAnimator?;
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  static var filterKeyframes: [CustomFilterKeyframeConfig] {
    [
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          .variadicBlur(
            radius: 8,
            imageGradientConfig: GradientPresets.leftToRightGradient01,
            shouldNormalizeEdges: true
          ),
          .colorBlackAndWhite(amount: 1),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(ColorMatrixRGBAPreset.preset01.colorMatrix),
        ],
        tintConfig: .init(
          tintColor: .red,
          opacity: 1,
          blendMode: .color
        )
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          // reset
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.leftToRightGradient01,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 8,
            imageGradientConfig: GradientPresets.rightToLeftGradient01,
            shouldNormalizeEdges: true
          ),
          .colorBlackAndWhite(amount: 0),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(ColorMatrixRGBAPreset.preset02.colorMatrix),
        ],
        tintConfig: .init(
          tintColor: .blue,
          opacity: 1,
          blendMode: .color
        )
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          // reset
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.rightToLeftGradient01,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.topDownGradient01,
            shouldNormalizeEdges: true
          ),
          .colorBlackAndWhite(amount: 0),
          .saturateColors(amount: 2),
          .contrastColors(amount: 2),
        ],
        foregroundFilters:  [
          .colorMatrixVibrant(ColorMatrixRGBAPreset.preset03.colorMatrix),
        ],
        tintConfig: .init(
          tintColor: .clear,
          opacity: 0,
          blendMode: nil
        )
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          // reset
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.topDownGradient01,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.bottomToTopGradient01,
            shouldNormalizeEdges: true
          ),
          .saturateColors(amount: 1),
          .contrastColors(amount: 0.5),
          .brightenColors(amount: -0.5),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(ColorMatrixRGBAPreset.preset04.colorMatrix),
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.bottomToTopGradient01,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.radialGradient01,
            shouldNormalizeEdges: true
          ),
          .contrastColors(amount: 1),
          .brightenColors(amount: 0.2),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset05.colorMatrix
          )
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.radialGradient01,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.radialGradient02,
            shouldNormalizeEdges: true
          ),
          .brightenColors(amount: 0),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset06.colorMatrix
          )
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters:  [
          // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.radialGradient02,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.leftToRightGradient02,
            shouldNormalizeEdges: true
          ),
          .luminanceCompression(amount: 0.4),
          ],
          foregroundFilters: [
            .colorMatrixVibrant(
              ColorMatrixRGBAPreset.preset07.colorMatrix
            )
          ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.leftToRightGradient02,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.rightToLeftGradient02,
            shouldNormalizeEdges: true
          ),
          .luminanceCompression(amount: 1),
          .colorMatrix(ColorMatrixRGBAPreset.preset01.colorMatrix),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset08.colorMatrix
          )
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.rightToLeftGradient02,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.topDownGradient01,
            shouldNormalizeEdges: true
          ),
          .colorMatrix(ColorMatrixRGBAPreset.preset02.colorMatrix),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset09.colorMatrix
          )
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters:  [
           // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.topDownGradient02,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.bottomToTopGradient02,
            shouldNormalizeEdges: true
          ),
          .colorMatrix(ColorMatrixRGBAPreset.preset03.colorMatrix),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset10.colorMatrix
          )
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
           // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.bottomToTopGradient02,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.radialGradient03,
            shouldNormalizeEdges: true
          ),
          .colorMatrix(ColorMatrixRGBAPreset.preset04.colorMatrix),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset11.colorMatrix
          )
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
           // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.radialGradient03,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.leftToRightGradient03,
            shouldNormalizeEdges: true
          ),
          .colorMatrix(ColorMatrixRGBAPreset.preset05.colorMatrix),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset12.colorMatrix
          )
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
           // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.leftToRightGradient03,
            shouldNormalizeEdges: true
          ),
          // new
          .variadicBlur(
            radius: 12,
            imageGradientConfig: GradientPresets.radialGradient04,
            shouldNormalizeEdges: true
          ),
          .colorMatrix(ColorMatrixRGBAPreset.preset06.colorMatrix),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset13.colorMatrix
          )
        ],
        tintConfig: nil
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
           // old
          .variadicBlur(
            radius: 0,
            imageGradientConfig: GradientPresets.radialGradient04,
            shouldNormalizeEdges: true
          ),
          .colorMatrix(ColorMatrixRGBAPreset.preset07.colorMatrix),
        ],
        foregroundFilters: [
          .gaussianBlur(
            radius: 6,
            shouldNormalizeEdges: false
          ),
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset14.colorMatrix
          ),
        ],
        tintConfig: .init(
          tintColor: .yellow,
          opacity: 0.5,
          blendMode: .colorBurn
        )
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset09.colorMatrix),
        ],
        foregroundFilters: [
          .gaussianBlur(
            radius: 0,
            shouldNormalizeEdges: false
          ),
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset15.colorMatrix
          )
        ],
        tintConfig: .init(
          tintColor: .green,
          opacity: 0.75,
          blendMode: .hardLight
        )
      ),
      .init(
        rootKeyframe: nil,
        contentKeyframe: nil,
        backdropKeyframe: nil,
        backgroundFilters: [
          .colorMatrix(.identity),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(.identity),
        ],
        tintConfig: .noTint
      ),
    ]
  };
  
  override func viewDidLoad() {
    self.setupBackgroundView();
    
    let blurContainerView: UIView = {
      let containerView = UIView();
      
      let effectView = try! VisualEffectAnimatableCustomFilterView(
        identityBackgroundFilters: Self.identityBackgroundFilterConfigs,
        identityForegroundFilters: Self.identityForegroundFilterConfigs,
        initialKeyframe: Self.filterKeyframes.first!
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
    
    if false {
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
    
    self.setupEffectContents();
    self.startAnimation();
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
  
  func startAnimation(){
    guard let effectView = self.visualEffectView else {
      return;
    };
    
    print(
      "startAnimation",
      "\n - gradientCache.count:", effectView.gradientCache.count,
      "\n - gradientCache.keys:", effectView.gradientCache.keys,
      "\n - gradientCache.values:", effectView.gradientCache.values,
      "\n"
    );
  
    var queue = Self.filterKeyframes;
    queue.remove(at: 0);
    

    func recursivelyDequeue(){
      guard queue.count > 0 else {
        return;
      };
      
      let queueCount = queue.count;
      let currentIndex = Self.filterKeyframes.count - queueCount;
      
      let currentKeyframe = queue.removeFirst();
      
      let animationConfig: AnimationConfig = .presetCurve(
        duration: 1,
        curve: .easeIn
      );
      
      let animator = animationConfig.createAnimator();
      self.currentAnimator = animator;
      
      let animationBlocks = try! currentKeyframe.createAnimations(
        forTarget: effectView,
        withPrevKeyframe: nil,
        forPropertyAnimator: animator
      );
      
      try! animationBlocks.setup();
      
      animator.addAnimations {
        animationBlocks.applyKeyframe();
      };
      
      animator.addCompletion {
        animationBlocks.completion($0 == .end);
      };
      
      animator.addCompletion { _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          recursivelyDequeue();
        };
      };
      
      animator.startAnimation();
    };
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      recursivelyDequeue();
    };
  };

  @objc func onPressButtonNextEffect(_ sender: UIButton){
    // no-op
  };
};
