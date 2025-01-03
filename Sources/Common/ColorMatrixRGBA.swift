//
//  ColorMatrixRGBA.swift
//  
//
//  Created by Dominic Go on 6/23/24.
//

import UIKit
import DGSwiftUtilities

/// Maps to `CAColorMatrix`
public struct ColorMatrixRGBA: Equatable, MutableReference {

  public typealias MatrixPropertyKeyPath = WritableKeyPath<Self, Float>;

  // MARK: - Static Properties
  // -------------------------
  
  public static let luminance: (Float, Float, Float) = (
    r: 0.213,
    g: 0.715,
    b: 0.072
  );
  
  public static let keyPathsMatrix: [[MatrixPropertyKeyPath]] = [
    [\.m11, \.m12, \.m13, \.m14, \.m15],
    [\.m21, \.m22, \.m23, \.m24, \.m25],
    [\.m31, \.m32, \.m33, \.m34, \.m35],
    [\.m41, \.m42, \.m43, \.m44, \.m45],
  ];
  
  public static var keyPathsForRGBTranslate: [MatrixPropertyKeyPath] = [
    \.m15,
    \.m25,
    \.m35,
  ];
  
  public static var keyPathsForRGBATranslate: [MatrixPropertyKeyPath] = [
    \.m15,
    \.m25,
    \.m35,
    \.m45,
  ];
  
  public static var keyPathsForChannelRGB: [MatrixPropertyKeyPath] = [
    \.m11,
    \.m22,
    \.m33,
  ];
  
  public static var keyPathsForChannelRGBA: [MatrixPropertyKeyPath] = [
    \.m11,
    \.m22,
    \.m33,
    \.m44,
  ];
  
  public static var keyPathsForTranslationRGB: [MatrixPropertyKeyPath] = [
    \.m14,
    \.m24,
    \.m34,
  ];
  
  public static var keyPathsMatrixAll: [MatrixPropertyKeyPath] {
    Self.keyPathsMatrix.reduce([]) {
      $0 + $1;
    };
  };
  
  /// The associated `NSValue.objcType` for this type
  public static var associatedObjcTypeCached: UnsafePointer<CChar>?;
  
  // MARK: - Static Computed Properties
  // ----------------------------------
  
  public static var keyPathsAll: [WritableKeyPath<Self, Float>] {
    Self.keyPathsMatrix.reduce(into: []){
      $0 += $1;
    };
  };
  
