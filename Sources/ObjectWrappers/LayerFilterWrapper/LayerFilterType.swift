//
//  LayerFilterType.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import UIKit


public enum LayerFilterType {
  // case multiplyColor;
  // case colorAdd;
  // case colorSubtract;
  // case colorInvert;
  // case colorHueRotate;
  // case meteor;
  // case distanceField;
  // case luminanceMap;
  // case lanczosResize;
  // case pageCurl;
  
  case luminanceToAlpha;
  case averageColor;
  
  case curves(
    inputAmount: CGFloat,
    inputValues: [CGFloat]
  );
  
  case luminanceCurveMap(
    inputAmount: CGFloat,
    inputValues: [CGFloat]
  );

  case colorMonochrome(inputAmount: CGFloat);
  case colorSaturate(inputAmount: CGFloat);
  case colorBrightness(inputAmount: CGFloat);
  case colorContrast(inputAmount: CGFloat);
  case compressLuminance(inputAmount: CGFloat)
  case bias(inputAmount: CGFloat);
  
  case gaussianBlur(inputRadius: CGFloat);
  
  case vibrantDark(
    inputReversed: Bool,
    inputColor0: CGColor,
    inputColor1: CGColor
  );
  
  case vibrantLight(
    inputReversed: Bool,
    inputColor0: CGColor,
    inputColor1: CGColor
  );
  
  case vibrantColorMatrix(colorMatrix: ColorMatrixRGBA);
  case colorMatrix(colorMatrix: ColorMatrixRGBA);
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var associatedFilterTypeName: LayerFilterTypeName {
    switch self {
      // case .multiplyColor:
      //   return .multiplyColor;
      //
      // case .colorAdd:
      //   return .colorAdd;
      //
      // case .colorSubtract:
      //   return .colorSubtract;
        
      case .colorMonochrome:
        return .colorMonochrome;
        
      case .colorMatrix:
        return .colorMatrix;
        
      // case .colorHueRotate:
      //   return .colorHueRotate;
        
      case .colorSaturate:
        return .colorSaturate;
        
      case .colorBrightness:
        return .colorBrightness;
        
      case .colorContrast:
        return .colorContrast;
        
      // case .colorInvert:
      //   return .colorInvert;
        
      case .compressLuminance:
        return .compressLuminance;
        
      // case .meteor:
      //   return .meteor;
        
      case .luminanceToAlpha:
        return .luminanceToAlpha;
        
      case .bias:
        return .bias;
        
      // case .distanceField:
      //   return .distanceField;
        
      case .gaussianBlur:
        return .gaussianBlur;
        
      // case .luminanceMap:
      //   return .luminanceMap;
        
       case .luminanceCurveMap:
         return .luminanceCurveMap;
        
       case .curves:
         return .curves;
        
      case .averageColor:
        return .averageColor;
        
      // case .lanczosResize:
      //   return .lanczosResize;
        
      // case .pageCurl:
      //   return .pageCurl;
        
      case .vibrantDark:
        return .vibrantDark;
        
      case .vibrantLight:
        return .vibrantLight;
        
      case .vibrantColorMatrix:
        return .vibrantColorMatrix;
    };
  };
  
  public var decodedFilterName: String? {
    self.associatedFilterTypeName.decodedString;
  };
  
  // MARK:
  
