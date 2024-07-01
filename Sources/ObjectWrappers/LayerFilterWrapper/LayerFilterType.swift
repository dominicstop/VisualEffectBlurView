//
//  LayerFilterType.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import UIKit


public enum LayerFilterType {

  // case colorBlendingModeMultiply;
  // case colorBlendingModeAdd;
  // case colorBlendingModeSubtract;
  // case invertColors;
  // case colorHueAdjust;
  // case meteor;
  // case distanceField;
  // case luminanceCompression;
  // case lanczosResampling;
  // case pageCurl;
  
  case alphaFromLuminance;
  case averagedColor;
  
  case curves(
    inputAmount: CGFloat,
    inputValues: [CGFloat]
  );
  
  case luminosityCurveMap(
    inputAmount: CGFloat,
    inputValues: [CGFloat]
  );

  case colorBlackAndWhite(inputAmount: CGFloat);
  case saturateColors(inputAmount: CGFloat);
  case brightenColors(inputAmount: CGFloat);
  case contrastColors(inputAmount: CGFloat);
  case luminanceCompression(inputAmount: CGFloat)
  case bias(inputAmount: CGFloat);
  
  case gaussianBlur(
    inputRadius: CGFloat,
    inputNormalizeEdges: Bool = true
  );
  
  case darkVibrant(
    inputReversed: Bool,
    inputColor0: CGColor,
    inputColor1: CGColor
  );
  
  case lightVibrant(
    inputReversed: Bool,
    inputColor0: CGColor,
    inputColor1: CGColor
  );
  
  case colorMatrixVibrant(_ colorMatrix: ColorMatrixRGBA);
  case colorMatrix(_ colorMatrix: ColorMatrixRGBA);
  
  case variadicBlur(
    inputRadius: CGFloat,
    inputMaskImage: CGImage,
    inputNormalizeEdges: Bool
  );
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var associatedFilterTypeName: LayerFilterTypeName {
    switch self {
      // case .colorBlendingModeMultiply:
      //   return .colorBlendingModeMultiply;
      //
      // case .colorBlendingModeAdd:
      //   return .colorBlendingModeAdd;
      //
      // case .colorBlendingModeSubtract:
      //   return .colorBlendingModeSubtract;
        
      case .colorBlackAndWhite:
        return .colorBlackAndWhite;
        
      case .colorMatrix:
        return .colorMatrix;
        
      // case .colorHueAdjust:
      //   return .colorHueAdjust;
        
      case .saturateColors:
        return .saturateColors;
        
      case .brightenColors:
        return .brightenColors;
        
      case .contrastColors:
        return .contrastColors;
        
      // case .invertColors:
      //   return .invertColors;
        
      case .luminanceCompression:
        return .luminanceCompression;
        
      // case .meteor:
      //   return .meteor;
        
      case .alphaFromLuminance:
        return .alphaFromLuminance;
        
      case .bias:
        return .bias;
        
      // case .distanceField:
      //   return .distanceField;
        
      case .gaussianBlur:
        return .gaussianBlur;
        
      // case .luminanceCompression:
      //   return .luminanceCompression;
        
       case .luminosityCurveMap:
         return .luminosityCurveMap;
        
       case .curves:
         return .curves;
        
      case .averagedColor:
        return .averagedColor;
        
      // case .lanczosResampling:
      //   return .lanczosResampling;
        
      // case .pageCurl:
      //   return .pageCurl;
        
      case .darkVibrant:
        return .darkVibrant;
        
      case .lightVibrant:
        return .lightVibrant;
        
      case .colorMatrixVibrant:
        return .colorMatrixVibrant;
        
      case .variadicBlur:
        return .variadicBlur;
    };
  };
  
  public var decodedFilterName: String? {
    self.associatedFilterTypeName.decodedString;
  };
  
  // MARK: - Init
  // ------------
  
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
      case .alphaFromLuminance:
        self = .alphaFromLuminance;
        
      case .averagedColor:
        self = .averagedColor;
        
      case .colorBlackAndWhite:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .colorBlackAndWhite(inputAmount: inputAmount);
        
      case .saturateColors:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .saturateColors(inputAmount: inputAmount);
        
      case .brightenColors:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .brightenColors(inputAmount: inputAmount);
        
      case .contrastColors:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .contrastColors(inputAmount: inputAmount);
        
      case .luminanceCompression:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .luminanceCompression(inputAmount: inputAmount);
        
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
        
      case .luminosityCurveMap:
        guard let inputAmount = requestedValues.inputAmount,
              let inputValues = configurationValues.inputValues  else {
          return nil;
        };
        
        self = .luminosityCurveMap(
          inputAmount: inputAmount,
          inputValues: inputValues
        );
        
