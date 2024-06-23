//
//  UIVibrancyEffectStyle+EnumCaseStringRepresentable.swift
//
//
//  Created by Dominic Go on 6/22/24.
//

import UIKit
import DGSwiftUtilities

@available(iOS 13.0, *)
extension UIVibrancyEffectStyle: EnumCaseStringRepresentable  {

  public var caseString: String {
    switch self {
      case .label:
        return "label";
        
      case .secondaryLabel:
        return "secondaryLabel";
        
      case .tertiaryLabel:
        return "tertiaryLabel";
        
      case .quaternaryLabel:
        return "quaternaryLabel";
        
      case .fill:
        return "fill";
        
      case .secondaryFill:
        return "secondaryFill";
        
      case .tertiaryFill:
        return "tertiaryFill";
        
      case .separator:
        return "separator";
        
      @unknown default:
        return "default";
    };
  }
};
