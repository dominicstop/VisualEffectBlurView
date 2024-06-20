//
//  PrivateObjectWrapper.swift
//  
//
//  Created by Dominic Go on 6/20/24.
//

import Foundation
import DGSwiftUtilities

public extension PrivateObjectWrapper {

  static var associatedClass: AnyClass? {
    guard let className = EncodedString.className.decodedString else {
      return nil;
    };
    
    return NSClassFromString(className);
  };
  
  convenience init?() {
    guard let associatedClass = Self.associatedClass else {
      return nil;
    };
    
    self.init(objectToWrap: associatedClass, shouldRetainObject: true);
  };
};
