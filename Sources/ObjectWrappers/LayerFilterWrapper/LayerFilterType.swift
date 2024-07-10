//
//  LayerFilterType.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import UIKit
import DGSwiftUtilities

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
  
  // case curves(
  //   inputAmount: CGFloat,
  //   inputValues: [CGFloat]
  // );
  
  case luminosityCurveMap(
    amount: CGFloat,
    values: [CGFloat]
  );

  case colorBlackAndWhite(amount: CGFloat);
  case saturateColors(amount: CGFloat);
  case brightenColors(amount: CGFloat);
  case contrastColors(amount: CGFloat);
  case luminanceCompression(amount: CGFloat)
  case bias(amount: CGFloat);
  
  case gaussianBlur(
    radius: CGFloat,
    shouldNormalizeEdges: Bool = true
  );
  
  case darkVibrant(
    isReversed: Bool,
    color0: CGColor,
    color1: CGColor
  );
  
  case lightVibrant(
    isReversed: Bool,
    color0: CGColor,
    color1: CGColor
  );
  
  case colorMatrixVibrant(_ colorMatrix: ColorMatrixRGBA);
  case colorMatrix(_ colorMatrix: ColorMatrixRGBA);
  
  case variadicBlur(
    radius: CGFloat,
    maskImage: CGImage,
    shouldNormalizeEdges: Bool
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
        
      // case .curves:
      //   return .curves;
        
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
  
  public var filterValuesIdentity: Dictionary<String, Any> {
    var identityValues: Dictionary<String, Any> = [:];
    
    switch self {
      case .alphaFromLuminance:
        break;
        
      case .averagedColor:
        break;
        
      case .luminosityCurveMap:
        identityValues.filterInputValueAmount = 0;
        
      case .colorBlackAndWhite:
        identityValues.filterInputValueAmount = 0;
        
      case .saturateColors:
        identityValues.filterInputValueAmount = 1;
        
      case .brightenColors:
        identityValues.filterInputValueAmount = 0;
        
      case .contrastColors:
        identityValues.filterInputValueAmount = 1;
        
      case .luminanceCompression:
        identityValues.filterInputValueAmount = 1;
        
      case .bias:
        identityValues.filterInputValueAmount = 0.5;
        
      case .gaussianBlur:
        identityValues.filterInputValueRadius = 0;
        identityValues.filterInputValueShouldNormalizeEdgesObjc = 1;
        
      case .darkVibrant:
        identityValues.filterInputValueIsReversed = true;
        identityValues.filterInputValueColor0 = UIColor.white.cgColor;
        identityValues.filterInputValueColor1 = UIColor.white.cgColor;
        
      case .lightVibrant:
        identityValues.filterInputValueIsReversed = true;
        identityValues.filterInputValueColor0 = UIColor.white.cgColor;
        identityValues.filterInputValueColor1 = UIColor.white.cgColor;
        
      case .colorMatrixVibrant:
        identityValues.filterInputValueColorMatrixObjc = ColorMatrixRGBA.identity.objcValue;
        
      case .colorMatrix:
        identityValues.filterInputValueColorMatrixObjc = ColorMatrixRGBA.identity.objcValue;
        
      case .variadicBlur:
        identityValues.filterInputValueRadius = 0;
        identityValues.filterInputValueShouldNormalizeEdgesObjc = 1;
        identityValues.filterInputMaskImage = nil;
    };
    
    return identityValues;
  };
  
  public var filterValuesRequested: Dictionary<String, Any> {
    var valuesRequested: Dictionary<String, Any> = [:];
    
    switch self {
      case .alphaFromLuminance:
        break;
        
      case .averagedColor:
        break;
        
      case let .luminosityCurveMap(amount, _):
        valuesRequested.filterInputValueAmount = amount;
        
      case let .colorBlackAndWhite(amount):
        valuesRequested.filterInputValueAmount = amount;
        
      case let .saturateColors(amount):
        valuesRequested.filterInputValueAmount = amount;
        
      case let .brightenColors(amount):
        valuesRequested.filterInputValueAmount = amount;
        
      case let .contrastColors(amount):
        valuesRequested.filterInputValueAmount = amount;
        
      case let .luminanceCompression(amount):
        valuesRequested.filterInputValueAmount = amount;
        
      case let .bias(amount):
        valuesRequested.filterInputValueAmount = amount;
        
      case let .gaussianBlur(radius, shouldNormalizeEdges):
        valuesRequested.filterInputValueRadius = radius;
        valuesRequested.filterInputValueShouldNormalizeEdgesObjc = shouldNormalizeEdges ? 1 : 0;
        
      case let .darkVibrant(isReversed, color0, color1):
        valuesRequested.filterInputValueIsReversed = isReversed;
        valuesRequested.filterInputValueColor0 = color0;
        valuesRequested.filterInputValueColor1 = color1;
        
      case let .lightVibrant(isReversed, color0, color1):
        valuesRequested.filterInputValueIsReversed = isReversed;
        valuesRequested.filterInputValueColor0 = color0;
        valuesRequested.filterInputValueColor1 = color1;
        
      case let .colorMatrixVibrant(matrix):
        valuesRequested.filterInputValueColorMatrixObjc = matrix.objcValue;
        
      case let .colorMatrix(matrix):
        valuesRequested.filterInputValueColorMatrixObjc = matrix.objcValue;
        
      case let .variadicBlur(radius, maskImage, shouldNormalizeEdges):
        valuesRequested.filterInputValueRadius = radius;
        valuesRequested.filterInputMaskImage = maskImage;
        valuesRequested.filterInputValueShouldNormalizeEdgesObjc = shouldNormalizeEdges ? 1 : 0;
    };
    
    return valuesRequested;
  };
  
  public var filterValuesConfig: Dictionary<String, Any> {
    var valuesConfig: Dictionary<String, Any> = [:];
    
    switch self {
      case let .luminosityCurveMap(_, values):
        valuesConfig.filterInputValues = values;
        
      default:
        break;
    };
    
    return valuesConfig;
  };
  
  // MARK: - Init
  // ------------
  
  public init?(fromWrapper wrapper: UVEFilterEntryWrapper){
    let filterTypeName: LayerFilterTypeName? = {
      guard let filterType = wrapper.filterKind else {
        return nil;
      };
      
      return .init(rawValue: filterType);
    }();
    
    guard let filterTypeName = filterTypeName,
          let filterValuesRequestedRaw = wrapper.filterValuesRequested,
          
          let filterValuesRequested =
            filterValuesRequestedRaw  as? Dictionary<String, Any>,
            
          let filterValuesConfigRaw = wrapper.filterValuesConfig,
          
          let filterValuesConfig =
            filterValuesConfigRaw as? Dictionary<String, Any>
    else {
      return nil;
    };
    
    switch filterTypeName {
      case .alphaFromLuminance:
        self = .alphaFromLuminance;
        
      case .averagedColor:
        self = .averagedColor;
        
      case .colorBlackAndWhite:
        guard let inputAmount = filterValuesRequested.filterInputValueAmount else {
          return nil;
        };
        
        self = .colorBlackAndWhite(amount: inputAmount);
        
      case .saturateColors:
        guard let inputAmount = filterValuesRequested.filterInputValueAmount else {
          return nil;
        };
        
        self = .saturateColors(amount: inputAmount);
        
      case .brightenColors:
        guard let inputAmount = filterValuesRequested.filterInputValueAmount else {
          return nil;
        };
        
        self = .brightenColors(amount: inputAmount);
        
      case .contrastColors:
        guard let inputAmount = filterValuesRequested.filterInputValueAmount else {
          return nil;
        };
        
        self = .contrastColors(amount: inputAmount);
        
      case .luminanceCompression:
        guard let inputAmount = filterValuesRequested.filterInputValueAmount else {
          return nil;
        };
        
        self = .luminanceCompression(amount: inputAmount);
        
      case .bias:
        guard let inputAmount = filterValuesRequested.filterInputValueAmount else {
          return nil;
        };
        
        self = .bias(amount: inputAmount);
        
      case .luminosityCurveMap:
        guard let inputAmount = filterValuesRequested.filterInputValueAmount,
              let inputValues = filterValuesConfig.filterInputValues  else {
          return nil;
        };
        
        self = .luminosityCurveMap(
          amount: inputAmount,
          values: inputValues
        );
        
      case .gaussianBlur:
        guard let inputRadius = filterValuesRequested.filterInputValueRadius,
              let shouldNormalizeEdges = filterValuesConfig.filterInputValueShouldNormalizeEdges
        else {
          return nil;
        };
        
        self = .gaussianBlur(
          radius: inputRadius,
          shouldNormalizeEdges: shouldNormalizeEdges
        );
        
      case .darkVibrant:
        guard let inputReversed = filterValuesRequested.filterInputValueIsReversed,
              let inputColor0 = filterValuesRequested.filterInputValueColor0,
              let inputColor1 = filterValuesRequested.filterInputValueColor1
        else {
          return nil;
        };
        
        self = .darkVibrant(
          isReversed: inputReversed,
          color0: inputColor0,
          color1: inputColor1
        );
        
      case .lightVibrant:
        guard let inputReversed = filterValuesRequested.filterInputValueIsReversed,
              let inputColor0 = filterValuesRequested.filterInputValueColor0,
              let inputColor1 = filterValuesRequested.filterInputValueColor1
        else {
          return nil;
        };
        
        self = .lightVibrant(
          isReversed: inputReversed,
          color0: inputColor0,
          color1: inputColor1
        );
        
      case .colorMatrixVibrant:
        guard let inputColorMatrix = filterValuesRequested.filterInputValueColorMatrix else {
          return nil;
        };
        
        self = .colorMatrixVibrant(inputColorMatrix);
        
      case .colorMatrix:
        guard let inputColorMatrix = filterValuesRequested.filterInputValueColorMatrix else {
          return nil;
        };
        
        self = .colorMatrix(inputColorMatrix);
        
      case .variadicBlur:
        guard let inputRadius = filterValuesRequested.filterInputValueRadius,
              let maskImage = filterValuesRequested.filterInputMaskImage,
              let inputNormalizeEdges = filterValuesRequested.filterInputValueShouldNormalizeEdges
        else {
          return nil;
        };
        
        self = .variadicBlur(
          radius: inputRadius,
          maskImage: maskImage,
          shouldNormalizeEdges: inputNormalizeEdges
        );
        
      default:
        return nil;
    };
  };
  
  // MARK: - Functions
  // -----------------
  
  public func createFilterWrapper() -> LayerFilterWrapper? {
    guard let filterTypeName = self.decodedFilterName else {
      return nil;
    };
  
    guard let layerFilterWrapper = LayerFilterWrapper(rawFilterType: filterTypeName) else {
      return nil;
    };
    
    try? layerFilterWrapper.setDefaults();
    try? self.applyTo(layerFilterWrapper: layerFilterWrapper);
    
    return layerFilterWrapper;
  };
  
  public func applyTo(layerFilterWrapper: LayerFilterWrapper) throws {
    switch self {
      case .alphaFromLuminance: fallthrough;
      case .averagedColor:
        // no-op
        break;
        
      // case let .curves(inputAmount, inputValues):
      //   try layerFilterWrapper.setFilterValue(amount: inputAmount);
      //   try layerFilterWrapper.setFilterValue(values: inputValues);
        
      case let .luminosityCurveMap(inputAmount, inputValues):
        try layerFilterWrapper.setFilterValue(amount: inputAmount);
        try layerFilterWrapper.setFilterValue(values: inputValues);
        
      case let .colorBlackAndWhite(inputAmount):
        try layerFilterWrapper.setFilterValue(amount: inputAmount);
        
      case let .saturateColors(inputAmount):
        try layerFilterWrapper.setFilterValue(amount: inputAmount);
        
      case let .brightenColors(inputAmount):
        try layerFilterWrapper.setFilterValue(amount: inputAmount);
        
      case let .contrastColors(inputAmount):
        try layerFilterWrapper.setFilterValue(amount: inputAmount);
        
      case let .luminanceCompression(inputAmount):
        try layerFilterWrapper.setFilterValue(amount: inputAmount);
        
      case let .bias(inputAmount):
        try layerFilterWrapper.setFilterValue(amount: inputAmount);
        
      case let .gaussianBlur(inputRadius, inputNormalizeEdges):
        try layerFilterWrapper.setFilterValue(radius: inputRadius);
        try layerFilterWrapper.setFilterValue(shouldNormalizeEdges: inputNormalizeEdges);
        
      case let .darkVibrant(
        inputReversed,
        inputColor0,
        inputColor1
      ):
        try layerFilterWrapper.setFilterValue(isReversed: inputReversed);
        try layerFilterWrapper.setFilterValue(color0: inputColor0);
        try layerFilterWrapper.setFilterValue(color1: inputColor1);
        
      case let .lightVibrant(
        inputReversed,
        inputColor0,
        inputColor1
      ):
        try layerFilterWrapper.setFilterValue(isReversed: inputReversed);
        try layerFilterWrapper.setFilterValue(color0: inputColor0);
        try layerFilterWrapper.setFilterValue(color1: inputColor1);
        
      case let .colorMatrixVibrant(colorMatrix):
        try layerFilterWrapper.setFilterValue(colorMatrix: colorMatrix);
        
      case let .colorMatrix(colorMatrix):
        try layerFilterWrapper.setFilterValue(colorMatrix: colorMatrix);
        
      case let .variadicBlur(
        inputRadius,
        inputMaskImage,
        inputNormalizeEdges
      ):
        try layerFilterWrapper.setFilterValue(radius: inputRadius);
        try layerFilterWrapper.setFilterValue(maskImage: inputMaskImage);
        try layerFilterWrapper.setFilterValue(shouldNormalizeEdges: inputNormalizeEdges);
    };
  };
  
  public func applyTo(
    filterEntryWrapper: UVEFilterEntryWrapper,
    shouldSetValuesIdentity: Bool = true,
    shouldSetValuesRequested: Bool = true,
    shouldSetValuesConfig: Bool = true
  ) throws {
  
    let filterTypePrev = filterEntryWrapper.filterKind;
    guard let filterTypeNext = self.decodedFilterName else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to decode `filterTypeNext`"
      );
    };
    
    let didFilterTypeChange =
      filterTypePrev != filterTypeNext;
      
    if didFilterTypeChange {
      try filterEntryWrapper.setFilterKind(filterTypeNext);
    };
    
    let identityValuesPrev =
      filterEntryWrapper.filterValuesIdentity as? Dictionary<String, Any> ?? [:];
      
    let identityValuesNext = self.filterValuesIdentity;
    
    let didIdentityValuesChange =
      identityValuesPrev != identityValuesNext;
    
    if shouldSetValuesIdentity,
       didFilterTypeChange || didIdentityValuesChange
    {
      try filterEntryWrapper.setFilterValuesIdentity(
        identityValuesNext as NSDictionary
      );
    };
    
    let requestedValuesPrev =
      filterEntryWrapper.filterValuesRequested as? Dictionary<String, Any> ?? [:];
      
    let requestedValuesNext = self.filterValuesRequested;
    
    let didRequestedValuesChange =
      requestedValuesPrev != requestedValuesNext;
      
    if shouldSetValuesRequested,
       didFilterTypeChange || didRequestedValuesChange
    {
      try filterEntryWrapper.setFilterValuesRequested(
        requestedValuesNext as NSDictionary
      );
    };
    
    let configValuesPrev =
      filterEntryWrapper.filterValuesConfig as? Dictionary<String, Any> ?? [:];
      
    let configValuesNext = self.filterValuesConfig;
    
    let didConfigValuesChange = configValuesPrev != configValuesNext;
    
    if shouldSetValuesConfig,
       didFilterTypeChange || didConfigValuesChange
    {
      try filterEntryWrapper.setFilterValuesConfig(
        configValuesNext as NSDictionary
      );
    };
  };
  
};

