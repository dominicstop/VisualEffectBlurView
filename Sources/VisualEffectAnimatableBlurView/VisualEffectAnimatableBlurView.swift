//
//  VisualEffectSimplifiedBlurView.swift
//  
//
//  Created by Dominic Go on 10/9/24.
//

import UIKit
import DGSwiftUtilities


public class VisualEffectAnimatableBlurView: VisualEffectBlurView {
  
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
    useAnimationFriendlyWorkaround: Bool = true
  ) throws {
    let nextBlurStyle =
         nextBlurMode.blurEffectStyle
      ?? self.blurEffectStyle
      ?? .regular;
    
    let currentBlurMode = self.currentBlurMode;
    
    if useAnimationFriendlyWorkaround {
      self.clearAnimator();
    };
        
    if nextBlurStyle != self.blurEffectStyle {
      self.blurEffectStyle = nextBlurStyle;
    };
        
    switch (nextBlurMode, useAnimationFriendlyWorkaround) {
      case (.blurEffectNone, _):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported for current iOS version"
          );
        };
        
        self.alpha = 0;
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: 0,
          shouldImmediatelyApply: true,
          shouldAdjustOpacityForOtherSubviews: true
        );
        
      case (.blurEffectSystem, _):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported for current iOS version"
          );
        };
        
        let defaultBlurRadius =
             self.blurEffectStyle?.defaultBlurRadius
          ?? self.defaultBlurRadius;
        
        self.alpha = 1;
        try self.setBlurRadius(
          defaultBlurRadius,
          shouldImmediatelyApply: false
        );
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: 1,
          shouldImmediatelyApply: true,
          shouldAdjustOpacityForOtherSubviews: true
        );
      
      case (let .blurEffectCustomIntensity(_, effectIntensity), true):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported for current iOS version"
          );
        };
        
        self.alpha = 1;
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: effectIntensity,
          shouldImmediatelyApply: true,
          shouldAdjustOpacityForOtherSubviews: true
        );
        
      case (let .blurEffectCustomIntensity(_, effectIntensity), false):
        self.setEffectIntensityViaAnimator(effectIntensity);
        
      case (let .blurEffectCustomBlurRadius(_, customBlurRadius, effectIntensityForOtherEffects), _):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported for current iOS version"
          );
        };
        
        self.alpha = 1;
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: effectIntensityForOtherEffects,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: true
        );
        
        try self.setBlurRadius(
          customBlurRadius,
          shouldImmediatelyApply: false
        );
        
        try self.applyRequestedFilterEffects();
    };
    
    self.previousBlurMode = currentBlurMode;
    self.currentBlurMode = nextBlurMode;
  };
  
  public func createAnimationBlocks(
    applyingBlurMode nextBlurMode: BlurMode
  ) throws -> (
    start: () -> Void,
    end: () -> Void
  ) {
    
    let currentBlurMode = self.currentBlurMode;
    self.clearAnimator();
    
    let isRemovingBlurEffect =
      currentBlurMode.hasBlurEffect && !nextBlurMode.hasBlurEffect;
      
    let isAddingBlurEffect =
      !currentBlurMode.hasBlurEffect && nextBlurMode.hasBlurEffect;
    
    let willChangeBlurEffect =
         currentBlurMode.hasBlurEffect
      && nextBlurMode.hasBlurEffect
      && currentBlurMode.blurEffectStyle != nextBlurMode.blurEffectStyle;
    
    return (
      start: {
      
      },
      end: {
      
      }
    );
  };
};