  private static var associatedObjcType: UnsafePointer<CChar>? {
    set {
      self.associatedObjcTypeCached = newValue;
    }
    get {
      if let _objcTypeRaw = Self.associatedObjcTypeCached {
        return _objcTypeRaw;
      };
      
      guard #available(iOS 13.0, *) else {
        return nil;
      };
      
      let objcType = Self.extractObjTypeForColorMatrixFromVisualEffects();
      guard let objcType = objcType else {
        return nil;
      };
      
      self.associatedObjcTypeCached = objcType;
      return objcType;
    }
  };
  
  // MARK: - Static Helpers
  // ----------------------
  
  public static func getKeyPath(
    forRow row: Int,
    column: Int
  ) -> WritableKeyPath<Self, Float>? {
    guard let rowValues = Self.keyPathsMatrix[safeIndex: row],
          let element = rowValues[safeIndex: column]
    else {
      return nil;
    };
    
    return element;
  };
  
  // MARK: - Properties
  // ------------------

  public var m11, m12, m13, m14, m15: Float;
  public var m21, m22, m23, m24, m25: Float;
  public var m31, m32, m33, m34, m35: Float;
  public var m41, m42, m43, m44, m45: Float;
  
  // MARK: - Computed Properties (Matrix)
  // ------------------------------------
  
  public var matrix3x3: [[Float]] {
    self.getMatrix(forRowSize: 3, columnSize: 3);
  };
  
  public var matrix4x4: [[Float]] {
    self.getMatrix(forRowSize: 4, columnSize: 4);
  };
  
  public var matrix4x5: [[Float]] {
    self.getMatrix(forRowSize: 4, columnSize: 5);
  };
  
  public var objcValue: NSValue? {
    guard let objcTypeRaw = Self.associatedObjcType else {
      return nil;
    };
    
    let floatMembersInStructCount = 20;
    var bufferArray = [UInt32](repeating: 0, count: floatMembersInStructCount);
    
    for (index, keyPath) in Self.keyPathsAll.enumerated() {
      let floatValue = self[keyPath: keyPath];
      bufferArray[index] = floatValue.bitPattern;
    };
    
    let objcValue = NSValue(bufferArray, withObjCType: objcTypeRaw);
    return objcValue;
  };
    
  // MARK: - Init
  // ------------
  
  public init() {
    self = .identity;
  }
  
  public init(
    m11: Float, m12: Float, m13: Float, m14: Float, m15: Float,
    m21: Float, m22: Float, m23: Float, m24: Float, m25: Float,
    m31: Float, m32: Float, m33: Float, m34: Float, m35: Float,
    m41: Float, m42: Float, m43: Float, m44: Float, m45: Float
  ) {
    self.m11 = m11;
    self.m12 = m12;
    self.m13 = m13;
    self.m14 = m14;
    self.m15 = m15;
    self.m21 = m21;
    self.m22 = m22;
    self.m23 = m23;
    self.m24 = m24;
    self.m25 = m25;
    self.m31 = m31;
    self.m32 = m32;
    self.m33 = m33;
    self.m34 = m34;
    self.m35 = m35;
    self.m41 = m41;
    self.m42 = m42;
    self.m43 = m43;
    self.m44 = m44;
    self.m45 = m45;
  };
  
  public init<T: BinaryFloatingPoint>(
    withSourceType sourceType: T.Type = T.self,
    
    m11: T, m12: T, m13: T, m14: T, m15: T,
    m21: T, m22: T, m23: T, m24: T, m25: T,
    m31: T, m32: T, m33: T, m34: T, m35: T,
    m41: T, m42: T, m43: T, m44: T, m45: T
  ) {
    self.m11 = .init(m11);
    self.m12 = .init(m12);
    self.m13 = .init(m13);
    self.m14 = .init(m14);
    self.m15 = .init(m15);
    self.m21 = .init(m21);
    self.m22 = .init(m22);
    self.m23 = .init(m23);
    self.m24 = .init(m24);
    self.m25 = .init(m25);
    self.m31 = .init(m31);
    self.m32 = .init(m32);
    self.m33 = .init(m33);
    self.m34 = .init(m34);
    self.m35 = .init(m35);
    self.m41 = .init(m41);
    self.m42 = .init(m42);
    self.m43 = .init(m43);
    self.m44 = .init(m44);
    self.m45 = .init(m45);
  };
  
  public init?(fromValue value: NSValue){
    let objcTypeCharPointer = value.objCType as UnsafePointer<CChar>;
    guard let objcTypeString = NSString(utf8String: objcTypeCharPointer) else {
      return nil;
    };
    
    guard objcTypeString.lowercased.contains("matrix") else {
      return nil;
    };
    
    if Self.associatedObjcTypeCached == nil {
      Self.associatedObjcTypeCached = objcTypeCharPointer;
    };
    
    let floatMembersInStructCount = 20;
    let floatSizeBytes = MemoryLayout<UInt32>.size;
    let structTotalSizeBytes = floatSizeBytes * floatMembersInStructCount;

    var bufferArray = [UInt32](repeating: 0, count: floatMembersInStructCount);
    value.getValue(&bufferArray, size: structTotalSizeBytes);
    
    let floats = bufferArray.map {
      Float(bitPattern: $0);
    };
    
    let kayPathsAll = Self.keyPathsAll;
    var newMatrix: Self = .zero;
    
    floats.enumerated().forEach {
      let kayPath = kayPathsAll[$0.offset];
      newMatrix[keyPath: kayPath] = $0.element;
    };
    
    self = newMatrix;
  };
  
  public init(fromColorMatrix3x3 matrix: [[Float]]){
    self.init(
      m11: matrix[0][0], m12: matrix[0][1], m13: matrix[0][2], m14: 0, m15: 0,
      m21: matrix[1][0], m22: matrix[1][1], m23: matrix[1][2], m24: 0, m25: 0,
      m31: matrix[2][0], m32: matrix[2][1], m33: matrix[2][2], m34: 0, m35: 0,
      m41: 0, m42: 0, m43: 0, m44: 1, m45: 0
    );
  };
  
  public init(fromColorMatrix5x4 matrix: [[Float]]){
    self.init(
      m11: matrix[0][0], m12: matrix[0][1], m13: matrix[0][2], m14: matrix[0][3], m15: matrix[0][4],
      m21: matrix[1][0], m22: matrix[1][1], m23: matrix[1][2], m24: matrix[1][3], m25: matrix[1][4],
      m31: matrix[2][0], m32: matrix[2][1], m33: matrix[2][2], m34: matrix[2][3], m35: matrix[2][4],
      m41: matrix[3][0], m42: matrix[3][1], m43: matrix[3][2], m44: matrix[3][3], m45: matrix[3][4]
    );
  };
  
  public init(fromPreset colorMatrixPreset: ColorMatrixRGBAPreset) {
    self = colorMatrixPreset.colorMatrix;
  }
  
  // MARK: - Functions (Matrix)
  // --------------------------
  
  public func getValue(forRow row: Int, column: Int) -> Float? {
    guard let keyPath = Self.getKeyPath(forRow: row, column: column) else {
      return nil;
    };
    
    return self[keyPath: keyPath];
  };
  
  public func getMatrix(
    forRowSize rowSize: Int = 4,
    columnSize: Int = 5
  ) -> [[Float]] {
    var matrix: [[Float]]  = [];
    
    for i in 0..<rowSize {
      var rowValues: [Float] = [];
      
      for j in 0..<columnSize {
        let value = self.getValue(forRow: i, column: j);
        rowValues.append(value ?? 0);
      };
      
      matrix.append(rowValues);
    };
    
    return matrix;
  };
  
  // MARK: - Functions (Transforms)
  // -----------------------------
  
  public mutating func setChannels(r: Float, g: Float, b: Float) {
    let channels = [r, g, b];
    
    Self.keyPathsForChannelRGB.enumerated().forEach {
      let channel = channels[$0.offset];
      let channelClamped = channel.clamped(min: 0, max: 2);
      
      self[keyPath: $0.element] = channelClamped;
    };
  };
  
  public mutating func setColorShift(r: Float, g: Float, b: Float) {
    let channels = [r, g, b];
    
    Self.keyPathsForRGBTranslate.enumerated().forEach {
      let channel = channels[$0.offset];
      let channelClamped = channel.clamped(min: -1, max: 1);
      
      self[keyPath: $0.element] = channelClamped;
    };
  };
  
  public mutating func setBrightness(withAmount amount: Float){
    let amount = amount.clamped(min: -1, max: 1);
    
    Self.keyPathsForRGBTranslate.forEach {
      self[keyPath: $0] = amount;
    };
  };
  
  public mutating func adjustBrightness(byAmount adjAmount: Float){
    let adjAmount = adjAmount.clamped(min: -1, max: 1);
    
    Self.keyPathsForRGBTranslate.forEach {
      let currentValue = self[keyPath: $0];
      let nextValue = currentValue + adjAmount;
      let nextValueClamped = nextValue.clamped(min: -1, max: 1);
      
      self[keyPath: $0] = nextValueClamped;
    };
  };
  
  public mutating func setContrast(withAmount contrastFactor: Float) {
    let amount = contrastFactor.clamped(min: 0, max: 2);
    let intercept = (-0.5 * amount) + 0.5;
    
    Self.keyPathsForChannelRGB.forEach {
      self[keyPath: $0] = contrastFactor;
    };
    
    Self.keyPathsForRGBTranslate.forEach {
      self[keyPath: $0] = intercept;
    };
  };
  
  public mutating func setHueRotate(
    withAngle angle: Angle<Float>,
    shouldUseLuminance: Bool = true
  ){
    let angleInRadians = angle.radians;
    
    let cosTheta = cos(angleInRadians);
    let sinTheta = sin(angleInRadians);
    
    if shouldUseLuminance {
      let (lumR, lumG, lumB) = Self.luminance;
      
      self.m11 = lumR + cosTheta * (1 - lumR) + sinTheta * (-lumR);
      self.m12 = lumG + cosTheta * (-lumG) + sinTheta * (-lumG);
      self.m13 = lumB + cosTheta * (-lumB) + sinTheta * (1 - lumB);
      
      self.m21 = lumR + cosTheta * (-lumR) + sinTheta * (0.143);
      self.m22 = lumG + cosTheta * (1 - lumG) + sinTheta * (0.140);
      self.m23 = lumB + cosTheta * (-lumB) + sinTheta * (-0.283);
      
      self.m31 = lumR + cosTheta * (-lumR) + sinTheta * (-(1 - lumR));
      self.m32 = lumG + cosTheta * (-lumG) + sinTheta * (lumG);
      self.m33 = lumB + cosTheta * (1 - lumB) + sinTheta * (lumB);
      
    } else {
      self.m11 = 0.5 + 0.5 * cosTheta + (1 - cosTheta) * 1.0;
      self.m12 = (1 - cosTheta) * 0.0 - sinTheta * 1.0;
      self.m13 = (1 - cosTheta) * 1.0 + sinTheta * 0.0;
      
      self.m21 = (1 - cosTheta) * 1.0 + sinTheta * 0.0;
      self.m22 = 0.5 + 0.5 * cosTheta + (1 - cosTheta) * 0.0;
      self.m23 = (1 - cosTheta) * 0.0 - sinTheta * 1.0;
      
      self.m31 = (1 - cosTheta) * 0.0 - sinTheta * 1.0;
      self.m32 = (1 - cosTheta) * 1.0 + sinTheta * 0.0;
      self.m33 = 0.5 + 0.5 * cosTheta + (1 - cosTheta) * 0.0;
    };
  };
  
  public mutating func setSaturation(withFactor saturationFactor: Float) {
    let saturationFactor = saturationFactor.clamped(min: -1);
    let (lumR, lumG, lumB) = Self.luminance;
    
    self.m11 = lumR * (1 - saturationFactor) + saturationFactor;
    self.m12 = lumG * (1 - saturationFactor)
    self.m13 = lumB * (1 - saturationFactor);

    self.m21 = lumR * (1 - saturationFactor);
    self.m22 = lumG * (1 - saturationFactor) + saturationFactor;
    self.m23 = lumB * (1 - saturationFactor);

    self.m31 = lumR * (1 - saturationFactor);
    self.m32 = lumG * (1 - saturationFactor);
    self.m33 = lumB * (1 - saturationFactor) + saturationFactor;
  };
    
  public mutating func setInvertColors(
    withPercent percent: Float,
    shouldSaturate: Bool = true
  ) {
    let percentClamped = percent.clamped(min: 0, max: 1);
    guard percentClamped > 0 else {
      return;
    };
    
    let saturationFactorInvert = Float.lerp(
      valueStart: 0,
      valueEnd: -1,
      percent: .init(percentClamped),
      easing: .linear
    );
    
    self.setSaturation(withFactor: saturationFactorInvert);
    guard shouldSaturate else {
      return;
    };
    
    let saturationFactorExtra = Float.lerp(
      valueStart: 2,
      valueEnd: 1,
      percent: .init(percentClamped),
      easing: .linear
    );
    
    self = self.concatByAddingLastColumn(
      with: .saturation(withFactor: .init(saturationFactorExtra))
    );
  };
  
  public mutating func setInvert(withPercent percent: Float) {
    let percentClamped = percent.clamped(min: 0, max: 1);
    let invertMatrix = ColorMatrixRGBA.createInvertColorMatrix5x4(
      amount: percentClamped
    );
    
    self = .init(fromColorMatrix5x4: invertMatrix);
  };
  
  public mutating func setOpacity(withPercent percent: Float){
    let percentClamped = percent.clamped(min: 0, max: 1);
    let opacityMatrix =
      ColorMatrixRGBA.createOpacityColorMatrix5x4(amount: percentClamped);
    
    self = .init(fromColorMatrix5x4: opacityMatrix);
  };
  
  public func concatByAddingLastColumn(with otherColorMatrix: Self) -> Self {
    let matrixA = self.matrix4x5;
    let matrixB = otherColorMatrix.matrix4x5;
    
    var matrixResult: [[Float]] = .init(
      repeating: .init(repeating: 0, count: 5),
      count: 4
    );
    
    for rowIndex in 0..<4 {
      for colIndex in 0..<4 {
        for commonIndex in 0..<4 {
          let dotProduct =
            matrixA[rowIndex][commonIndex] * matrixB[commonIndex][colIndex];
          
          // acc dot product of row + col
          matrixResult[rowIndex][colIndex] += dotProduct;
        };
      };
    };
    
    // add last col (translation)
    for rowIndex in 0..<4 {
      let colIndex = 4;
      let sum = matrixA[rowIndex][colIndex] + matrixB[rowIndex][colIndex];
      matrixResult[rowIndex][colIndex] = sum;
    };
    
    return .init(fromColorMatrix5x4: matrixResult);
  };
  
  public func concatByExtendingThenTruncating(with otherColorMatrix: Self) -> Self {
    let matrixA = self.matrix4x5;
    let matrixB = otherColorMatrix.matrix4x5;
    
    var matrixResult: [[Float]] = .init(
      repeating: .init(repeating: 0, count: 5),
      count: 5
    );
    
    for rowIndex in 0..<5 {
      for colIndex in 0..<5 {
        for commonIndex in 0..<5 {
          let elementFallback: Float = rowIndex == colIndex ? 1 : 0;
          
          let elementMatrixA =
            matrixA[safeIndex: rowIndex]?[safeIndex: commonIndex]
            ?? elementFallback;
            
          let elementMatrixB =
            matrixB[safeIndex: commonIndex]?[safeIndex: colIndex]
            ?? elementFallback;
          
          let dotProduct = elementMatrixA * elementMatrixB;
          
          // acc dot product of row + col
          matrixResult[rowIndex][colIndex] += dotProduct;
        };
      };
    };
    
    return .init(fromColorMatrix5x4: matrixResult);
  };
};

