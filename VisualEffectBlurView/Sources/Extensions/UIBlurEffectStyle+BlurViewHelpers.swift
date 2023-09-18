//
//  UIBlurEffectStyle+BlurViewHelpers.swift
//  
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit

extension UIBlurEffect.Style {

  fileprivate static var defaultBlurRadiusCache: Dictionary<Self, CGFloat> = [:];
  fileprivate static var didSetDefaultBlurRadiusCache = false;
  
  static func setDefaultBlurRadiusCacheIfNeeded(){
    guard !self.didSetDefaultBlurRadiusCache else { return };
    Self.didSetDefaultBlurRadiusCache = true;
    
    Self.allCases.forEach {
      let blurView = VisualEffectBlurView(blurEffectStyle: nil);
      blurView.effect = UIBlurEffect(style: $0);
      
      self.defaultBlurRadiusCache[$0] = blurView.blurRadius;
    };
  };
  
  var defaultBlurRadiusFallback: CGFloat? {
    switch self {
      case .regular:
        return 30.0;
        
      case .prominent:
        return 20.0;
        
      case .extraLight:
        return 20.0;
        
      case .light:
        return 30.0;
        
      case .dark:
        return 20.0;
        
      case .systemUltraThinMaterial:
        return 22.5;
        
      case .systemThinMaterial:
        return 29.5;
        
      case .systemMaterial:
        return 29.5;
        
      case .systemThickMaterial:
        return 45.0;
        
      case .systemChromeMaterial:
        return 22.5;
        
      case .systemUltraThinMaterialLight:
        return 22.5;
        
      case .systemThinMaterialLight:
        return 29.5;
        
      case .systemMaterialLight:
        return 29.5;
        
      case .systemThickMaterialLight:
        return 45.0;
        
      case .systemChromeMaterialLight:
        return 22.5;
        
      case .systemUltraThinMaterialDark:
        return 22.5;
        
      case .systemThinMaterialDark:
        return 29.5;
        
      case .systemMaterialDark:
        return 29.5;
        
      case .systemThickMaterialDark:
        return 45.0;
        
      case .systemChromeMaterialDark:
        return 22.5;
  
      @unknown default:
        return nil;
    };
  };

  public var defaultBlurRadius: CGFloat? {
    Self.setDefaultBlurRadiusCacheIfNeeded();
    
    if let blurRadius = Self.defaultBlurRadiusCache[self] {
      return blurRadius;
    };
    
    return self.defaultBlurRadiusFallback;
  };
};



