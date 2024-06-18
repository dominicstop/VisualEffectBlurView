//
//  File.swift
//  
//
//  Created by Dominic Go on 9/13/23.
//

import UIKit

extension UIBlurEffect.Style: CaseIterable {

  public static var allCases: [UIBlurEffect.Style] {
    var blurEffects: [Self] = [];
  
    if #available(iOS 10.0, *) {
      blurEffects += [
        .regular,
        .prominent,
        .extraLight,
        .light,
        .dark,
      ];
    };
    
    if #available(iOS 13.0, *) {
      blurEffects += [
        .systemUltraThinMaterial,
        .systemThinMaterial,
        .systemMaterial,
        .systemThickMaterial,
        .systemChromeMaterial,
        .systemUltraThinMaterialLight,
        .systemThinMaterialLight,
        .systemMaterialLight,
        .systemThickMaterialLight,
        .systemChromeMaterialLight,
        .systemUltraThinMaterialDark,
        .systemThinMaterialDark,
        .systemMaterialDark,
        .systemThickMaterialDark,
        .systemChromeMaterialDark,
      ];
    };
    
    return blurEffects;
  };
  
};