// MARK: - ColorMatrixRGBA+StaticHelpers

public extension ColorMatrixRGBA {
  
  @available(iOS 13.0, *)
  static func extractObjTypeForColorMatrixFromVisualEffects() -> UnsafePointer<CChar>? {
    for blurEffectStyle in UIBlurEffect.Style.allCases {
      let blurEffect = UIBlurEffect(style: blurEffectStyle);
      
      let colorMatrixValuesForBlurEffect =
        blurEffect.extractColorMatrixValues();
      
      if let colorMatrixValue = colorMatrixValuesForBlurEffect.first {
        return colorMatrixValue.objCType;
      };
      
      for vibrancyEffectStyle in UIVibrancyEffectStyle.allCases {
        let vibrancyEffect = UIVibrancyEffect(
          blurEffect: blurEffect,
          style: vibrancyEffectStyle
        );
          
        let colorMatrixValuesForVibrancyEffect =
          vibrancyEffect.extractColorMatrixValues();
        
        if let colorMatrixValue = colorMatrixValuesForVibrancyEffect.first {
          return colorMatrixValue.objCType;
        };
      };
    };
    
    return nil;
  };
};

// MARK: ColorMatrixRGBA+StaticAlias
// ---------------------------------

public extension ColorMatrixRGBA {
  
