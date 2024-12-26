//
//  VisualEffectCustomFilterViewTest03Controller.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 12/25/24.
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


class VisualEffectCustomFilterViewTest03Controller: UIViewController {
  
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
    .variadicBlur(
      radius: 0,
      imageGradientConfig: GradientPresets.leftToRightGradient01,
      shouldNormalizeEdges: true
    ),
  ] + GradientPresets.allGradients.map {
    .variadicBlur(
      radius: 0,
      imageGradientConfig: $0,
      shouldNormalizeEdges: true
    );
  };
  
  static let identityForegroundFilterConfigs: [LayerFilterConfig] = [];

  weak var visualEffectView: VisualEffectCustomFilterView?;
  
  weak var blurRadiusLabel: UILabel?;
  weak var intensityLabel: UILabel?;
  
  var currentAnimator: UIViewPropertyAnimator?;
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  var counterForCurrentEffectGroup: Int = 0;
  
  var indexForCurrentEffectGroup: Int {
    self.counterForCurrentEffectGroup % Self.effectGroups.count;
  };
  
  var currentBackgroundEffectGroup: [LayerFilterConfig] {
    Self.effectGroups[self.indexForCurrentEffectGroup].backgroundFilters;
  };
  
  var currentForegroundEffectGroup: [LayerFilterConfig] {
    Self.effectGroups[self.indexForCurrentEffectGroup].foregroundFilters;
  };
  
  var currentTintConfig: TintConfig? {
    Self.effectGroups[self.indexForCurrentEffectGroup].tintConfig;
  };
  
  static var effectGroups: [(
    backgroundFilters: [LayerFilterConfig],
    foregroundFilters: [LayerFilterConfig],
    tintConfig: TintConfig?
  )] = {

    return [
      (
        backgroundFilters: [
          .variadicBlur(
            radius: 8,
            imageGradientConfig: GradientPresets.leftToRightGradient01,
            shouldNormalizeEdges: true
          ),
          .colorBlackAndWhite(amount: 1.25),
        ],
        foregroundFilters: [
          .brightenColors(amount: -1)
        ],
        tintConfig: .init(
          tintColor: .red,
          opacity: 0.25,
          blendMode: .color
        )
      ),
      (
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
          .colorBlackAndWhite(amount: 1),
        ],
        foregroundFilters: [
          .brightenColors(amount: -1)
        ],
        tintConfig: .init(
          tintColor: .blue,
          opacity: 1,
          blendMode: .color
        )
      ),
      (
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
        foregroundFilters: [
          .gaussianBlur(radius: 8, shouldNormalizeEdges: false),
        ],
        tintConfig: .noTint
      ),
      (
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
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset01.colorMatrix
          ),
        ],
        tintConfig: .noTint
      ),
      (
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
            ColorMatrixRGBAPreset.preset02.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
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
            ColorMatrixRGBAPreset.preset03.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
        backgroundFilters: [
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
            ColorMatrixRGBAPreset.preset04.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
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
            ColorMatrixRGBAPreset.preset05.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
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
            ColorMatrixRGBAPreset.preset06.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
        backgroundFilters: [
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
            ColorMatrixRGBAPreset.preset07.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
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
            ColorMatrixRGBAPreset.preset08.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
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
            ColorMatrixRGBAPreset.preset09.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
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
            ColorMatrixRGBAPreset.preset10.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
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
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset11.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
        backgroundFilters: [
          .colorMatrix(ColorMatrixRGBAPreset.preset09.colorMatrix),
        ],
        foregroundFilters: [
          .colorMatrixVibrant(
            ColorMatrixRGBAPreset.preset12.colorMatrix
          )
        ],
        tintConfig: .noTint
      ),
      (
        backgroundFilters: [
          .colorMatrix(.identity),
        ],
        foregroundFilters: [],
        tintConfig: .noTint
      ),
    ];
  }();
  
  override func viewDidLoad() {
    self.setupBackgroundView();
    
    let blurContainerView: UIView = {
      let containerView = UIView();
      
      let effectView = try! VisualEffectCustomFilterView(
        withEffect: UIBlurEffect(style: .regular)
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
    
    return;
    
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
  
    var queue = Self.effectGroups;
    
    try! effectView.setFiltersViaEffectDesc(
      backgroundFilterConfigItems: Self.identityBackgroundFilterConfigs,
      foregroundFilterConfigItems: Self.identityForegroundFilterConfigs,
      shouldImmediatelyApplyFilter: true
    );
  
    func recursivelyDequeue(){
      guard queue.count > 0 else {
        return;
      };
      
      let queueCount = queue.count;
      let currentIndex = Self.effectGroups.count - queueCount;
      
      let currentKeyframe = queue.removeFirst();
      
      var gradientConfigs = currentKeyframe.backgroundFilters.compactMap {
        switch $0 {
          case let .variadicBlur(
            radius,
            imageGradientConfig,
            shouldNormalizeEdges,
            shouldNormalizeEdgesToTransparent,
            shouldUseHardEdges
          ):
            return imageGradientConfig;
        
          default:
            return nil;
        };
      };
      
      var gradientConfigsHasMatch = gradientConfigs.map {
        effectView.gradientCache[$0] != nil;
      };
       
      print(
        "recursivelyDequeue",
        "\n - queueCount:", queueCount,
        "\n - currentIndex:", currentIndex,
        "\n - gradientConfigs.count:", gradientConfigs.count,
        "\n - gradientConfigsHasMatch:", gradientConfigsHasMatch,
        "\n"
      );
      
      try! effectView.updateBackgroundFiltersViaEffectDesc(
        withFilterConfigItems: currentKeyframe.backgroundFilters
      );
      
      // try! effectView.applyRequestedBackgroundFilterEffects();
      // return;
      
      let animationBlocks = try! effectView.createAnimationBlocks(
        backgroundFilterConfigItems: currentKeyframe.backgroundFilters,
        foregroundFilterConfigItems: []
      );
      
      try! animationBlocks.prepare();
      
      let animationConfig: AnimationConfig = .presetCurve(
        duration: 1,
        curve: .easeIn
      );
      
      let animator = animationConfig.createAnimator();
      self.currentAnimator = animator;
      
      animator.addAnimations {
        animationBlocks.animations();
      };
      
      animator.addCompletion { _ in
        animationBlocks.completion();
      };
      
      // animator.pausesOnCompletion = true;
      // animator.isInterruptible = true;
      
      animator.addObserver(self,
        forKeyPath: #keyPath(UIViewPropertyAnimator.isRunning),
        options: [.new],
        context: nil
      );
      
      animator.addCompletion { _ in
        recursivelyDequeue();
      };
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        // performAnimation();
        animator.startAnimation();
      };
    };
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      recursivelyDequeue();
    };
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
      foregroundFilters: self.currentForegroundEffectGroup,
      tintConfig: self.currentTintConfig
    );
  };
  
  @objc override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
  
    print(
      "observeValue",
      "\n - keyPath:", keyPath,
      "\n - object:", object,
      "\n - change:", change,
      "\n - change[kindKey]:", change![NSKeyValueChangeKey.kindKey],
      "\n - change[notificationIsPriorKey]:", change![NSKeyValueChangeKey.notificationIsPriorKey],
      "\n - change[indexesKey]:", change![NSKeyValueChangeKey.indexesKey],
      "\n - change[oldKey]:", change![NSKeyValueChangeKey.oldKey],
      "\n - change[newKey]:", change![NSKeyValueChangeKey.newKey],
      "\n - context:", context,
      "\n"
    );
    
    guard let newValue = change![NSKeyValueChangeKey.newKey] as? Bool,
          !newValue
    else {
      return;
    };
    
    return;
    
    self.currentAnimator!.isReversed = true;
    self.currentAnimator!.fractionComplete = 0;
    self.currentAnimator!.pausesOnCompletion = false
    self.currentAnimator?.startAnimation();
  };
};
