//
//  VisualEffectFilterEntryWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import Foundation
import DGSwiftUtilities

/// Wrapper for: `_UIVisualEffectFilterEntry`
/// 
@available(iOS 12, *)
public class VisualEffectFilterEntryWrapper: PrivateObjectWrapper<
  NSObject,
  VisualEffectFilterEntryWrapper.EncodedString
> {

  public enum EncodedString: String, PrivateObjectWrappingEncodedString {
    case className;
    case filterType;
    case requestedValues;
    case setRequestedValues;
    case identityValues;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectFilterEntry
          return "X1VJVmlzdWFsRWZmZWN0RmlsdGVyRW50cnk=";
          
        case .filterType:
          // filterType
          return "ZmlsdGVyVHlwZQ==";
          
        case .requestedValues:
          // requestedValues
          return "cmVxdWVzdGVkVmFsdWVz";
          
        case .setRequestedValues:
          // setRequestedValues:
          return "c2V0UmVxdWVzdGVkVmFsdWVzOg==";
          
        case .identityValues:
          // identityValues
          return "aWRlbnRpdHlWYWx1ZXM=";
      };
    };
  };

  // MARK: - Wrapped Properties
  // --------------------------
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSString * filterType;`
  ///
  public var filterType: String? {
    let result = try? self.performSelector(
      usingEncodedString: .filterType,
      type: String.self
    );
    
    return result;
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * requestedValues;`
  ///
  public var requestedValues: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .requestedValues,
      type: NSDictionary.self
    );
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * identityValues;`
  ///
  public var identityValues: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .identityValues,
      type: NSDictionary.self
    );
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Setter for property:
  /// `@property (nonatomic,copy) NSDictionary * requestedValues;`
  ///
  func setRequestedValues(_ requestedValues: NSDictionary) throws {
    try self.performSelector(
      usingEncodedString: .setRequestedValues,
      withArg1: requestedValues
    );
  };
};