  static var zero: Self {
    .init(
      m11: 0, m12: 0, m13: 0, m14: 0, m15: 0,
      m21: 0, m22: 0, m23: 0, m24: 0, m25: 0,
      m31: 0, m32: 0, m33: 0, m34: 0, m35: 0,
      m41: 0, m42: 0, m43: 0, m44: 0, m45: 0
    );
  };
  
  static var identity: Self {
    .init(
      m11: 1, m12: 0, m13: 0, m14: 0, m15: 0,
      m21: 0, m22: 1, m23: 0, m24: 0, m25: 0,
      m31: 0, m32: 0, m33: 1, m34: 0, m35: 0,
      m41: 0, m42: 0, m43: 0, m44: 1, m45: 0
    );
  };
  
  static func colorChannel(r: Float, g: Float, b: Float) -> Self {
    var matrix: Self = .identity;
    matrix.setChannels(r: r, g: g, b: b);
    return matrix;
  };
  
  static func colorShift(r: Float, g: Float, b: Float) -> Self {
    var matrix: Self = .identity;
    matrix.setColorShift(r: r, g: g, b: b);
    return matrix;
  };
  
  static func brightness(withAmount amount: Float) -> Self {
    var matrix: Self = .identity;
    matrix.setBrightness(withAmount: amount);
    return matrix;
  };
  
