//
//  VisualEffectAnimatableBlurTest01Controller.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 10/9/24.
//

import Foundation
import UIKit
import VisualEffectBlurView
import DGSwiftUtilities


class VisualEffectAnimatableBlurTest01Controller: UIViewController {

  typealias VisualEffectBlurModeEntry = (
    desc: String,
    start: VisualEffectBlurMode,
    end: VisualEffectBlurMode
  );
    
  static var blurModeTestPresets: [VisualEffectBlurModeEntry] = [
    /// Test: `blurEffectNone` -> [...]
    /// Test for transitioning from no blur effect, to some blur effect mode
    (
      "test - transitioning from blurEffectNone to blurEffectSystem",
      .blurEffectNone,
      .blurEffectSystem(blurEffectStyle: .regular)
    ),
    (
      "test - transitioning from blurEffectNone to blurEffectCustomIntensity",
      .blurEffectNone,
      .blurEffectCustomIntensity(
        blurEffectStyle: .regular,
        effectIntensity: 0.4
      )
    ),
    (
      "test - transitioning from blurEffectNone to blurEffectCustomBlurRadius",
      .blurEffectNone,
      .blurEffectCustomBlurRadius(
        blurEffectStyle: .regular,
        customBlurRadius: 32,
        effectIntensityForOtherEffects: 0.3
      )
    ),
    
    /// Test: [...] -> `blurEffectNone`
    /// Test for transitioning from some blur effect mode,
    /// to no blur effect
    (
      "test - transitioning from blurEffectSystem to blurEffectNone",
      .blurEffectSystem(blurEffectStyle: .regular),
      .blurEffectNone
    ),
    (
      "test - transitioning from blurEffectNone to blurEffectCustomIntensity",
      .blurEffectCustomIntensity(
        blurEffectStyle: .regular,
        effectIntensity: 0.5
      ),
      .blurEffectNone
    ),
    (
      "test - transitioning from blurEffectCustomBlurRadius to blurEffectNone",
      .blurEffectCustomBlurRadius(
        blurEffectStyle: .regular,
        customBlurRadius: 64,
        effectIntensityForOtherEffects: 0.3
      ),
      .blurEffectNone
    ),
    
    /// Test: Updating blur radius/intensity
    /// * Same step (mode not changing)
    /// * Same `UIBlurEffect.Style`
    /// * Only changing: blut intensity/radius
    (
      "test - update blurEffectCustomIntensity, change: effectIntensity",
      .blurEffectCustomIntensity(
        blurEffectStyle: .regular,
        effectIntensity: 0
      ),
      .blurEffectCustomIntensity(
        blurEffectStyle: .regular,
        effectIntensity: 1
      )
    ),
    (
      "test - update blurEffectCustomBlurRadius, change: effectIntensity + customBlurRadius",
      .blurEffectCustomBlurRadius(
        blurEffectStyle: .regular,
        customBlurRadius: 32,
        effectIntensityForOtherEffects: 0.3
      ),
      .blurEffectCustomBlurRadius(
        blurEffectStyle: .regular,
        customBlurRadius: 0,
        effectIntensityForOtherEffects: 1
      )
    ),
    
    // Test: Update blur effect style
    (
      "test - update blurEffectSystem, change blurEffectStyle",
      .blurEffectSystem(blurEffectStyle: .regular),
      .blurEffectSystem(blurEffectStyle: .dark)
    )
  ];
  
  static var themeConfig: ColorThemeConfig = {
    var base = ColorThemeConfig.presetPurple;
    base.colorBgLight = ColorPreset.lightGreen100.color;
    base.colorBgDark = ColorPreset.lightGreen600.color;
    base.colorBgAccent = ColorPreset.greenA700.color; //.init(hexString: "#8ace00")!;
    base.colorTextLight = .init(white: 1, alpha: 0.9);
    
    base.colorTextDark = {
      let rgba = ColorPreset.green900.color.rgba;
      return .init(
        red: rgba.r,
        green: rgba.g,
        blue: rgba.b,
        alpha: 0.8
      );
    }();
    
    return base;
  }();
  
  var overlayContainerView: UIView?;
  var blurView: VisualEffectAnimatableBlurView?;
  weak var overlayLabel: UILabel?;
  
  var cardVC: CardViewController?;
  var counter = 0;
  
  var currentPreset: VisualEffectBlurModeEntry {
    Self.blurModeTestPresets[cyclicIndex: self.counter];
  };
  
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
    
    
    let overlayContainerView: UIView = .init();
    self.overlayContainerView = overlayContainerView;
    
    overlayContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(overlayContainerView);
    
    defer {
      self.setupBlurView();
    }
    
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
    
    let cardVC = CardViewController(
      cardConfig: .init(
        title: "TBA",
        subtitle: "TBA",
        desc: [
          .init(text: "N/A")
        ],
        index: self.counter,
        colorThemeConfig: Self.themeConfig,
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
        self.counter -= 1;
        self.updateDebugCard();
        
        let preset = self.currentPreset;
        
        guard let blurView = self.blurView else {
          return;
        };
        
        try! blurView.applyBlurMode(
          preset.start,
          useAnimationFriendlyWorkaround: true
        );
        
        let animationBlocks = try! blurView.createAnimationBlocks(
          applyingBlurMode: preset.end
        );
        
        UIView.animate(withDuration: 1) {
          animationBlocks.animation();
        } completion: { isSuccess in
          
          print(
            "\(self.className).\(#function)",
            "\n - isSuccess:", isSuccess,
            "\n"
          );
          animationBlocks.completion();
        }
        

        self.blurView?._debugRecursivelyPrintSubviews();
      };
      
      return button;
    }();
    
