//
//  VisualEffectBlurMode.swift
//  
//
//  Created by Dominic Go on 10/9/24.
//

import UIKit
import DGSwiftUtilities


public enum VisualEffectBlurMode: Equatable {
  case blurEffectNone;
  
  case blurEffectSystem(blurEffectStyle: UIBlurEffect.Style);
  
  case blurEffectCustomIntensity(
    blurEffectStyle: UIBlurEffect.Style,
    effectIntensity: CGFloat
  );
  
  case blurEffectCustomBlurRadius(
    blurEffectStyle: UIBlurEffect.Style,
    customBlurRadius: CGFloat,
    effectIntensityForOtherEffects: CGFloat
  );
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var blurEffectStyle: UIBlurEffect.Style? {
    switch self {
      case .blurEffectNone:
        return nil;
  
      case let .blurEffectSystem(blurStyle):
        return blurStyle;
      
      case let .blurEffectCustomIntensity(blurStyle, _):
        return blurStyle;
      
      case let .blurEffectCustomBlurRadius(blurStyle, _, _):
        return blurStyle;
    };
  };
  
  public var effectIntensity: CGFloat? {
    switch self {
      case .blurEffectNone:
        return nil;
  
      case .blurEffectSystem:
        return nil;
      
      case let .blurEffectCustomIntensity(_ ,effectIntensity):
        return effectIntensity;
      
      case let .blurEffectCustomBlurRadius(_, _, effectIntensity):
        return effectIntensity;
    };
  };
  
  public var hasBlurEffect: Bool {
    self.blurEffectStyle != nil;
  };
  
  public var customBlurRadius: CGFloat? {
    switch self {
      case let .blurEffectCustomBlurRadius(_, customBlurRadius, _):
        return customBlurRadius;
        
      default:
        return nil;
    };
  };
};

// MARK: - VisualEffectBlurMode
// ----------------------------

extension VisualEffectBlurMode: EnumCaseStringRepresentable {

  public var caseString: String {
    switch self {
      case .blurEffectNone:
        return "blurEffectNone";
        
      case .blurEffectSystem:
        return "blurEffectSystem";
        
      case .blurEffectCustomIntensity:
        return "blurEffectCustomIntensity";
        
      case .blurEffectCustomBlurRadius:
        return "blurEffectCustomBlurRadius";
    };
  };
};
