//
//  VisualEffectFilterEntryWrapper.swift
//  
//
//  Created by Dominic Go on 9/17/23.
//

import Foundation

// Wrapper for: _UIVisualEffectFilterEntry
class VisualEffectFilterEntryWrapper: ObjectWrapping {

  var objectWrapper: ObjectWrapper<AnyObject>;
  
  var filterType: String? {
    guard let filterEntry = self.wrappedObject else { return nil };
  
    let filterType = VisualEffectBlurHelpers.performSelector(
      forObject: filterEntry,
      selector:  NSSelectorFromString("filterType"),
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
      selector: NSSelectorFromString("requestedValues"),
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
      selector: NSSelectorFromString("setRequestedValues:"),
      withArg1: requestedValues
    );
  };
};
