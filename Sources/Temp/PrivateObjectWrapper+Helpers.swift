//
//  PrivateObjectWrapper+Helpers.swift
//  
//
//  Created by Dominic Go on 6/28/24.
//

import Foundation
import DGSwiftUtilities

public extension PrivateObjectWrapper {
  
  static func createInstance() -> NSObject? {
    guard let classType = Self.classType,
          let classTypeErased = classType as? NSObject.Type
    else {
      return nil;
    };
    
    return classTypeErased.init();
  };
  
  convenience init?(){
    guard let instance = Self.createInstance() else {
      return nil;
    };
    
    self.init(objectToWrap: instance, shouldRetainObject: true);
  };
};
