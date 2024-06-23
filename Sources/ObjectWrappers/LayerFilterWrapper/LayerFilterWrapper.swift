//
//  LayerFilterWrapper.swift
//  
//
//  Created by Dominic Go on 6/20/24.
//

import Foundation
import DGSwiftUtilities

/// Wrapper for: `CAFilter`
/// 
@available(iOS 12, *)
public class LayerFilterWrapper: PrivateObjectWrapper<
  NSObject,
  LayerFilterWrapper.EncodedString
> {
  
  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    case constructorFilterWithType;
    case classMethodFilterTypes;
    case methodSetDefaults;
    
    public var encodedString: String {
      switch self {
        case .className:
          // CAFilter
          return "Q0FGaWx0ZXI==";
        
        case .constructorFilterWithType:
          // filterWithType:
          return "ZmlsdGVyV2l0aFR5cGU6";
          
        case .classMethodFilterTypes:
          // filterTypes
          return "ZmlsdGVyVHlwZXM=";
          
        case .methodSetDefaults:
          // setDefaults
          return "c2V0RGVmYXVsdHM=";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  public static var filterTypes: NSArray? {
    guard let classType = Self.classType else {
      return nil;
    };
    
    return try? Self.performSelector(
      usingHashedString: .classMethodFilterTypes,
      forObject: classType as AnyObject,
      type: NSArray.self
    );
  };
  
  public convenience init?(rawFilterType: String){
    guard let associatedClass = Self.classType else {
      return nil;
    };
    
    let instance = try? Self.performSelector(
      usingHashedString: .constructorFilterWithType,
      forObject: associatedClass,
      withArg1: rawFilterType,
      type: NSObject.self
    );
    
    guard let instance = instance else {
      return nil;
    };
    
    self.init(objectToWrap: instance);
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  public func setInputAmount(_ value: CGFloat){
    guard let wrappedObject = self.wrappedObject else { return };
    wrappedObject.setValue(value, forKey: "inputAmount");
  };
  
  /// Selector:
  /// `-(void)setDefaults;`
  public func setDefaults() throws {
    try self.performSelector(usingEncodedString: .methodSetDefaults);
  };
};


