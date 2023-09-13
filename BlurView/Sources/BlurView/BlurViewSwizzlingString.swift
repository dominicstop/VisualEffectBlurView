//
//  BlurViewSwizzlingString.swift
//  
//
//  Created by Dominic Go on 9/12/23.
//

import Foundation

enum BlurViewSwizzlingString: String {
  case backgroundHost;
  case contentView;
  case backdropLayer;
  case effectDescriptorForEffectsUsage;
  
  var encodedString: String {
    switch self {
      case .backgroundHost:
        // _backgroundHost
        return "X2JhY2tncm91bmRIb3N0";
        
      case .contentView:
        // contentView
        return "Y29udGVudFZpZXc=";
        
      case .backdropLayer:
        // _backdropLayer
        return "YmFja2Ryb3BMYXllcg==";
        
      case .effectDescriptorForEffectsUsage:
        // _effectDescriptorForEffects:usage:
        return "X2VmZmVjdERlc2NyaXB0b3JGb3JFZmZlY3RzOnVzYWdlOg==";
    };
  };
  
  var decodedString: String? {
    let encodedString = self.encodedString;
    
    guard let decodedString = Helpers.decodeString(encodedString) else {
      #if DEBUG
      print(
        "BlurViewSwizzlingString.decodedString",
        " - rawValue: \(self.rawValue)",
        " - couldn't decode string"
      );
      #endif
      return nil;
    };
    
    return decodedString;
  };
};
