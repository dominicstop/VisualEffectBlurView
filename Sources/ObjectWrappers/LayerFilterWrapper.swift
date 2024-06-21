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

  public enum EncodedString: String, PrivateObjectWrappingEncodedString {
    case className;
    case constructorFilterWithType;
    case classMethodFilterTypes;
    
    public var encodedString: String {
      switch self {
        case .className:
          // CAFilter
          return "Q0FGaWx0ZXI==";
        
        case .constructorFilterWithType:
          // filterWithType:
          return "ZmlsdGVyV2l0aFR5cGU6";
          
        case .classMethodFilterTypes:
          return "";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  public static var filterTypes: Any? {
    guard let associatedClass = Self.classType else {
      return nil;
    };
    
    return try? Self.performSelector(
      usingHashedString: .classMethodFilterTypes,
      forObject: associatedClass
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
};


