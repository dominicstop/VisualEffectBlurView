//
//  VisualEffectBlurMode.swift
//  
//
//  Created by Dominic Go on 10/9/24.
//

import UIKit
import DGSwiftUtilities


public enum VisualEffectBlurMode {
  case blurEffectNone;
  
  case blurEffectStandard(blurStyle: UIBlurEffect.Style);
  
  case blurEffectCustomIntensity(
    blurStyle: UIBlurEffect.Style,
    effectIntensity: CGFloat
  );
  
  case blurEffectCustomBlurRadius(
    blurStyle: UIBlurEffect.Style,
    customBlurRadius: CGFloat,
    effectIntensityForOtherEffects: CGFloat
  );
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var blurEffectStyle: UIBlurEffect.Style? {
    switch self {
      case .blurEffectNone:
        return nil;
  
      case let .blurEffectStandard(blurStyle):
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
  
      case .blurEffectStandard:
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
};

// MARK: - VisualEffectBlurMode
// ----------------------------

extension VisualEffectBlurMode: EnumCaseStringRepresentable {

  public var caseString: String {
    switch self {
      case .blurEffectNone:
        return "blurEffectNone";
        
      case .blurEffectStandard:
        return "blurEffectStandard";
        
      case .blurEffectCustomIntensity:
        return "blurEffectCustomIntensity";
        
      case .blurEffectCustomBlurRadius:
        return "blurEffectCustomBlurRadius";
    };
  };
};