  static func contrast(withFactor contrastFactor: Float) -> Self {
    var matrix: Self = .identity;
    matrix.setContrast(withAmount: contrastFactor);
    return matrix;
  };
  
  static func hueRotate(withAngle angle: Angle<Float>) -> Self {
    var matrix: Self = .identity;
    matrix.setHueRotate(withAngle: angle);
    return matrix;
  };
  
  static func saturation(withFactor saturationFactor: Float) -> Self {
    var matrix: Self = .identity;
    matrix.setSaturation(withFactor: saturationFactor);
    return matrix;
  };
  
  static func invert(withPercent percent: Float) -> Self {
    var matrix: Self = .identity;
    matrix.setInvert(withPercent: percent);
    return matrix;
  };
  
  static func invertColors(
    withPercent percent: Float,
    shouldSaturate: Bool = true
  ) -> Self {
    var matrix: Self = .identity;
    matrix.setInvertColors(
      withPercent: percent,
      shouldSaturate: shouldSaturate
    );
    
    return matrix;
  };
  
  static func opacity(withPercent percent: Float) -> Self {
    var matrix: Self = .identity;
    matrix.setOpacity(withPercent: percent);
    return matrix;
  };
};

// MARK: ColorMatrixRGBA+MatrixHelpers
// -----------------------------------

