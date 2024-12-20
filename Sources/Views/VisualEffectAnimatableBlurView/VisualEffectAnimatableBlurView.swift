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
      self.displayNow();
      self.applyBackgroundLayerSamplingSizeScaleIfNeeded();
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
        
        self.alpha = effectIntensity <= 0 ? 0 : 1;
        try self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: effectIntensity,
          shouldImmediatelyApply: true,
          shouldAdjustOpacityForOtherSubviews: true
        );
        
      case (let .blurEffectCustomIntensity(_, effectIntensity), false):
        self.alpha = 1;
        self.setEffectIntensityViaAnimator(effectIntensity);
        
      case (let .blurEffectCustomBlurRadius(_, customBlurRadius, effectIntensityForOtherEffects), _):
        guard #available(iOS 13, *) else {
          throw VisualEffectBlurViewError(
            errorCode: .runtimeError,
            description: "Not supported for current iOS version"
          );
        };
        
        self.alpha = {
          guard customBlurRadius <= 0,
                effectIntensityForOtherEffects <= 0
          else {
            return 1;
          };
          
          return 0;
        }();
        
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
    applyingBlurMode nextBlurMode: BlurMode,
    currentBlurMode: BlurMode? = nil,
    shouldAnimateAlpha: Bool = false
  ) throws -> (
    setup: () throws -> Void,
    animation: () -> Void,
    completion: () -> Void
  ) {
    let currentBlurMode = currentBlurMode ?? self.currentBlurMode;
    self.clearAnimator();
    
    let transitionMode: VisualEffectBlurTransitionMode = .init(
      blurModePrev: currentBlurMode,
      blurModeNext: nextBlurMode
    );
    
    let commonSetupBlock = {
      self.alpha = 1;
      self.applyBackgroundLayerSamplingSizeScaleIfNeeded();
    }
    
    let commonAnimationBlock: Optional<() -> Void> = {
      guard shouldAnimateAlpha else {
        return nil;
      };
        
      let relativeDuration: CGFloat = 1 / 15;
      
      if transitionMode.isTransitioningFromBlurEffectNoneToAnyBlurMode {
        return {
          UIView.addKeyframe(
            withRelativeStartTime: 0,
            relativeDuration: 0
          ) {
            self.alpha = 0;
          };
          
          UIView.addKeyframe(
            withRelativeStartTime: 0 + relativeDuration,
            relativeDuration: relativeDuration
          ) {
            self.alpha = 1;
          };
        };
      };
      
      if transitionMode.isTransitioningToBlurEffectNone {
        return {
          UIView.addKeyframe(
            withRelativeStartTime: 1.0 - (relativeDuration * 2),
            relativeDuration: 0
          ) {
            self.alpha = 1;
          };
          
          UIView.addKeyframe(
            withRelativeStartTime: 1 - relativeDuration,
            relativeDuration: relativeDuration
          ) {
            self.alpha = 0;
          };
        };
      };
      
      return nil;
    }();
    
    let commonCompletionBlock = {
      self.previousBlurMode = currentBlurMode;
      self.currentBlurMode = nextBlurMode;
      
      if transitionMode.isTransitioningToBlurEffectNone {
        self.alpha = 0;
      };
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
        
        return (
          setup: {
            try self.setEffectIntensityViaEffectDescriptor(
              intensityPercent: 0,
              shouldImmediatelyApply: false,
              shouldAdjustOpacityForOtherSubviews: false
            );
            
            commonSetupBlock();
          },
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: 0);
            commonAnimationBlock?();
          },
          completion: {
            commonCompletionBlock();
          }
        );
        
      case let .transitioningBlurEffectNoneToBlurEffectSystem(blurEffectNext):
        return (
          setup: {
            self.blurEffectStyle = nil;
            commonSetupBlock();
          },
          animation: {
            self.blurEffectStyle = blurEffectNext;
            self.setOpacityForOtherSubviews(newOpacity: 1);
            commonAnimationBlock?();
          },
          completion: {
            self.blurEffectStyle = blurEffectNext;
            commonCompletionBlock();
          }
        );
        
      case let .updatingBlurEffectSystem(_, blurEffectNext):
        return (
          setup: {
            commonSetupBlock();
          },
          animation: {
            self.blurEffectStyle = blurEffectNext;
            self.setOpacityForOtherSubviews(newOpacity: 1);
            commonAnimationBlock?();
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
        
        return (
          setup: {
            self.alpha = 0.01;
            if blurEffectNext != self.blurEffectStyle {
              self.blurEffectStyle = blurEffectNext;
              self.displayNow();
            };
            
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
            
            commonSetupBlock();
          },
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: 0);
            commonAnimationBlock?();
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
        
        return (
          setup: {
            self.alpha = 0.01;
            if blurEffectNext != self.blurEffectStyle {
              self.blurEffectStyle = blurEffectNext;
              self.displayNow();
            };
            
            try self.setEffectIntensityViaEffectDescriptor(
              intensityPercent: customEffectIntensityNext,
              shouldImmediatelyApply: false,
              shouldAdjustOpacityForOtherSubviews: false
            );
            
            commonSetupBlock();
          },
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: customEffectIntensityNext);
            commonAnimationBlock?();
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
        
        return (
          setup: {
            try self.setEffectIntensityViaEffectDescriptor(
              intensityPercent: nextEffectIntensity,
              shouldImmediatelyApply: false,
              shouldAdjustOpacityForOtherSubviews: false
            );
            commonSetupBlock();
          },
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: nextEffectIntensity);
            commonAnimationBlock?();
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
      
        return (
          setup: {
            self.alpha = 1;
            try self.setEffectIntensityViaEffectDescriptor(
              intensityPercent: customEffectIntensityNext,
              shouldImmediatelyApply: false,
              shouldAdjustOpacityForOtherSubviews: false
            );
            
            try self.setBlurRadius(
              customBlurRadiusNext,
              shouldImmediatelyApply: false
            );
            
            commonSetupBlock();
          },
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: customEffectIntensityNext);
            commonAnimationBlock?();
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
        
        return (
          setup: {
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
            
            commonSetupBlock();
          },
          animation: {
            try? self.applyRequestedFilterEffects();
            self.setOpacityForOtherSubviews(newOpacity: nextEffectIntensity);
            commonAnimationBlock?();
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
        commonSetupBlock();
        break;
    };
    
    throw VisualEffectBlurViewError(
      errorCode: .runtimeError,
      description: "Not supported"
    );
  };
  
  public func createCancellableAnimationBlocks(
    applyingBlurMode nextBlurMode: BlurMode
  ) throws -> (
    setup: () throws -> Void,
    animation: () -> Void,
    animationCompletion: () -> Void,
    cancelAnimation: () -> Void,
    cancelAnimationCompletion: () -> Void
  ) {
    let currentBlurMode = self.currentBlurMode;
    
    let animationBlocks = try self.createAnimationBlocks(
      applyingBlurMode: nextBlurMode
    );
    
    let cancelAnimationBlocks = try self.createAnimationBlocks(
      applyingBlurMode: currentBlurMode,
      currentBlurMode: nextBlurMode
    );
    
    return (
      setup: {
        try animationBlocks.setup();
      },
      animation: {
        animationBlocks.animation();
      },
      animationCompletion: {
        animationBlocks.completion();
      },
      cancelAnimation: {
        try? cancelAnimationBlocks.setup();
        cancelAnimationBlocks.animation();
      },
      cancelAnimationCompletion: {
        cancelAnimationBlocks.completion();
      }
    );
  };
};
