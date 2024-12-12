//
//  VisualEffectBlurTransitionMode.swift
//  
//
//  Created by Dominic Go on 10/9/24.
//

import UIKit
import DGSwiftUtilities


public enum VisualEffectBlurTransitionMode  {

  case noChanges;

  /// `VisualEffectBlurMode.blurEffectSystem`
  /// * changing: `UIBlurEffect.Style`
  ///
  case updatingBlurEffectSystem(
    blurEffectPrev: UIBlurEffect.Style,
    blurEffectNext: UIBlurEffect.Style
  );
  
  /// Transitioning:
  /// * From: `VisualEffectBlurMode.blurEffectNone`
  /// * To: `VisualEffectBlurMode.BlurEffectSystem`
  ///
  case transitioningBlurEffectNoneToBlurEffectSystem(
    blurEffectNext: UIBlurEffect.Style
  );
  
  /// `VisualEffectBlurMode.blurEffectCustomIntensity`
  /// * no change to: `UIBlurEffect.Style`
  /// * updating: `effectIntensity`
  ///
  case updatingBlurEffectCustomIntensity(
    blurEffectCurrent: UIBlurEffect.Style,
    prevEffectIntensity: CGFloat,
    nextEffectIntensity: CGFloat
  );
  
  /// `VisualEffectBlurMode.blurEffectCustomIntensity`
  /// * changing: `UIBlurEffect.Style`,
  /// * updating: `effectIntensity`
  ///
  case changingBlurEffectCustomIntensity(
    blurEffectPrev: UIBlurEffect.Style,
    blurEffectNext: UIBlurEffect.Style,
    customEffectIntensityPrev: CGFloat,
    customEffectIntensityNext: CGFloat
  );
  
  /// Transitioning:
  /// * From: `VisualEffectBlurMode.blurEffectNone`
  /// * To: `VisualEffectBlurMode.blurEffectCustomIntensity`
  ///
  case transitioningFromBlurEffectNoneToBlurEffectCustomIntensity(
    blurEffectNext: UIBlurEffect.Style,
    customEffectIntensityNext: CGFloat
  );
  
  /// `VisualEffectBlurMode.blurEffectCustomBlurRadius`
  /// * no change to: `UIBlurEffect.Style`
  /// * updating: `effectIntensity` + `effectIntensityForOtherEffects`
  ///
  case updatingBlurEffectCustomBlurRadius(
    blurEffectCurrent: UIBlurEffect.Style,
    customBlurRadiusPrev: CGFloat,
    customBlurRadiusNext: CGFloat,
    customEffectIntensityPrev: CGFloat,
    customEffectIntensityNext: CGFloat
  );
  
  /// `VisualEffectBlurMode.blurEffectCustomBlurRadius`
  /// * changing: `UIBlurEffect.Style`
  /// * updating: `effectIntensity` + `effectIntensityForOtherEffects`
  ///
  case changingBlurEffectCustomBlurRadius(
    blurEffectPrev: UIBlurEffect.Style,
    blurEffectNext: UIBlurEffect.Style,
    customBlurRadiusPrev: CGFloat,
    customBlurRadiusNext: CGFloat,
    customEffectIntensityPrev: CGFloat,
    customEffectIntensityNext: CGFloat
  );
  
  /// Transitioning:
  /// * From: `VisualEffectBlurMode.blurEffectNone`
  /// * To: `VisualEffectBlurMode.blurEffectCustomBlurRadius`
  ///
  case transitioningFromBlurEffectNoneToBlurEffectCustomBlurRadius(
    blurEffectNext: UIBlurEffect.Style,
    customBlurRadiusNext: CGFloat,
    customEffectIntensityNext: CGFloat
  );
  
  case transitioningFromDifferentBlurEffectModesWithDifferingBlurEffect(
    blurEffectPrev: UIBlurEffect.Style,
    blurEffectNext: UIBlurEffect.Style,
    blurModePrev: VisualEffectBlurMode,
    blurModeNext: VisualEffectBlurMode
  );
  
  case transitioningFromDifferentBlurEffectModesWithSameBlurEffect(
    blurEffectCurrent: UIBlurEffect.Style,
    blurModePrev: VisualEffectBlurMode,
    blurModeNext: VisualEffectBlurMode
  );
  
  case transitioningToBlurEffectNone(
    blurEffectPrev: UIBlurEffect.Style,
    blurModePrev: VisualEffectBlurMode
  );
  
