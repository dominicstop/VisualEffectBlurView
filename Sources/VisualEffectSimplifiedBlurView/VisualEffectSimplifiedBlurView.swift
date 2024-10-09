//
//  VisualEffectSimplifiedBlurView.swift
//  
//
//  Created by Dominic Go on 10/9/24.
//

import UIKit
import DGSwiftUtilities




public class VisualEffectSimplifiedBlurView: VisualEffectBlurView {
  
  public typealias BlurMode = VisualEffectBlurMode;
  
  public var previousBlurMode: BlurMode?;
  
  public var currentBlurMode: BlurMode = .blurEffectNone;
  
  public init(blurMode: BlurMode) throws {
    let blurEffectStyle = blurMode.blurEffectStyle;
    try super.init(blurEffectStyle: blurEffectStyle);
  };

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  public func applyBlurMode(
    _ nextBlurMode: BlurMode,
    useAnimationFriendlyWorkaround: Bool = false
  ) throws {
    let currentBlurMode = self.currentBlurMode;
    
    let willChangeBlurEffect =
      currentBlurMode.blurEffectStyle != nextBlurMode.blurEffectStyle;
      
    if useAnimationFriendlyWorkaround {
      self.clearAnimator();
    };
    
    switch (currentBlurMode, useAnimationFriendlyWorkaround) {
      case (.blurEffectNone, _):
        self.effect = nil;
        
      case (let .blurEffectStandard(blurStyle), _):
        if willChangeBlurEffect {
          let blurEffect = UIBlurEffect(style: blurStyle);
          self.effect = blurEffect;
        };
      
      case (let .blurEffectCustomIntensity(blurStyle, effectIntensity), true):
        if willChangeBlurEffect {
          let blurEffect = UIBlurEffect(style: blurStyle);
          self.effect = blurEffect;
        };
        
        guard #available(iOS 13, *) else {
          fallthrough;
        };
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: effectIntensity,
          shouldImmediatelyApply: true,
          shouldAdjustOpacityForOtherSubviews: true
        );
        
      case (let .blurEffectCustomIntensity(blurStyle, effectIntensity), _):
        if willChangeBlurEffect {
          let blurEffect = UIBlurEffect(style: blurStyle);
          self.effect = blurEffect;
        };
        
        self.setEffectIntensityViaAnimator(effectIntensity);
        
      case (let .blurEffectCustomBlurRadius(blurStyle, customBlurRadius, effectIntensityForOtherEffects), _):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported for current iOS version"
          );
        };
        
        if willChangeBlurEffect {
          let blurEffect = UIBlurEffect(style: blurStyle);
          self.effect = blurEffect;
        };
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: effectIntensityForOtherEffects,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: true
        );
        
        try self.setBlurRadius(customBlurRadius);
        try self.applyRequestedFilterEffects();
    };
    
    self.previousBlurMode = currentBlurMode;
    self.currentBlurMode = nextBlurMode;
  };
  
};
