//
//  LayerFilterType.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import UIKit


public enum LayerFilterType {

  // case colorMultiply;
  // case addColor;
  // case subtractColor;
  // case invertColors;
  // case shiftHueColor;
  // case meteor;
  // case distanceField;
  // case luminosityMap;
  // case lanczosResampling;
  // case paperCurl;
  
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

  case blackAndWhiteColor(inputAmount: CGFloat);
  case saturateColor(inputAmount: CGFloat);
  case brightness(inputAmount: CGFloat);
  case contrast(inputAmount: CGFloat);
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
  
  case vibrantMatrixRGBA(matrixRGBA: matrixRGBARGBA);
  case matrixRGBA(matrixRGBA: matrixRGBARGBA);
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var associatedFilterTypeName: LayerFilterTypeName {
    switch self {
      // case .colorMultiply:
      //   return .colorMultiply;
      //
      // case .addColor:
      //   return .addColor;
      //
      // case .subtractColor:
      //   return .subtractColor;
        
      case .blackAndWhiteColor:
        return .blackAndWhiteColor;
        
      case .matrixRGBA:
        return .matrixRGBA;
        
      // case .shiftHueColor:
      //   return .shiftHueColor;
        
      case .saturateColor:
        return .saturateColor;
        
      case .brightness:
        return .brightness;
        
      case .contrast:
        return .contrast;
        
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
        
      // case .luminosityMap:
      //   return .luminosityMap;
        
       case .luminosityCurveMap:
         return .luminosityCurveMap;
        
       case .curves:
         return .curves;
        
      case .averagedColor:
        return .averagedColor;
        
      // case .lanczosResampling:
      //   return .lanczosResampling;
        
      // case .paperCurl:
      //   return .paperCurl;
        
      case .darkVibrant:
        return .darkVibrant;
        
      case .lightVibrant:
        return .lightVibrant;
        
      case .vibrantMatrixRGBA:
        return .vibrantMatrixRGBA;
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
        
      case .blackAndWhiteColor:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .blackAndWhiteColor(inputAmount: inputAmount);
        
      case .saturateColor:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .saturateColor(inputAmount: inputAmount);
        
      case .brightness:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .brightness(inputAmount: inputAmount);
        
      case .contrast:
        guard let inputAmount = requestedValues.inputAmount else {
          return nil;
        };
        
        self = .contrast(inputAmount: inputAmount);
        
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
        
      case .vibrantMatrixRGBA:
        guard let inputmatrixRGBA = requestedValues.inputmatrixRGBA else {
          return nil;
        };
        
        self = .vibrantMatrixRGBA(matrixRGBA: inputmatrixRGBA);
        
      case .matrixRGBA:
        guard let inputmatrixRGBA = requestedValues.inputmatrixRGBA else {
          return nil;
        };
        
        self = .matrixRGBA(matrixRGBA: inputmatrixRGBA);
        
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
        
      case let .blackAndWhiteColor(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .saturateColor(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .brightness(inputAmount):
        layerFilterWrapper.setInputAmount(inputAmount);
        
      case let .contrast(inputAmount):
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
        
      case let .vibrantMatrixRGBA(matrixRGBA):
        layerFilterWrapper.setInputmatrixRGBA(matrixRGBA);
        break;
        
      case let .matrixRGBA(matrixRGBA):
        layerFilterWrapper.setInputmatrixRGBA(matrixRGBA);
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
  
  var inputmatrixRGBA: matrixRGBARGBA? {
    guard let inputmatrixRGBARaw = self["inputmatrixRGBA"],
          let inputmatrixRGBA = inputmatrixRGBARaw as? NSValue
    else {
      return nil;
    };
    
    return .init(fromValue: inputmatrixRGBA);
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
