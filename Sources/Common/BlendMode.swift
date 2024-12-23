//
//  BlendMode.swift
//  
//
//  Created by Dominic Go on 12/23/24.
//

import Foundation


public enum BlendMode: String, CaseIterable {

  case color;
  case colorBurn;
  case colorDodge;
  case darken;
  case difference;
  case divide;
  case exclusion;
  case hardLight;
  case hue;
  case lighten;
  case linearBurn;
  case linearDodge;
  case linearLight;
  case luminosity;
  case multiply;
  case overlay;
  case pinLight;
  case saturation;
  case screen;
  case softLight;
  case subtract;
  case vividLight;
  
  /// e.g. "CIColorBlendMode"
  public var asCIFilterName: String {
    // e.g. "color" -> "Color"
    let firstLetter = self.rawValue.first!.uppercased();
    let remainingLetters = self.rawValue.dropFirst();
    let capitalized = firstLetter + remainingLetters;
    
    let prefix = "CI";
    let suffix = "BlendMode";
    
    // e.g. "CIColorBlendMode"
    return prefix + capitalized + suffix;
  };
  
  /// e.g. "colorBlendMode"
  public var asCompositingFilterName: String {
    self.rawValue + "BlendMode";
  };
};
