//
//  VisualEffectDescriptorWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//
import Foundation
import DGSwiftUtilities

/// Wrapper for: `_UIVisualEffectDescriptor`
///
@available(iOS 13, *)
public class VisualEffectDescriptorWrapper: PrivateObjectWrapper<
  NSObject,
  VisualEffectDescriptorWrapper.EncodedString
> {

  public enum EncodedString: String, PrivateObjectWrappingEncodedString {
    case className;
    case filterEntries;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectDescriptor
          return "X1VJVmlzdWFsRWZmZWN0RGVzY3JpcHRvcg==";
          
        case .filterEntries:
          // filterEntries
          return "ZmlsdGVyRW50cmllcw==";
      };
    };
  };
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var filterEntriesWrapped: [VisualEffectFilterEntryWrapper]? {
  
    let result = try? self.performSelector(
      usingEncodedString: .filterEntries,
      type: NSArray.self
    );
    
    guard let result = result else {
      return nil;
    };
    
    return result.compactMap {
      .init(objectToWrap: $0 as AnyObject);
    };
  };
};
