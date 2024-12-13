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
    case methodSetFilterIsEnabled;
    case methodGetFilterIsEnabled;
    
    case propertyFilterInputKeyAmount;
    case propertyFilterInputKeyAngle;
    case propertyFilterInputKeyValues;
    case propertyFilterInputKeyRadius;
    case propertyFilterInputKeyColorMatrix;
    case propertyFilterInputKeyReversed;
    case propertyFilterInputKeyColor0;
    case propertyFilterInputKeyColor1;
    case propertyFilterInputKeyNormalizeEdges;
    case propertyFilterInputKeyMaskImage;
    
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
          
        case .methodSetFilterIsEnabled:
          // `setEnabled:`
          return "c2V0RW5hYmxlZDo=";
          
        case .methodGetFilterIsEnabled:
          // `enabled`
          return "ZW5hYmxlZA==";
          
        case .propertyFilterInputKeyAmount:
          // inputAmount
          return "aW5wdXRBbW91bnQ=";
          
         case .propertyFilterInputKeyAngle:
          // inputAngle
          return "aW5wdXRBbmdsZQ==";
          
        case .propertyFilterInputKeyValues:
          // inputValues
          return "aW5wdXRWYWx1ZXM=";
          
        case .propertyFilterInputKeyRadius:
          // inputRadius
          return "aW5wdXRSYWRpdXM=";
          
        case .propertyFilterInputKeyColorMatrix:
          // inputColorMatrix
          return "aW5wdXRDb2xvck1hdHJpeA==";
          
        case .propertyFilterInputKeyReversed:
          // inputReversed
          return "aW5wdXRSZXZlcnNlZA==";
          
        case .propertyFilterInputKeyColor0:
          // inputColor0
          return "aW5wdXRDb2xvcjA=";
          
        case .propertyFilterInputKeyColor1:
          // inputColor1
          return "aW5wdXRDb2xvcjE=";
          
        case .propertyFilterInputKeyNormalizeEdges:
          // inputNormalizeEdges
          return "aW5wdXROb3JtYWxpemVFZGdlcw==";
          
        case .propertyFilterInputKeyMaskImage:
          // inputMaskImage
          return "aW5wdXRNYXNrSW1hZ2U=";
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
  ///
  public func setDefaults() throws {
    try self.performSelector(usingEncodedString: .methodSetDefaults);
  };
  
    /// Selector:
  /// `-(void)setEnabled:(BOOL)arg1 ;`
  ///
  public func setFilterIsEnabled(_ isEnabled: Bool) throws {
    try self.performSelector(
      usingEncodedString: .methodSetFilterIsEnabled,
      withArg1: isEnabled
  /// Selector:
  /// `-(BOOL)enabled;`
  /// 
  public func getFilterIsEnabled() throws -> Bool {
    let value = try self.getValue(
      forHashedString: .methodGetFilterIsEnabled,
      type: Bool.self
    );
    
    guard let value = value else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value for property"
      );
    };
    
    return value;
  };
  
  // MARK: - Property Setters
  // ------------------------
  
  /// Set `inputAmount`
  public func setFilterValue(amount value: CGFloat) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyAmount,
      value: value
    );
  };
  
  /// Set `inputAngle`
  public func setFilterValue(angle: CGFloat) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyAngle,
      value: angle
    );
  };
  
  /// Set `inputValues`
  public func setFilterValue(values value: [CGFloat]) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyValues,
      value: value
    );
  };
  
  /// Set `inputRadius`
  public func setFilterValue(radius value: CGFloat) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyRadius,
      value: value
    );
  };
  
  /// Set `inputColorMatrix`
  public func setFilterValue(colorMatrix value: ColorMatrixRGBA) throws {
    let colorMatrixObjcValue = value.objcValue;
    try self.setValue(
      forHashedString: .propertyFilterInputKeyColorMatrix,
      value: colorMatrixObjcValue
    );
  };
  
  /// Set `inputReversed`
  public func setFilterValue(isReversed value: Bool) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyReversed,
      value: value ? 1 : 0
    );
  };
  
  /// Set `inputColor0`
  public func setFilterValue(color0 value: CGColor) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyColor0,
      value: value
    );
  };
  
  /// Set `inputColor1`
  public func setFilterValue(color1 value: CGColor) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyColor1,
      value: value
    );
  };
  
  /// Set `inputNormalizeEdges`
  public func setFilterValue(shouldNormalizeEdges value: Bool) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyNormalizeEdges,
      value: value ? 1 : 0
    );
  };
  
  /// Set `inputMaskImage`
  public func setFilterValue(maskImage value: CGImage?) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyMaskImage,
      value: value
    );
  };
  
  // MARK: - Method Alias
  // --------------------
  
  /// Set `inputColor0`
  public func setFilterValue(color0 value: UIColor) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyColor0,
      value: value.cgColor
    );
  };
  
  /// Set `inputColor1`
  public func setFilterValue(color1 value: UIColor) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyColor1,
      value: value.cgColor
    );
  };
  
  /// Set `inputMaskImage`
  public func setFilterValue(maskImage value: UIImage) throws {
    try self.setValue(
      forHashedString: .propertyFilterInputKeyMaskImage,
      value: value.cgImage!
    );
  };
};


