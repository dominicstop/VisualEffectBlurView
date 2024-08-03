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
  
  var cardVC: CardViewController?;
  
  var counter = 0;
  var filterPresets: [LayerFilterType?] = [
    nil,
    .variadicBlur(
      radius: 16,
      maskImage: {
        let imageConfig: ImageConfigGradient = ImageConfigGradient(
          colors: [.black, .clear],
          startPointPreset: .left,
          endPointPreset: .right,
          size: .init(width: 200, height: 400)
        );
        
        let gradientImage = imageConfig.makeImage();
        return gradientImage.cgImage!;
      }(),
      shouldNormalizeEdges: true
    ),
    .variadicBlur(
      radius: 24,
      maskImage: {
        let imageConfig: ImageConfigGradient = ImageConfigGradient(
          colors: [.black, .clear],
          startPointPreset: .right,
          endPointPreset: .right,
          size: .init(width: 200, height: 400)
        );
        
        let gradientImage = imageConfig.makeImage();
        return gradientImage.cgImage!;
      }(),
      shouldNormalizeEdges: true
    ),
    .variadicBlur(
      radius: 12,
      maskImage: {
        let imageConfig: ImageConfigGradient = ImageConfigGradient(
          colors: [.black, .clear],
          startPointPreset: .bottom,
          endPointPreset: .top,
          size: .init(width: 200, height: 400)
        );
        
        let gradientImage = imageConfig.makeImage();
        return gradientImage.cgImage!;
      }(),
      shouldNormalizeEdges: true
    ),
    .variadicBlur(
      radius: 8,
      maskImage: {
        let imageConfig: ImageConfigGradient = ImageConfigGradient(
          colors: [.black, .clear],
          startPointPreset: .top,
          endPointPreset: .bottom,
          size: .init(width: 200, height: 400)
        );
        
        let gradientImage = imageConfig.makeImage();
        return gradientImage.cgImage!;
      }(),
      shouldNormalizeEdges: true
    ),
  
    .averagedColor,
    .alphaFromLuminance,
    
    .bias(amount: 0.0),
    .bias(amount: 0.2),
    .bias(amount: 0.4),
    .bias(amount: 0.6),
    .bias(amount: 0.8),
    .bias(amount: 1.0),
    
    .brightenColors(amount: 0.0),
    .brightenColors(amount: 0.2),
    .brightenColors(amount: 0.4),
    .brightenColors(amount: 0.6),
    .brightenColors(amount: 0.8),
    .brightenColors(amount: 1.0),
    
    .contrastColors(amount: 0.2),
    .contrastColors(amount: 0.6),
    .contrastColors(amount: 1.2),
    .contrastColors(amount: 1.6),
    .contrastColors(amount: 2.0),
    
    .colorBlackAndWhite(amount: 0.0),
    .colorBlackAndWhite(amount: 0.3),
    .colorBlackAndWhite(amount: 0.6),
    .colorBlackAndWhite(amount: 1.0),
    
    .saturateColors(amount: 0.0),
    .saturateColors(amount: 0.6),
    .saturateColors(amount: 1.0),
    .saturateColors(amount: 2.0),
    .saturateColors(amount: 4.0),
    
    .luminanceCompression(amount: 0.0),
    .luminanceCompression(amount: 0.2),
    .luminanceCompression(amount: 0.4),
    .luminanceCompression(amount: 0.6),
    .luminanceCompression(amount: 0.8),
    .luminanceCompression(amount: 1.0),
    
    .gaussianBlur(radius: 0.0),
    .gaussianBlur(radius: 1.0),
    .gaussianBlur(radius: 2.0),
    .gaussianBlur(radius: 4.0),
    .gaussianBlur(radius: 8.0),
    .gaussianBlur(radius: 16.0),
    
    .darkVibrant(
      isReversed: true,
      color0: UIColor.red.cgColor,
      color1: UIColor.orange.cgColor
    ),
    .darkVibrant(
      isReversed: true,
      color0: UIColor.orange.cgColor,
      color1: UIColor.yellow.cgColor
    ),
    .darkVibrant(
      isReversed: true,
      color0: UIColor.yellow.cgColor,
      color1: UIColor.green.cgColor
    ),
    .darkVibrant(
      isReversed: true,
      color0: UIColor.green.cgColor,
      color1: UIColor.blue.cgColor
    ),
    .darkVibrant(
      isReversed: true,
      color0: UIColor.blue.cgColor,
      color1: UIColor.cyan.cgColor
    ),
    
    .lightVibrant(
      isReversed: true,
      color0: UIColor.red.cgColor,
      color1: UIColor.orange.cgColor
    ),
    .lightVibrant(
      isReversed: true,
      color0: UIColor.orange.cgColor,
      color1: UIColor.yellow.cgColor
    ),
    .lightVibrant(
      isReversed: true,
      color0: UIColor.yellow.cgColor,
      color1: UIColor.green.cgColor
    ),
    .lightVibrant(
      isReversed: true,
      color0: UIColor.green.cgColor,
      color1: UIColor.blue.cgColor
    ),
    .lightVibrant(
      isReversed: true,
      color0: UIColor.blue.cgColor,
      color1: UIColor.cyan.cgColor
    ),
    
    .luminosityCurveMap(
      amount: 0.3,
      values: [0.16, 0.26, 0.10, 0.10]
    ),
    .luminosityCurveMap(
      amount: 0.6,
      values: [0.16, 0.26, 0.10, 0.10]
    ),
    .luminosityCurveMap(
      amount: 0.9,
      values: [0.16, 0.26, 0.10, 0.10]
    ),

    .colorMatrix(
      .init(
        m11: 1.0, m12: 0.0, m13: 0.0, m14: 0.0, m15: 0.0,
        m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0, m25: 0.0,
        m31: 0.0, m32: 0.0, m33: 1.0, m34: 0.0, m35: 0.0,
        m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0, m45: 0.0
      )
    ),
    .colorMatrix(ColorMatrixRGBAPreset.preset01.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset02.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset03.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset04.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset05.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset06.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset07.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset08.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset09.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset10.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset11.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset12.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset13.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset14.colorMatrix),
    .colorMatrix(ColorMatrixRGBAPreset.preset15.colorMatrix),
    
    .colorMatrixVibrant(
      .init(
        m11: 1.0, m12: 0.0, m13: 0.0, m14: 0.0, m15: 0.0,
        m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0, m25: 0.0,
        m31: 0.0, m32: 0.0, m33: 1.0, m34: 0.0, m35: 0.0,
        m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0, m45: 0.0
      )
    ),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset01.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset02.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset03.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset04.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset05.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset06.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset07.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset08.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset09.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset10.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset11.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset12.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset13.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset14.colorMatrix),
    .colorMatrixVibrant(ColorMatrixRGBAPreset.preset15.colorMatrix),
  ];
  
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
      
      let visualEffectView = try? VisualEffectView(rawFilterTypes: []);
      self.visualEffectView = visualEffectView;
      
      visualEffectView?.shouldOnlyShowBgLayer = true;
      // try? visualEffectView?.wrapper?.setBGColorAlphaForBDView(0);
      // try? visualEffectView?.applyRequestedFilterEffects();
      
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
          let backgroundHostWrapper = visualEffectViewWrapper.bgHostWrapped,
          let _ = backgroundHostWrapper.viewContentWrapped
    else {
      return;
    };
    
    //backdropLayer.setValue(window.screen.scale, forKey: "scale")
    
    let prevFilterType =
      self.filterPresets[cyclicIndex: max(self.counter - 1, 0)];
      
    let nextFilterType =
      self.filterPresets[cyclicIndex: self.counter];
      
    print(
      "filterType:", nextFilterType?.decodedFilterName ?? "N/A",
      "\n - counter:", self.counter,
      "\n - filterType:", nextFilterType == nil ? "N/A" : nextFilterType.debugDescription,
      "\n"
    );
    
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
              label: "filter",
              value: nextFilterType?.decodedFilterName ?? "N/A"
            )
          ])
        ];
        
        items += nextFilterType?.filterDescAsAttributedConfig ?? [];
        
        if case let .variadicBlur(_, inputMaskImage, _) = nextFilterType,
           let inputMaskImage = inputMaskImage
        {
          items.append(
            .labelValueDisplay(items: [
              .singeRowWithImageValue(
                label: [
                  .init(text: "inputMaskImage"),
                ],
                image: UIImage(cgImage: inputMaskImage)
              ),
            ])
          );
        };
        
        return items;
      }()
    );
    
    self.cardVC?.applyCardConfig();
    let nextFilterTypes = nextFilterType == nil
      ? []
      : [nextFilterType!];
    
    let shouldSetFilter =
      prevFilterType?.decodedFilterName != nextFilterType?.decodedFilterName;
      
    if shouldSetFilter {
      try! visualEffectView.setFiltersViaEffectDesc(
        withFilterTypes: nextFilterTypes,
        shouldImmediatelyApplyFilter: true
      );
      
      self._didUpdateFilter();
      
    } else {
      try! visualEffectView.updateCurrentFiltersViaEffectDesc(
        withFilterTypes: nextFilterTypes
      );
      
      UIView.animate(withDuration: 0.3){
        try! visualEffectView.applyRequestedFilterEffects();
      } completion: { _ in
        self._didUpdateFilter();
      };
    };
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
    print("effectsForBg", bgEffects);
    
    // empty
    let effectsForContent = visualEffectViewWrapper.effectsForContent;
    print("effectsForContent", effectsForContent);
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
