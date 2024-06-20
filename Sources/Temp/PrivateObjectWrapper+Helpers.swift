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
    let className = EncodedString.className.encodedString;
    return NSClassFromString(className);
  };
  
  convenience init?() {
    guard let associatedClass = Self.associatedClass else {
      return nil;
    };
    
    self.init(objectToWrap: associatedClass, shouldRetainObject: true);
  };
};