    controlStack.addArrangedSubview(prevButton);
    
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
        self.counter += 1;
        self.updateDebugCard();
        self.setupBlurView();
        
        let preset = self.currentPreset;
        
        guard let blurView = self.blurView else {
          return;
        };
        
        let animationBlocks = try! blurView.createAnimationBlocks(
          applyingBlurMode: preset.end
        );
        
        try! animationBlocks.setup();
        
        UIView.animate(
          withDuration: 1,
          delay: 0.5
        ) {
          animationBlocks.animation();
        } completion: { isSuccess in
          
          print(
            "\(self.className).\(#function)",
            "\n - isSuccess:", isSuccess,
            "\n"
          );
          animationBlocks.completion();
        }
        

        self.blurView?._debugRecursivelyPrintSubviews();
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
    self.updateDebugCard();
  };
  
  func setupBlurView(){
    guard let overlayContainerView = self.overlayContainerView else {
      return;
    };
    
    if let blurViewOld = self.blurView {
      blurViewOld.removeFromSuperview();
    };
    
    let visualEffectView = try? VisualEffectAnimatableBlurView(blurMode: self.currentPreset.start);
    guard let visualEffectView = visualEffectView else {
      return;
    };
    
    self.blurView = visualEffectView;
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = false;
    overlayContainerView.addSubview(visualEffectView);
    
    NSLayoutConstraint.activate([
      visualEffectView.heightAnchor.constraint(
        equalTo: overlayContainerView.heightAnchor
      ),
      visualEffectView.widthAnchor.constraint(
        equalTo: overlayContainerView.widthAnchor
      ),
      
      visualEffectView.centerXAnchor.constraint(
        equalTo: overlayContainerView.centerXAnchor
      ),
      
      visualEffectView.centerYAnchor.constraint(
        equalTo: overlayContainerView.centerYAnchor
      ),
    ]);
    
    overlayContainerView.updateConstraints();
    overlayContainerView.setNeedsLayout();
  };
  
  func updateDebugCard(){
    let presetStart = self.currentPreset.start;
    let presetEnd = self.currentPreset.end;
    
    let blurTransitionMode: VisualEffectBlurTransitionMode = .init(
      blurModePrev: presetStart,
      blurModeNext: presetEnd
    );
  
    self.cardVC?.cardConfig = .init(
      title: "Preset Information",
      subtitle: "Test for blur mode transitions",
      desc: [
        .init(text: self.currentPreset.desc),
      ],
      index: self.counter,
      colorThemeConfig: Self.themeConfig,
      content: {
        let contentItems: [CardContentItem] = [
          .labelValueDisplay(items: [
            .singleRow(
              label: [
                .init(text: "Preset Index"),
              ],
              value: [
                .init(text: "\(self.counter % Self.blurModeTestPresets.count) of \(Self.blurModeTestPresets.count - 1)")
              ]
            ),
            .multiLineRow(
              label: [
                .init(text: "blurTransitionMode"),
              ],
              value: [
                .init(text: blurTransitionMode.caseString)
              ]
            ),
          ]),
          presetStart.createLabelValueDisplayDesc(
            labelValueItemsPre: [
              .singleRow(
                label: [
                  .init(text: "Start Values")
                ],
                value: []
              )
            ]
          ),
          presetEnd.createLabelValueDisplayDesc(
            labelValueItemsPre: [
              .singleRow(
                label: [
                  .init(text: "End Values")
                ],
                value: []
              )
            ]
          ),
        ];
        
        return contentItems;
      }()
    );
    
    self.cardVC?.applyCardConfig();
  };
  
  @objc func onPressLabel(_ sender: UILabel!){
    // TBA
  };
};

extension VisualEffectBlurMode {

  func createLabelValueDisplayDesc(
    labelValueItemsPre: [CardLabelValueDisplayItemConfig] = [],
    labelValueItemsPost: [CardLabelValueDisplayItemConfig] = []
  ) -> CardContentItem {
    var items: [CardLabelValueDisplayItemConfig] = [];
    items += labelValueItemsPre;
    
    items += [
      .singleRow(
        label: [
          .init(text: "mode"),
        ],
        value: [
          .init(text: self.caseString)
        ]
      ),
    ];
      
    if let blurEffectStyle = self.blurEffectStyle {
      items.append(
        .singleRow(
          label: [
            .init(text: "blurEffectStyle"),
          ],
          value: [
            .init(text: blurEffectStyle.caseString)
          ]
        )
      );
    };
    
    if let customBlurRadius = self.customBlurRadius {
      items.append(
        .singleRow(
          label: [
            .init(text: "customBlurRadius"),
          ],
          value: [
            .init(text: customBlurRadius.description)
          ]
        )
      );
    };
      
    if let effectIntensity = self.effectIntensity {
      items.append(
        .singleRow(
          label: [
            .init(text: "effectIntensity"),
          ],
          value: [
            .init(text: effectIntensity.description)
          ]
        )
      );
    };
    
    items += labelValueItemsPost;
    return .labelValueDisplay(items: items);
  };
};
