//
//  ObjectWrapper+Helpers.swift
//  
//
//  Created by Dominic Go on 6/20/24.
//

import Foundation
import DGSwiftUtilities


public extension ObjectWrapper {

  @discardableResult
  static func performSelector<T>(
    usingHashedString encodedString: EncodedString,
    forObject object: AnyObject,
    withArg1 arg1: Any? = nil,
    withArg2 arg2: Any? = nil,
    type: T.Type = Any.self,
    shouldRetainValue: Bool = false
  ) throws -> T? {
  
    return try ObjectWrapperHelpers.performSelector(
      forObject: object,
      selectorFromHashedString: encodedString,
      withArg1: arg1,
      withArg2: arg2,
      type: type,
      shouldRetainValue: shouldRetainValue
    );
  };
  
  @discardableResult
  func getValue<T>(
    forHashedString encodedString: EncodedString,
    type: T.Type = Any.self
  ) throws -> T? {
    guard let wrappedObject = self.wrappedObject as? NSObject,
          let key = encodedString.decodedString
    else { return nil };
    
    let value = wrappedObject.value(forKey: key);
    return value as? T;
  };
  
  func setValue<T>(
    forHashedString encodedString: EncodedString,
    value: T?
  ) throws {
    guard let wrappedObject = self.wrappedObject as? NSObject,
          let key = encodedString.decodedString
    else { return };
    
    wrappedObject.setValue(value, forKey: key);
  };
};