      case .gaussianBlur:
        guard let inputRadius = requestedValues.inputRadius else {
          return nil;
        };
        
        self = .gaussianBlur(inputRadius: inputRadius);
        
      case .darkVibrant:
        guard let inputReversed = requestedValues.inputReversed,
              let inputColor0 = requestedValues.inputColor0,
              let inputColor1 = requestedValues.inputColor1
        else {
          return nil;
        };
        
        self = .darkVibrant(
          inputReversed: inputReversed,
          inputColor0: inputColor0,
          inputColor1: inputColor1
        );
        
      case .lightVibrant:
        guard let inputReversed = requestedValues.inputReversed,
              let inputColor0 = requestedValues.inputColor0,
              let inputColor1 = requestedValues.inputColor1
        else {
          return nil;
        };
        
        self = .lightVibrant(
          inputReversed: inputReversed,
          inputColor0: inputColor0,
          inputColor1: inputColor1
        );
        
      case .colorMatrixVibrant:
        guard let inputColorMatrix = requestedValues.inputColorMatrix else {
          return nil;
        };
        
        self = .colorMatrixVibrant(inputColorMatrix);
        
      case .colorMatrix:
        guard let inputColorMatrix = requestedValues.inputColorMatrix else {
          return nil;
        };
        
        self = .colorMatrix(inputColorMatrix);
        
      default:
        return nil;
    };
  };
  
  // MARK: - Functions
  // -----------------
  
  public func applyTo(layerFilterWrapper: LayerFilterWrapper){
    switch self {
      case .alphaFromLuminance: fallthrough;
      case .averagedColor:
        // no-op
        break;
        
      case let .curves(inputAmount, inputValues):
        layerFilterWrapper.setInputAmount(inputAmount);
        layerFilterWrapper.setInputValues(inputValues);
        
      case let .luminosityCurveMap(inputAmount, inputValues):
        layerFilterWrapper.setInputAmount(inputAmount);
        layerFilterWrapper.setInputValues(inputValues);
        
      case let .colorBlackAndWhite(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .saturateColors(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .brightenColors(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .contrastColors(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .luminanceCompression(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .bias(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .gaussianBlur(inputRadius, inputNormalizeEdges):
        layerFilterWrapper.setInputRadius(inputRadius);
        layerFilterWrapper.setInputNormalizeEdges(inputNormalizeEdges);
        
      case let .darkVibrant(
        inputReversed,
        inputColor0,
        inputColor1
      ):
        layerFilterWrapper.setInputReversed(inputReversed);
        layerFilterWrapper.setInputColor0(inputColor0);
        layerFilterWrapper.setInputColor1(inputColor1);
        
      case let .lightVibrant(
        inputReversed,
        inputColor0,
        inputColor1
      ):
        layerFilterWrapper.setInputReversed(inputReversed);
        layerFilterWrapper.setInputColor0(inputColor0);
        layerFilterWrapper.setInputColor1(inputColor1);
        
      case let .colorMatrixVibrant(colorMatrix):
        layerFilterWrapper.setInputColorMatrix(colorMatrix);
        break;
        
      case let .colorMatrix(colorMatrix):
        layerFilterWrapper.setInputColorMatrix(colorMatrix);
        
      case let .variadicBlur(
        inputRadius,
        inputMaskImage,
        inputNormalizeEdges
      ):
        layerFilterWrapper.setInputRadius(inputRadius);
        layerFilterWrapper.setInputMaskImage(inputMaskImage);
        layerFilterWrapper.setInputNormalizeEdges(inputNormalizeEdges);
    };
  };
  
  public func createFilterWrapper() -> LayerFilterWrapper? {
    guard let filterTypeName = self.decodedFilterName else {
      return nil;
    };
  
    guard let layerFilterWrapper = LayerFilterWrapper(rawFilterType: filterTypeName) else {
      return nil;
    };
    
    try? layerFilterWrapper.setDefaults();
    self.applyTo(layerFilterWrapper: layerFilterWrapper);
    
    return layerFilterWrapper;
  };
};

extension LayerFilterType {
  static func darkVibrant(
    inputReversed: Bool,
    inputColor0: UIColor,
    inputColor1: UIColor
  ) -> Self {
    .darkVibrant(
      inputReversed: inputReversed,
      inputColor0: inputColor0.cgColor,
      inputColor1: inputColor1.cgColor
    );
  };
  
  static func lightVibrant(
    inputReversed: Bool,
    inputColor0: UIColor,
    inputColor1: UIColor
  ) -> Self {
    .lightVibrant(
      inputReversed: inputReversed,
      inputColor0: inputColor0.cgColor,
      inputColor1: inputColor1.cgColor
    );
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