  case unsupportedTransition(
    blurModePrev: VisualEffectBlurMode,
    blurModeNext: VisualEffectBlurMode
  );
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var isTransitioningFromBlurEffectNoneToAnyBlurMode: Bool {
    switch self {
      case .transitioningBlurEffectNoneToBlurEffectSystem,
           .transitioningFromBlurEffectNoneToBlurEffectCustomIntensity,
           .transitioningFromBlurEffectNoneToBlurEffectCustomBlurRadius:
           
        return true;
        
      case let .unsupportedTransition(blurModePrev, blurModeNext)
             where !blurModePrev.hasBlurEffect && blurModeNext.hasBlurEffect:
             
        return false;
      
      default:
        return false;
    };
  };
  
  public var isTransitioningToBlurEffectNone: Bool {
    switch self {
      case .transitioningToBlurEffectNone:
        return true;
        
      default:
        return false;
    };
  };
  
  public var isChangingBlurEffect: Bool {
    switch self {
      case .noChanges,
           .updatingBlurEffectCustomIntensity,
           .transitioningFromDifferentBlurEffectModesWithSameBlurEffect:
        return false;
        
      case .updatingBlurEffectSystem,
           .updatingBlurEffectCustomBlurRadius,
           .changingBlurEffectCustomIntensity,
           .changingBlurEffectCustomBlurRadius,
           .transitioningBlurEffectNoneToBlurEffectSystem,
           .transitioningFromBlurEffectNoneToBlurEffectCustomIntensity,
           .transitioningFromBlurEffectNoneToBlurEffectCustomBlurRadius,
           .transitioningToBlurEffectNone,
           .transitioningFromDifferentBlurEffectModesWithDifferingBlurEffect:
        return true;
        
      case let .unsupportedTransition(blurModePrev, blurModeNext)
             where blurModePrev.blurEffectStyle != blurModeNext.blurEffectStyle:
        return true;
        
      default:
        return false;
    };
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    blurModePrev: VisualEffectBlurMode,
    blurModeNext: VisualEffectBlurMode
  ){
    switch (blurModePrev, blurModeNext) {
      case (.blurEffectNone, .blurEffectNone):
        self = .noChanges;
        
      case (let blurModePrev, let blurModeNext) where blurModePrev == blurModeNext:
        self = .noChanges;
        
      case (
        .blurEffectNone,
        let .blurEffectSystem(blurEffectStyleNext)
      ):
        self = .transitioningBlurEffectNoneToBlurEffectSystem(
          blurEffectNext: blurEffectStyleNext
        );
        
      case (
        let .blurEffectSystem(blurEffectStylePrev),
        let .blurEffectSystem(blurEffectStyleNext)
      ):
        self = .updatingBlurEffectSystem(
          blurEffectPrev: blurEffectStylePrev,
          blurEffectNext: blurEffectStyleNext
        );
      
      case (
        .blurEffectNone,
        let .blurEffectCustomIntensity(blurStyleNext, effectIntensityNext)
      ):
        self = .transitioningFromBlurEffectNoneToBlurEffectCustomIntensity(
          blurEffectNext: blurStyleNext,
          customEffectIntensityNext: effectIntensityNext
        );
        
      case (
        let .blurEffectCustomIntensity(blurStylePrev, effectIntensityPrev),
        let .blurEffectCustomIntensity(blurStyleNext, effectIntensityNext)
      ) where blurStylePrev == blurStyleNext:
      
        self = .updatingBlurEffectCustomIntensity(
          blurEffectCurrent: blurStylePrev,
          prevEffectIntensity: effectIntensityPrev,
          nextEffectIntensity: effectIntensityNext
        );
        
      case (
        let .blurEffectCustomIntensity(blurStylePrev, effectIntensityPrev),
        let .blurEffectCustomIntensity(blurStyleNext, effectIntensityNext)
      ) where blurStylePrev != blurStyleNext:
      
        self = .changingBlurEffectCustomIntensity(
          blurEffectPrev: blurStylePrev,
          blurEffectNext: blurStyleNext,
          customEffectIntensityPrev: effectIntensityPrev,
          customEffectIntensityNext: effectIntensityNext
        );
        
      case (
        .blurEffectNone,
        let .blurEffectCustomBlurRadius(blurStyleNext, customBlurRadiusNext, effectIntensityNext)
      ):
        
      self = .transitioningFromBlurEffectNoneToBlurEffectCustomBlurRadius(
        blurEffectNext: blurStyleNext,
        customBlurRadiusNext: customBlurRadiusNext,
        customEffectIntensityNext: effectIntensityNext
      );
        
      case (
        let .blurEffectCustomBlurRadius(blurStylePrev, customBlurRadiusPrev, effectIntensityPrev),
        let .blurEffectCustomBlurRadius(blurStyleNext, customBlurRadiusNext, effectIntensityNext)
      ) where blurStylePrev == blurStyleNext:
      
        self = .updatingBlurEffectCustomBlurRadius(
          blurEffectCurrent: blurStylePrev,
          customBlurRadiusPrev: customBlurRadiusPrev,
          customBlurRadiusNext: customBlurRadiusNext,
          customEffectIntensityPrev: effectIntensityPrev,
          customEffectIntensityNext: effectIntensityNext
        );
        
      case (let blurModePrev, let blurModeNext) where
               blurModePrev.hasBlurEffect
            && blurModeNext.hasBlurEffect
            && blurModePrev.blurEffectStyle == blurModeNext.blurEffectStyle:
      
        self = .transitioningFromDifferentBlurEffectModesWithSameBlurEffect(
          blurEffectCurrent: blurModeNext.blurEffectStyle!,
          blurModePrev: blurModePrev,
          blurModeNext: blurModeNext
        );
        
      case (let blurModePrev, let blurModeNext) where
               blurModePrev.hasBlurEffect
            && blurModeNext.hasBlurEffect
            && blurModePrev.blurEffectStyle != blurModeNext.blurEffectStyle:
            
        self = .transitioningFromDifferentBlurEffectModesWithDifferingBlurEffect(
          blurEffectPrev: blurModePrev.blurEffectStyle!,
          blurEffectNext: blurModeNext.blurEffectStyle!,
          blurModePrev: blurModePrev,
          blurModeNext: blurModeNext
        );
        
      case (let blurModePrev, .blurEffectNone) where blurModePrev.hasBlurEffect:
        self = .transitioningToBlurEffectNone(
          blurEffectPrev: blurModePrev.blurEffectStyle!,
          blurModePrev: blurModePrev
        );
    
      default:
        self = .unsupportedTransition(
          blurModePrev: blurModePrev,
          blurModeNext: blurModeNext
        );
    };
  };
};

