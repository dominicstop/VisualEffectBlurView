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

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    case propertyFilterType;
    case propertyRequestedValues;
    case propertyIdentityValues;
    case methodSetRequestedValues;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectFilterEntry
          return "X1VJVmlzdWFsRWZmZWN0RmlsdGVyRW50cnk=";
          
        case .propertyFilterType:
          // filterType
          return "ZmlsdGVyVHlwZQ==";
          
        case .propertyRequestedValues:
          // requestedValues
          return "cmVxdWVzdGVkVmFsdWVz";
          
        case .propertyIdentityValues:
          // identityValues
          return "aWRlbnRpdHlWYWx1ZXM=";
          
        case .methodSetRequestedValues:
          // setRequestedValues:
          return "c2V0UmVxdWVzdGVkVmFsdWVzOg==";
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
      usingEncodedString: .propertyFilterType,
      type: String.self
    );
    
    return result;
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * requestedValues;`
  ///
  public var requestedValues: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .propertyRequestedValues,
      type: NSDictionary.self
    );
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * identityValues;`
  ///
  public var identityValues: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .propertyIdentityValues,
      type: NSDictionary.self
    );
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Setter for property:
  /// `@property (nonatomic,copy) NSDictionary * requestedValues;`
  ///
  public func setRequestedValues(_ requestedValues: NSDictionary) throws {
    try self.performSelector(
      usingEncodedString: .methodSetRequestedValues,
      withArg1: requestedValues
    );
  };
};
