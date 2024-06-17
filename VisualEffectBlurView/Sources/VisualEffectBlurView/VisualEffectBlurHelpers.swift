//
//  VisualEffectBlurHelpers.swift
//  
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit

public class VisualEffectBlurHelpers {
  
  @discardableResult
  static func performSelector<T>(
    forObject object: AnyObject,
    selector: Selector,
    withArg1 arg1: Any? = nil,
    withArg2 arg2: Any? = nil,
    type: T.Type = AnyObject.self,
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
  
  @discardableResult
  static func performSelector<T>(
    forObject object: AnyObject,
    selectorFromHashedString hashedString: any HashedStringDecodable,
    withArg1 arg1: Any? = nil,
    withArg2 arg2: Any? = nil,
    type: T.Type = AnyObject.self,
    shouldRetainValue: Bool = false
  ) -> T? {
  
    guard let decodedString = hashedString.decodedString else {
      #if DEBUG
      print(
        "VisualEffectBlurHelpers.performSelector",
        "- failed to decode string w/ rawValue:", hashedString.rawValue,
        "- encodedString:", hashedString.encodedString
      );
      #endif
      return nil;
    };
    
    let selector = NSSelectorFromString(decodedString);
    
    return Self.performSelector(
      forObject: object,
      selector: selector,
      withArg1: arg1,
      withArg2: arg2,
      type: type,
      shouldRetainValue: shouldRetainValue
    );
  };
  
  static func lerp<T: FloatingPoint>(
    valueStart: T,
    valueEnd: T,
    percent: T
  ) -> T {
    let valueDelta = valueEnd - valueStart;
    let valueProgress = valueDelta * percent
    return valueStart + valueProgress;
  };
};