// MARK: - LayerFilterType+StaticAlias
// -----------------------------------

extension LayerFilterType {
  static func darkVibrant(
    inputReversed: Bool,
    inputColor0: UIColor,
    inputColor1: UIColor
  ) -> Self {
    .darkVibrant(
      isReversed: inputReversed,
      color0: inputColor0.cgColor,
      color1: inputColor1.cgColor
    );
  };
  
  static func lightVibrant(
    inputReversed: Bool,
    inputColor0: UIColor,
    inputColor1: UIColor
  ) -> Self {
    .lightVibrant(
      isReversed: inputReversed,
      color0: inputColor0.cgColor,
      color1: inputColor1.cgColor
    );
  };
};

// MARK: - Dictionary+Helpers
// --------------------------

fileprivate extension Dictionary where Key == String, Value == Any {

  var filterInputValueAmount: CGFloat? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyAmount;
      guard let keyValue = key.decodedString,
            let inputAmountRaw = self[keyValue],
            let inputAmount = inputAmountRaw as? CGFloat
      else {
        return nil;
      };
      
      return inputAmount;
    }
    mutating set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyAmount;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValueRadius: CGFloat? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyRadius;
      guard let keyValue = key.decodedString,
            let inputRadiusRaw = self[keyValue],
            let inputRadius = inputRadiusRaw as? CGFloat
      else {
        return nil;
      };
      
      return inputRadius;
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyRadius;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValueIsReversed: Bool? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyReversed;
      guard let keyValue = key.decodedString,
            let inputReversedRaw = self[keyValue],
            let inputReversed = inputReversedRaw as? NSNumber
      else {
        return nil;
      };
      
      return inputReversed.boolValue;
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyReversed;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValueColor0: CGColor? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyColor0;
      guard let keyValue = key.decodedString,
            let inputColor0Raw = self[keyValue]
      else {
        return nil;
      };
      
      return (inputColor0Raw as! CGColor);
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyColor0;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValueColor1: CGColor? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyColor1;
      guard let keyValue = key.decodedString,
            let inputColor1Raw = self[keyValue]
      else {
        return nil;
      };
      
      return (inputColor1Raw as! CGColor);
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyColor1;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValueColorMatrix: ColorMatrixRGBA? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyColorMatrix;
      guard let keyValue = key.decodedString,
            let inputColorMatrixRaw = self[keyValue],
            let inputColorMatrix = inputColorMatrixRaw as? NSValue
      else {
        return nil;
      };
      
      return .init(fromValue: inputColorMatrix);
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyColorMatrix;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValueColorMatrixObjc: NSValue? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyColorMatrix;
      guard let keyValue = key.decodedString,
            let inputColorMatrixRaw = self[keyValue],
            let inputColorMatrix = inputColorMatrixRaw as? NSValue
      else {
        return nil;
      };
      
      return inputColorMatrix;
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyColorMatrix;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValues: [CGFloat]? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyValues;
      guard let keyValue = key.decodedString,
            let inputValuesRaw = self[keyValue],
            let inputValues = inputValuesRaw as? NSArray
      else {
        return nil;
      };
      
      return inputValues.compactMap {
        $0 as? CGFloat;
      };
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyValues;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValueShouldNormalizeEdges: Bool? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyNormalizeEdges;
      guard let keyValue = key.decodedString,
            let inputValuesRaw = self[keyValue],
            let inputValue = inputValuesRaw as? NSNumber
      else {
        return nil;
      };
      
      return inputValue.boolValue;
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyNormalizeEdges;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputValueShouldNormalizeEdgesObjc: Int? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyNormalizeEdges;
      guard let keyValue = key.decodedString,
            let inputValuesRaw = self[keyValue],
            let inputValue = inputValuesRaw as? Int
      else {
        return nil;
      };
      
      return inputValue;
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyNormalizeEdges;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
  
  var filterInputMaskImage: CGImage? {
    get {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyMaskImage;
      guard let keyValue = key.decodedString,
            let inputValue = self[keyValue] as? AnyObject,
            CFGetTypeID(inputValue) == CGImage.typeID
      else {
        return nil;
      };
      
      return (inputValue as! CGImage);
    }
    set {
      let key = LayerFilterWrapper.EncodedString.propertyFilterInputKeyMaskImage;
      guard let keyValue = key.decodedString else {
        return;
      };
      
      self[keyValue] = newValue;
    }
  };
};