public extension ColorMatrixRGBA {

  static func createBrightnessColorMatrix5x4(amount: Float) -> [[Float]] {
    return [
      [amount, 0.0   , 0.0   ],
      [0.0   , amount, 0.0   ],
      [0.0   , 0.0   , amount],
    ];
  };

  static func createContrastColorMatrix5x4(amount: Float) -> [[Float]] {
    let amount = amount.clamped(min: 0);
    let intercept = (-0.5 * amount) + 0.5;
    
    return [
      [amount, 0.0   , 0.0   , 0.0, intercept],
      [0.0   , amount, 0.0   , 0.0, intercept],
      [0.0   , 0.0   , amount, 0.0, intercept],
      [0.0   , 0.0   , 0.0   , 1.0, 0.0      ]
    ];
  };
  
  static func createGrayscaleColorMatrix3x3(amount: Float) -> [[Float]] {
    let oneMinusAmount = (1 - amount).clamped(min: 0, max: 1);
    return [
      [
        0.2126 + 0.7874 * oneMinusAmount,
        0.7152 - 0.7152 * oneMinusAmount,
        0.0722 - 0.0722 * oneMinusAmount,
      ],
      [
        0.2126 - 0.2126 * oneMinusAmount,
        0.7152 + 0.2848 * oneMinusAmount,
        0.0722 - 0.0722 * oneMinusAmount
      ],
      [
        0.2126 - 0.2126 * oneMinusAmount,
        0.7152 - 0.7152 * oneMinusAmount,
        0.0722 + 0.9278 * oneMinusAmount,
      ],
    ];
  };
  