// MARK: - VisualEffectBlurTransitionMode+EnumCaseStringRepresentable
// ------------------------------------------------------------------

extension VisualEffectBlurTransitionMode: EnumCaseStringRepresentable {
  public var caseString: String {
    switch self {
      case .noChanges:
        return "noChanges";
        
      case .updatingBlurEffectSystem:
        return "updatingBlurEffectSystem";
        
      case .transitioningBlurEffectNoneToBlurEffectSystem:
        return "transitioningBlurEffectNoneToBlurEffectSystem";
  
      case .updatingBlurEffectCustomIntensity:
        return "updatingBlurEffectCustomIntensity";
        
      case .changingBlurEffectCustomIntensity:
        return "changingBlurEffectCustomIntensity";
        
      case .transitioningFromBlurEffectNoneToBlurEffectCustomIntensity:
        return "transitioningFromBlurEffectNoneToBlurEffectCustomIntensity";
        
      case .updatingBlurEffectCustomBlurRadius:
        return "updatingBlurEffectCustomBlurRadius";
        
      case .changingBlurEffectCustomBlurRadius:
        return "changingBlurEffectCustomBlurRadius";
        
      case .transitioningFromBlurEffectNoneToBlurEffectCustomBlurRadius:
        return "transitioningFromBlurEffectNoneToBlurEffectCustomBlurRadius";
        
      case .transitioningFromDifferentBlurEffectModesWithDifferingBlurEffect:
        return "transitioningFromDifferentBlurEffectModesWithDifferingBlurEffect";
        
      case .transitioningFromDifferentBlurEffectModesWithSameBlurEffect:
        return "transitioningFromDifferentBlurEffectModesWithSameBlurEffect";
        
      case .transitioningToBlurEffectNone:
        return "transitioningToBlurEffectNone";
        
      case .unsupportedTransition:
        return "unsupportedTransition";
    };
  };
};
