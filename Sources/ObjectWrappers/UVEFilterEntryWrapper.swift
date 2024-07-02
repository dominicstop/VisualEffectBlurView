//
//  UVEFilterEntryWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import Foundation
import DGSwiftUtilities

/// Wrapper for: `_UIVisualEffectFilterEntry`
/// Old name: `VisualEffectFilterEntryWrapper`
///
@available(iOS 12, *)
public class UVEFilterEntryWrapper: PrivateObjectWrapper<
  NSObject,
  UVEFilterEntryWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    /// `filterType`
    case propertyFilterKind;
    
    /// `requestedValues`
    case propertyFilterValuesCurrent;
    
    /// `identityValues`
    case propertyFilterValuesIdentity;
    
    /// `configurationValues`
    case propertyFilterValuesConfig;
    
    /// `setRequestedValues`
    case methodSetFilterValuesCurrent;
    
    /// `setFilterType`
    case methodSetFilterType;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectFilterEntry
          return "X1VJVmlzdWFsRWZmZWN0RmlsdGVyRW50cnk=";
          
        case .propertyFilterKind:
          // filterType
          return "ZmlsdGVyVHlwZQ==";
          
        case .propertyFilterValuesCurrent:
          // requestedValues
          return "cmVxdWVzdGVkVmFsdWVz";
          
        case .propertyFilterValuesIdentity:
          // identityValues
          return "aWRlbnRpdHlWYWx1ZXM=";
          
        case .propertyFilterValuesConfig:
          // configurationValues
          return "Y29uZmlndXJhdGlvblZhbHVlcw==";
          
        case .methodSetFilterValuesCurrent:
          // setRequestedValues:
          return "c2V0UmVxdWVzdGVkVmFsdWVzOg==";
          
        case .methodSetFilterType:
         // setFilterType:
         return "c2V0RmlsdGVyVHlwZTo=";
      };
    };
  };

  // MARK: - Wrapped Properties
  // --------------------------
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSString * filterType;`
  ///
  public var filterKind: String? {
    let result = try? self.performSelector(
      usingEncodedString: .propertyFilterKind,
      type: String.self
    );
    
    return result;
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * requestedValues;`
  /// `-(NSDictionary *)requestedValues;`
  ///
  public var filterValuesCurrent: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .propertyFilterValuesCurrent,
      type: NSDictionary.self
    );
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * identityValues;`
  /// `-(NSDictionary *)identityValues;`
  ///
  public var filterValuesIdentity: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .propertyFilterValuesIdentity,
      type: NSDictionary.self
    );
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * configurationValues;`
  /// `-(NSDictionary *)configurationValues;`
  ///
  public var filterValuesConfig: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .propertyFilterValuesConfig,
      type: NSDictionary.self
    );
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Setter for property:
  /// `@property (nonatomic,copy) NSDictionary * requestedValues;`
  ///
  /// Declaration:
  /// `-(void)setRequestedValues:(NSDictionary *)arg1;`
  ///
  public func setFilterValuesCurrent(_ requestedValues: NSDictionary) throws {
    try self.performSelector(
      usingEncodedString: .methodSetFilterValuesCurrent,
      withArg1: requestedValues
    );
  };
  
  /// Setter for property:
  /// `@property (nonatomic,copy) NSDictionary * configurationValues;
  ///
  /// `-(void)setFilterType:(NSString *)arg1;`
  ///
  public func setFilterKind(_ filterType: String) throws {
    try self.performSelector(
      usingEncodedString: .methodSetFilterType,
      withArg1: filterType as NSString
    );
  };
};