  static func createInvertColorMatrix5x4(amount: Float) -> [[Float]] {
    let amount = amount.clamped(min: 0, max: 1);
    let multiplier = 1.0 - amount * 2.0;
    
    return [
      [multiplier, 0.0       , 0.0       , 0.0, amount],
      [0.0       , multiplier, 0.0       , 0.0, amount],
      [0.0       , 0.0       , multiplier, 0.0, amount],
      [0.0       , 0.0       , 0.0       , 1.0, 0.0   ],
    ];
  };
  
  static func createOpacityColorMatrix5x4(amount: Float) -> [[Float]] {
    let amount = amount.clamped(min: 0, max: 1);
    
    return [
      [1.0, 0.0, 0.0, 0.0   , 0.0],
      [0.0, 1.0, 0.0, 0.0   , 0.0],
      [0.0, 0.0, 1.0, 0.0   , 0.0],
      [0.0, 0.0, 0.0, amount, 0.0],
    ];
  };
  
  static func createSepiaColorMatrix3x3(amount: Float) -> [[Float]] {
    let oneMinusAmount = (1 - amount).clamped(min: 0, max: 1);
    
    return [
      [
        0.393 + 0.607 * oneMinusAmount,
        0.769 - 0.769 * oneMinusAmount,
        0.189 - 0.189 * oneMinusAmount,
      ],
      [
        0.349 - 0.349 * oneMinusAmount,
        0.686 + 0.314 * oneMinusAmount,
        0.168 - 0.168 * oneMinusAmount,
      ],
      [
        0.272 - 0.272 * oneMinusAmount,
        0.534 - 0.534 * oneMinusAmount,
        0.131 + 0.869 * oneMinusAmount,
      ],
    ];
  };
  
  static func createSaturationColorMatrix3x3(amount: Float) -> [[Float]] {
    return [
      [
        0.213 + 0.787 * amount,
        0.715 - 0.715 * amount,
        0.072 - 0.072 * amount
      ],
      [
        0.213 - 0.213 * amount,
        0.715 + 0.285 * amount,
        0.072 - 0.072 * amount
      ],
      [
        0.213 - 0.213 * amount,
        0.715 - 0.715 * amount,
        0.072 + 0.928 * amount
      ],
    ];
  };
  
  static func createHueRotateMatrix3x3(angle: Angle<Float>) -> [[Float]] {
    let angleInRadians = angle.radians;
    
    let cosHue = cos(angleInRadians);
    let sinHue = sin(angleInRadians);
    
    return [
      [
        0.213 + cosHue * 0.787 - sinHue * 0.213,
        0.715 - cosHue * 0.715 - sinHue * 0.715,
        0.072 - cosHue * 0.072 + sinHue * 0.928,
      ],
      [
        0.213 - cosHue * 0.213 + sinHue * 0.143,
        0.715 + cosHue * 0.285 + sinHue * 0.140,
        0.072 - cosHue * 0.072 - sinHue * 0.283,
      ],
      [
        0.213 - cosHue * 0.213 - sinHue * 0.787,
        0.715 - cosHue * 0.715 + sinHue * 0.715,
        0.072 + cosHue * 0.928 + sinHue * 0.072,
      ],
    ];
  };
};
