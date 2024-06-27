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
    case propertyConfigurationValues;
    case methodSetRequestedValues;
    case methodSetFilterType;
    
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
          
        case .propertyConfigurationValues:
          // configurationValues
          return "Y29uZmlndXJhdGlvblZhbHVlcw==";
          
        case .methodSetRequestedValues:
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
  public var filterType: String? {
    let result = try? self.performSelector(
      usingEncodedString: .propertyFilterType,
      type: String.self
    );
    
    return result;
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * requestedValues;`
  /// `-(NSDictionary *)requestedValues;`
  ///
  public var requestedValues: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .propertyRequestedValues,
      type: NSDictionary.self
    );
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * identityValues;`
  /// `-(NSDictionary *)identityValues;`
  ///
  public var identityValues: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .propertyIdentityValues,
      type: NSDictionary.self
    );
  };
  
  /// Declaration:
  /// `@property (nonatomic,copy) NSDictionary * configurationValues;`
  /// `-(NSDictionary *)configurationValues;`
  ///
  public var configurationValues: NSDictionary? {
    return try? self.performSelector(
      usingEncodedString: .propertyConfigurationValues,
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
  public func setRequestedValues(_ requestedValues: NSDictionary) throws {
    try self.performSelector(
      usingEncodedString: .methodSetRequestedValues,
      withArg1: requestedValues
    );
  };
  
  /// Setter for property:
  /// `@property (nonatomic,copy) NSDictionary * configurationValues;
  ///
  /// `-(void)setFilterType:(NSString *)arg1;`
  ///
  public func setFilterType(_ filterType: String) throws {
    try self.performSelector(
      usingEncodedString: .methodSetFilterType,
      withArg1: filterType as NSString
    );
  };
};
