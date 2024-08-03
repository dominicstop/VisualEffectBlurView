//
//  VisualEffectViewExperiment02ViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 7/11/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView

class VisualEffectViewExperiment02ViewController: UIViewController {
  
  var visualEffectView: VisualEffectView?;
  weak var overlayLabel: UILabel?;
  
  var cardVC: CardViewController?;
  
  var counter = 0;
  
  var currentBlurEffectStyle: UIBlurEffect.Style {
    UIBlurEffect.Style.allCases[cyclicIndex: self.counter];
  };
  
  var currentBlurEffect: UIVisualEffect {
    UIBlurEffect(style: self.currentBlurEffectStyle);
  };
  
  var themeConfig: ColorThemeConfig = {
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
    
    let overlayContainerView: UIView = {
      let containerView = UIView();
      
      let visualEffectView = try? VisualEffectView(withEffect: self.currentBlurEffect);
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
        title: "Filter Details",
        subtitle: "Filter information",
        desc: [
          .init(text: "N/A")
        ],
        index: self.counter,
        colorThemeConfig: self.themeConfig,
        content: []
      )
    );
    
    self.cardVC = cardVC;
    controlStack.addArrangedSubview(cardVC.view);
    
    let nextButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Next Effect", for: .normal);
      button.configuration = .filled();
      
      button.configuration?.baseBackgroundColor = .init(hexString: "#8ace00")!;
      
      button.addAction(for: .primaryActionTriggered){
        guard let _ = self.visualEffectView,
              let overlayLabel = self.overlayLabel
        else { return };

        overlayLabel.text = "Counter: \(self.counter)";
        self.updateBlurEffect();
        
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
    self.updateDebugCard();
  };
  
  func updateDebugCard(){
    self.cardVC?.cardConfig = .init(
      title: "Filter Details",
      subtitle: "Filter information",
      desc: [],
      index: self.counter,
      colorThemeConfig: self.themeConfig,
      content: {
        var items: [CardContentItem] = [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "BlurEffect.Style",
              value: self.currentBlurEffectStyle.caseString
            )
          ])
        ];
        
        items += self.currentBlurEffectStyle.defaultFilterEntries.reduce(into: []) {
          guard let filterType = $1.filterTypeParsed else { return };
          $0 += filterType.getFilterDescAsAttributedConfig(shouldIncludeFilterName: true);
        };
        
        return items;
      }()
    );
    
    self.cardVC?.applyCardConfig();
  };
  
  func updateBlurEffect(){
    guard let visualEffectView = self.visualEffectView else {
      return;
    };
    
    let blurEffect = self.currentBlurEffect;
    
    UIView.animate(withDuration: 0.3){
      visualEffectView.effect = blurEffect;
      
    } completion: { _ in
      self.updateDebugCard();
      self._didUpdateFilter();
    };
  };
  
  @objc func onPressLabel(_ sender: UILabel!){
    // TBA
  };
  
  func _didUpdateFilter(){
    guard let visualEffectView = self.visualEffectView,
          let visualEffectViewWrapper = visualEffectView.wrapper,
          let backgroundHostWrapper = visualEffectViewWrapper.bgHostWrapped,
          let _ = backgroundHostWrapper.viewContentWrapped
    else {
      return;
    };
    
    // bgEffects Optional(<__NSSingleObjectArrayI 0x600000024250>(
    // <UIBlurEffect: 0x600000024310> style=UIBlurEffectStyleRegular
    //
    let bgEffects = visualEffectViewWrapper.effectsForBg;
    print("effectsForBg", bgEffects!);
    
    // empty
    let effectsForContent = visualEffectViewWrapper.effectsForContent;
    print("effectsForContent", effectsForContent!);
    
    let hostForContent = visualEffectViewWrapper.hostForContent;
    print("hostForContent", hostForContent);
  };
};
