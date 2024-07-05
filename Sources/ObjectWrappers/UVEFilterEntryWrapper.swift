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
    /// `_UIVisualEffectFilterEntry`
    case className;
    
    /// ```
    /// -(id)initWithFilterType:(id)arg1
    ///     configurationValues:(id)arg2
    ///         requestedValues:(id)arg3
    ///          identityValues:(id)arg4;
    /// ```
    case initializer1;
    
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
    
    /// `setFilterType:`
    case methodSetFilterType;
    
    /// `setIdentityValues:`
    case methodSetFilterValuesIdentity;
    
    /// `setConfigurationValues:`
    case methodFilterValuesConfig;
    
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
         
        case .initializer1:
          // initWithFilterType:configurationValues:requestedValues:identityValues:
          return "aW5pdFdpdGhGaWx0ZXJUeXBlOmNvbmZpZ3VyYXRpb25WYWx1ZXM6cmVxdWVzdGVkVmFsdWVzOmlkZW50aXR5VmFsdWVzOg==";
          
        case .methodSetFilterValuesIdentity:
          // setIdentityValues:
          return "c2V0SWRlbnRpdHlWYWx1ZXM6";
          
        case .methodFilterValuesConfig:
          // setConfigurationValues:
          return "c2V0Q29uZmlndXJhdGlvblZhbHVlcw==";
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
  public var filterValuesRequested: NSDictionary? {
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
  /// `@property (nonatomic,copy) NSString * filterType;    `
  ///
  /// Declaration:
  /// `-(void)setFilterType:(NSString *)arg1;`
  ///
  public func setFilterKind(_ value: String) throws {
    try self.performSelector(
      usingEncodedString: .methodSetFilterType,
      withArg1: value as NSString
    );
  };
  
  /// Setter for property:
  /// `@property (nonatomic,copy) NSDictionary * requestedValues;`
  ///
  /// Declaration:
  /// `-(void)setRequestedValues:(NSDictionary *)arg1;`
  ///
  public func setFilterValuesRequested(_ values: NSDictionary) throws {
    try self.performSelector(
      usingEncodedString: .methodSetFilterValuesCurrent,
      withArg1: values
    );
  };

  /// Setter for property:
  /// `@property (nonatomic,copy) NSDictionary * identityValues;`
  ///
  /// Declaration:
  /// `-(void)setIdentityValues:(NSDictionary *)arg1 ;`
  ///
  public func setFilterValuesIdentity(_ values: NSDictionary) throws {
    try self.performSelector(
      usingEncodedString: .methodSetFilterValuesIdentity,
      withArg1: values
    );
  };
  
  /// Setter for property:
  /// `@property (nonatomic,copy) NSDictionary * configurationValues;`
  ///
  /// Declaration:
  /// `-(void)setConfigurationValues:(NSDictionary *)arg1;`
  ///
  public func setFilterValuesConfig(_ values: NSDictionary) throws {
    try self.performSelector(
      usingEncodedString: .methodFilterValuesConfig,
      withArg1: values
    );
  };

  // MARK: - Init
  // ------------
  
  public convenience init?(
    /// `filterType`
    filterKindRaw: String,
    
    /// `configurationValues`
    filterValuesConfig: Dictionary<String, Any>,
    
    /// `requestedValues`
    filterValuesRequested: Dictionary<String, Any>,
    
    /// `identityValues`
    filterValuesIdentity: Dictionary<String, Any>
  ) throws {
  
    guard let instance = Self.createInstance() else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create instance from class",
        extraDebugValues: [
          "className": EncodedString.className.decodedString ?? "N/A",
        ]
      );
    };
    
    guard let selectorString = Self.EncodedString.initializer1.decodedString else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to decode initializer selector string",
        extraDebugValues: [
          "className": EncodedString.className.decodedString ?? "N/A",
          "encodedString": Self.EncodedString.initializer1.encodedString
        ]
      );
    };
    
    let selectorInit = Selector(selectorString);
    guard instance.responds(to: selectorInit) else {
      throw VisualEffectBlurViewError(
        errorCode: .guardCheckFailed,
        description: "instance does not respond to selector",
        extraDebugValues: [
          "className": EncodedString.className.decodedString ?? "N/A",
          "selectorString": selectorString,
        ]
      );
    };
    
    typealias MethodSignature = @convention(c)(
      /* _self              : */ Any?,
      /* _cmd               : */ Selector,
      /* filterType         : */ NSString,
      /* configurationValues: */ NSDictionary,
      /* requestedValues    : */ NSDictionary,
      /* identityValues     : */ NSDictionary
    ) -> AnyObject;
    
    
    guard let methodInitIMP = instance.method(for: selectorInit) else {
      throw VisualEffectBlurViewError(
        errorCode: .guardCheckFailed,
        description: "Unable to get method IMP",
        extraDebugValues: [
          "className": EncodedString.className.decodedString ?? "N/A",
          "selectorString": selectorString,
        ]
      );
    };
    
    let methodInit = unsafeBitCast(methodInitIMP, to: MethodSignature.self);
    
    let result = methodInit(
      /* _self              : */ instance,
      /* _cmd               : */ selectorInit,
      /* filterType         : */ filterKindRaw         as NSString,
      /* configurationValues: */ filterValuesConfig    as NSDictionary,
      /* requestedValues    : */ filterValuesRequested as NSDictionary,
      /* identityValues     : */ filterValuesIdentity  as NSDictionary
    );
    
    self.init(
      objectToWrap: result,
      shouldRetainObject: true
    );
  };
  
  public convenience init?(
    /// `filterType`
    filterKind: LayerFilterTypeName,
    
    /// `configurationValues`
    filterValuesConfig: Dictionary<String, Any>,
    
    /// `requestedValues`
    filterValuesRequested: Dictionary<String, Any>,
    
    /// `identityValues`
    filterValuesIdentity: Dictionary<String, Any>
  ) throws {
  
    guard let filterKind = filterKind.decodedString else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to decode filterKind",
        extraDebugValues: [
          "encodedString": filterKind.encodedString
        ]
      );
    };
    
    try self.init(
      filterKindRaw: filterKind,
      filterValuesConfig: filterValuesConfig,
      filterValuesRequested: filterValuesRequested,
      filterValuesIdentity: filterValuesIdentity
    );
  };
};
