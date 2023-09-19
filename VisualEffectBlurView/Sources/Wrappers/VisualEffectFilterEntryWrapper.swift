//
//  VisualEffectFilterEntryWrapper.swift
//  
//
//  Created by Dominic Go on 9/17/23.
//

import Foundation

// Wrapper for: _UIVisualEffectFilterEntry
class VisualEffectFilterEntryWrapper: ObjectWrapping {

  fileprivate enum EncodedString: String, HashedStringDecodable {
    case filterType;
    case requestedValues;
    case setRequestedValues;
    
    var encodedString: String {
      switch self {
        case .filterType:
          // filterType
          return "ZmlsdGVyVHlwZQ==";
          
        case .requestedValues:
          // requestedValues
          return "cmVxdWVzdGVkVmFsdWVz";
          
        case .setRequestedValues:
          // setRequestedValues:
          return "c2V0UmVxdWVzdGVkVmFsdWVzOg==";
      };
    };
  };


  var objectWrapper: ObjectWrapper<AnyObject>;
  
  var filterType: String? {
    guard let filterEntry = self.wrappedObject else { return nil };
  
    let filterType = VisualEffectBlurHelpers.performSelector(
      forObject: filterEntry,
      selectorFromHashedString: EncodedString.filterType,
      type: String.self
    );
    
    guard let filterType = filterType else { return nil };
    return filterType;
  };
  
  var requestedValues: NSDictionary? {
    guard let filterEntry = self.wrappedObject else {
      #if DEBUG
      print(
        "VisualEffectFilterEntryWrapper.requestedValues",
        "- failed to get filterEntry"
      );
      #endif
      return nil;
    };
    
    return VisualEffectBlurHelpers.performSelector(
      forObject: filterEntry,
      selectorFromHashedString: EncodedString.requestedValues,
      type: NSDictionary.self
    );
  };
  
  init(
    sourceObject: AnyObject?,
    shouldRetainObject: Bool = false
  ){
    self.objectWrapper = .init(
      objectToWrap: sourceObject,
      shouldRetainObject: shouldRetainObject
    );
  };
  
  func setRequestedValues(_ requestedValues: NSDictionary){  
    guard let filterEntry = self.wrappedObject else {
      #if DEBUG
      print(
        "VisualEffectFilterEntryWrapper.setRequestedValues",
        "- failed to get filterEntry"
      );
      #endif
      return;
    };
    
    VisualEffectBlurHelpers.performSelector(
      forObject: filterEntry,
      selectorFromHashedString: EncodedString.setRequestedValues,
      withArg1: requestedValues
    );
  };
};