  public init?(fromWrapper wrapper: VisualEffectFilterEntryWrapper){
    let filterTypeName: LayerFilterTypeName? = {
      guard let filterType = wrapper.filterType else {
        return nil;
      };
      
      return .init(rawValue: filterType);
    }();
    
    guard let filterTypeName = filterTypeName,
          let requestedValues = wrapper.requestedValues,
          let configurationValues = wrapper.configurationValues
    else {
      return nil;
    };
    
    switch filterTypeName {
      case .luminanceToAlpha:
        self = .luminanceToAlpha;
        
      case .averageColor:
        self = .averageColor;
        
      case .colorMonochrome:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .colorMonochrome(inputAmount: inputAmount);
        
      case .colorSaturate:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .colorSaturate(inputAmount: inputAmount);
        
      case .colorBrightness:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .colorBrightness(inputAmount: inputAmount);
        
      case .colorContrast:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .colorContrast(inputAmount: inputAmount);
        
      case .compressLuminance:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .compressLuminance(inputAmount: inputAmount);
        
      case .bias:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .bias(inputAmount: inputAmount);
        
      case .curves:
        guard let inputAmount = requestedValues.inputAmount,
              let inputValues = configurationValues.inputValues  else {
          return nil;
        };
        
        self = .curves(
          inputAmount: inputAmount,
          inputValues: inputValues
        );
        
      case .luminanceCurveMap:
        guard let inputAmount = requestedValues.inputAmount,
              let inputValues = configurationValues.inputValues  else {
          return nil;
        };
        
        self = .luminanceCurveMap(
          inputAmount: inputAmount,
          inputValues: inputValues
        );
        
      case .gaussianBlur:
        guard let inputRadius = requestedValues.inputRadius else {
          return nil;
        };
        
        self = .gaussianBlur(inputRadius: inputRadius);
        
      case .vibrantDark:
        guard let inputReversed = requestedValues.inputReversed,
              let inputColor0 = requestedValues.inputColor0,
              let inputColor1 = requestedValues.inputColor1
        else {
          return nil;
        };
        
        self = .vibrantDark(
          inputReversed: inputReversed,
          inputColor0: inputColor0,
          inputColor1: inputColor1
        );
        
      case .vibrantLight:
        guard let inputReversed = requestedValues.inputReversed,
              let inputColor0 = requestedValues.inputColor0,
              let inputColor1 = requestedValues.inputColor1
        else {
          return nil;
        };
        
        self = .vibrantLight(
          inputReversed: inputReversed,
          inputColor0: inputColor0,
          inputColor1: inputColor1
        );
        
      case .vibrantColorMatrix:
        guard let inputColorMatrix = requestedValues.inputColorMatrix else {
          return nil;
        };
        
        self = .vibrantColorMatrix(colorMatrix: inputColorMatrix);
        
      case .colorMatrix:
        guard let inputColorMatrix = requestedValues.inputColorMatrix else {
          return nil;
        };
        
        self = .colorMatrix(colorMatrix: inputColorMatrix);
        
      default:
        return nil;
    };
  };
};


// TEMP
fileprivate extension NSDictionary {
  var inputAmount: CGFloat? {
    guard let inputAmountRaw = self["inputAmount"],
          let inputAmount = inputAmountRaw as? CGFloat
    else {
      return nil;
    };
    
    return inputAmount;
  };
  
  var inputRadius: CGFloat? {
    guard let inputRadiusRaw = self["inputRadius"],
          let inputRadius = inputRadiusRaw as? CGFloat
    else {
      return nil;
    };
    
    return inputRadius;
  };
  
  var inputReversed: Bool? {
    guard let inputReversedRaw = self["inputReversed"],
          let inputReversed = inputReversedRaw as? NSNumber
    else {
      return nil;
    };
    
    return inputReversed.boolValue;
  };
  
  var inputColor0: CGColor? {
    guard let inputColor0Raw = self["inputColor0"] else {
      return nil;
    };
    
    return (inputColor0Raw as! CGColor);
  };
  
  var inputColor1: CGColor? {
    guard let inputColor1Raw = self["inputColor1"] else {
      return nil;
    };
    
    return (inputColor1Raw as! CGColor);
  };
  
  var inputColorMatrix: ColorMatrixRGBA? {
    guard let inputColorMatrixRaw = self["inputColorMatrix"],
          let inputColorMatrix = inputColorMatrixRaw as? NSValue
    else {
      return nil;
    };
    
    return .init(fromValue: inputColorMatrix);
  };
  
  var inputValues: [CGFloat]? {
    guard let inputValuesRaw = self["inputValues"],
          let inputValues = inputValuesRaw as? NSArray
    else {
      return nil;
    };
    
    return inputValues.compactMap {
      $0 as? CGFloat;
    };
  };
};
