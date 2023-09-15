//
//  VisualEffectBlurHelpers.swift
//  
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit

public class VisualEffectBlurHelpers {

  static func decodeString(_ encodedString: String) -> String? {
    guard let data = Data(base64Encoded: encodedString),
          let string = String(data: data, encoding: .utf8)
    else {
      return nil;
    };
    
    return string;
  };
  
  @discardableResult
  static func performSelector<T>(
    forObject object: AnyObject,
    selector: Selector,
    withArg1 arg1: Any? = nil,
    withArg2 arg2: Any? = nil,
    type: T.Type = AnyObject,
    shouldRetainValue: Bool = false
  ) -> T? {
  
    guard object.responds(to: selector) else { return nil };
    
    let selectorResult: Unmanaged<AnyObject>? = {
      if let arg1 = arg1 {
        return object.perform(selector, with: arg1);
      };
      
      if let arg1 = arg1,
         let arg2 = arg2 {
         
        return object.perform(selector, with: arg1, with: arg2);
      };
      
      return object.perform(selector)
    }();
    
    guard let selectorResult = selectorResult else { return nil };
    
    let rawValue = shouldRetainValue
      ? selectorResult.takeRetainedValue()
      : selectorResult.takeUnretainedValue();
      
    return rawValue as? T;
  };
};
