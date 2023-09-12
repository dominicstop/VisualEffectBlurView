//
//  Helpers.swift
//  
//
//  Created by Dominic Go on 9/12/23.
//

import Foundation

class Helpers {

  static func decodeString(_ encodedString: String) -> String? {
    guard let data = Data(base64Encoded: encodedString),
          let string = String(data: data, encoding: .utf8)
    else {
      return nil;
    };
    
    return string;
  };
  
  static func performSelector<T>(
    forObject object: AnyObject,
    selector: Selector,
    type: T.Type = AnyObject
  ) -> T? {
  
    guard object.responds(to: selector),
          let selectorResult = object.perform(selector)
    else { return nil };
    
    let rawValue = selectorResult.takeUnretainedValue();
    return rawValue as? T;
  };
};
