//
//  VisualEffectDescriptorWrapper.swift
//  
//
//  Created by Dominic Go on 9/17/23.
//

import Foundation

// Wrapper for: _UIVisualEffectDescriptor
class VisualEffectDescriptorWrapper: ObjectWrapping {
  
  fileprivate enum EncodedString: String, HashedStringDecodable {
    case filterEntries;
    
    var encodedString: String {
      switch self {
        case .filterEntries:
          // filterEntries
          return "ZmlsdGVyRW50cmllcw==";
      };
    };
  };

  var objectWrapper: ObjectWrapper<AnyObject>;
  
  var filterEntriesWrapped: [VisualEffectFilterEntryWrapper]? {
    guard let effectDescriptor = self.wrappedObject else { return nil };
    
    // NSArray<_UIVisualEffectFilterEntry *>
    let filterEntries = VisualEffectBlurHelpers.performSelector(
      forObject: effectDescriptor,
      selectorFromHashedString: EncodedString.filterEntries,
      type: NSArray.self
    );
    
    guard let filterEntries = filterEntries else {
      #if DEBUG
      print(
        "VisualEffectDescriptorWrapper.filterEntriesWrapped",
        "- failed to get filterEntries"
      );
      #endif
      return nil
    };
    
    return filterEntries.map {
      VisualEffectFilterEntryWrapper(sourceObject: $0 as AnyObject);
    };
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
};
