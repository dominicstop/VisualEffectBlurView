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
    let blurEffectStyleInitial = blurEffectStyle ?? .regular;
    
    try super.init(blurEffectStyle: blurEffectStyleInitial);
    try self.applyBlurMode(blurMode);
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
    animation: () -> Void,
    completion: () -> Void
  ) {
    let currentBlurMode = self.currentBlurMode;
    self.clearAnimator();
    
    let transitionMode: VisualEffectBlurTransitionMode = .init(
      blurModePrev: currentBlurMode,
      blurModeNext: nextBlurMode
    );
    
    let commonAnimationBlock = {
      if transitionMode.isTransitioningFromBlurEffectNoneToAnyBlurMode {
        return {
          UIView.addKeyframe(
            withRelativeStartTime: 0,
            relativeDuration: 0.1
          ) {
            self.alpha = 1;
          };
        };
      };
      
      if transitionMode.isTransitioningToBlurEffectNone {
        return {
          UIView.addKeyframe(
            withRelativeStartTime: 0.9,
            relativeDuration: 0.1
          ) {
            self.alpha = 0;
          };
        };
      };
      
      return {
        // no-op
      };
    }();
    
    let commonCompletionBlock = {
      self.previousBlurMode = currentBlurMode;
      self.currentBlurMode = nextBlurMode;
    };
    
    switch transitionMode {
      case .noChanges:
        throw VisualEffectBlurViewError(
          errorCode: .illegalState,
          description: "No changes to animate"
        );
        
      case .transitioningToBlurEffectNone:
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported in current OS version"
          );
        };
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: 0,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: false
        );
        
        return (
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: 0);
            commonAnimationBlock();
          },
          completion: {
            commonCompletionBlock();
          }
        );
        
      case let .updatingBlurEffectSystem(_, blurEffectNext),
           let .transitioningBlurEffectNoneToBlurEffectSystem(blurEffectNext):
        
        return (
          animation: {
            self.blurEffectStyle = blurEffectNext;
            commonAnimationBlock();
          },
          completion: {
            self.blurEffectStyle = blurEffectNext;
            commonCompletionBlock();
          }
        );
        
      case let .transitioningFromBlurEffectNoneToBlurEffectCustomBlurRadius(
        blurEffectNext,
        customBlurRadiusNext,
        customEffectIntensityNext
      ):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported in current OS version"
          );
        };
        
        self.alpha = 0;
        self.blurEffectStyle = blurEffectNext;
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: 0,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: true
        );
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: customEffectIntensityNext,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: false
        );
        
        try self.setBlurRadius(
          customBlurRadiusNext,
          shouldImmediatelyApply: false
        );
        
        return (
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: 0);
            commonAnimationBlock();
          },
          completion: {
            commonCompletionBlock();
          }
        );
        
      case let .transitioningFromBlurEffectNoneToBlurEffectCustomIntensity(
        blurEffectNext,
        customEffectIntensityNext
      ):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported in current OS version"
          );
        };
        
        self.alpha = 0;
        self.blurEffectStyle = blurEffectNext;
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: customEffectIntensityNext,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: false
        );
        
        return (
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: customEffectIntensityNext);
            commonAnimationBlock();
          },
          completion: {
            commonCompletionBlock();
          }
        );
                
      case let .updatingBlurEffectCustomIntensity(_, _, nextEffectIntensity):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported in current OS version"
          );
        };
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: nextEffectIntensity,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: false
        );
        
        return (
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: nextEffectIntensity);
            commonAnimationBlock();
          },
          completion: {
            commonCompletionBlock();
          }
        );
                
      case let .updatingBlurEffectCustomBlurRadius(_, _, customBlurRadiusNext, _, customEffectIntensityNext):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported in current OS version"
          );
        };
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: customEffectIntensityNext,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: false
        );
        
        try self.setBlurRadius(
          customBlurRadiusNext,
          shouldImmediatelyApply: false
        );
        
        return (
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: customEffectIntensityNext);
            commonAnimationBlock();
          },
          completion: {
            commonCompletionBlock();
          }
        );
        
      case let .transitioningFromDifferentBlurEffectModesWithSameBlurEffect(_, _, blurModeNext):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported in current OS version"
          );
        };
        
        let nextEffectIntensity = blurModeNext.effectIntensity ?? 1;
        
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: nextEffectIntensity,
          shouldImmediatelyApply: false,
          shouldAdjustOpacityForOtherSubviews: false
        );
        
        if let customBlurRadius = blurModeNext.customBlurRadius {
          try self.setBlurRadius(
            customBlurRadius,
            shouldImmediatelyApply: false
          );
        };
        
        return (
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: nextEffectIntensity);
            commonAnimationBlock();
          },
          completion: {
            commonCompletionBlock();
          }
        );
      
      case .changingBlurEffectCustomIntensity,
           .changingBlurEffectCustomBlurRadius,
           .transitioningFromDifferentBlurEffectModesWithDifferingBlurEffect,
           .unsupportedTransition:
        
        // animation not supported yet
        try self.applyBlurMode(nextBlurMode);
        break;
    };
    
    throw VisualEffectBlurViewError(
      errorCode: .runtimeError,
      description: "Not supported"
    );
  };
};
