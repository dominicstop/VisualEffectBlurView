//
//  ObjectWrapping.swift
//  
//
//  Created by Dominic Go on 9/18/23.
//

import Foundation

protocol ObjectWrapping {
  associatedtype WrapperType;
  
  var objectWrapper: ObjectWrapper<WrapperType> { get set };
};

extension ObjectWrapping {
  var wrappedObject: WrapperType? {
    self.objectWrapper.object;
  };
};
