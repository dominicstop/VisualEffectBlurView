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
      let blurView = VisualEffectBlurView(blurEffectStyle: $0);
      self.defaultBlurRadiusCache[$0] = blurView.blurRadius;
    };
  };

  public var defaultBlurRadius: CGFloat? {
    Self.setDefaultBlurRadiusCacheIfNeeded();
    return Self.defaultBlurRadiusCache[self];
  };
};



