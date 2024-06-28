//
//  LayerFilterWrapper.swift
//  
//
//  Created by Dominic Go on 6/20/24.
//

import UIKit
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
    case classMethodFilterWithType;
    case classMethodFilterTypes;
    case methodSetDefaults;
    
    public var encodedString: String {
      switch self {
        case .className:
          // CAFilter
          return "Q0FGaWx0ZXI==";
        
        case .classMethodFilterWithType:
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
      usingHashedString: .classMethodFilterWithType,
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
  
  /// Selector:
  /// `-(void)setDefaults;`
  public func setDefaults() throws {
    try self.performSelector(usingEncodedString: .methodSetDefaults);
  };
  
  public func setInputAmount(_ value: CGFloat){
    guard let wrappedObject = self.wrappedObject else { return };
    wrappedObject.setValue(value, forKey: "inputAmount");
  };
  
  public func setInputValues(_ value: [CGFloat]){
    guard let wrappedObject = self.wrappedObject else { return };
    wrappedObject.setValue(value, forKey: "inputValues");
  };
  
  public func setInputRadius(_ value: CGFloat){
    guard let wrappedObject = self.wrappedObject else { return };
    wrappedObject.setValue(value, forKey: "inputRadius");
  };
  
  public func setInputColorMatrix(_ value: ColorMatrixRGBA){
    guard let wrappedObject = self.wrappedObject else { return };
    let colorMatrixObjcValue = value.objcValue;
    wrappedObject.setValue(colorMatrixObjcValue, forKey: "inputColorMatrix");
  };
  
  public func setInputReversed(_ value: Bool){
    guard let wrappedObject = self.wrappedObject else { return };
    wrappedObject.setValue(
      value ? 1 : 0,
      forKey: "inputReversed"
    );
  };
  
  public func setInputColor0(_ value: CGColor){
    guard let wrappedObject = self.wrappedObject else { return };
    wrappedObject.setValue(value, forKey: "inputColor0");
  };
  
  public func setInputColor1(_ value: CGColor){
    guard let wrappedObject = self.wrappedObject else { return };
    wrappedObject.setValue(value, forKey: "inputColor1");
  };
};


