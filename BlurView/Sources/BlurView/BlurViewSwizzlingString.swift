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
  
  var encodedString: String {
    switch self {
      case .backgroundHost:
        return "X2JhY2tncm91bmRIb3N0";
        
      case .contentView:
        return "Y29udGVudFZpZXc=";
        
      case .backdropLayer:
        return "YmFja2Ryb3BMYXllcg==";
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
