//
//  ColorTransform.swift
//  
//
//  Created by Dominic Go on 12/11/24.
//

import Foundation
import DGSwiftUtilities


public struct ColorTransform: Equatable, MutableReference {

  public static let `default`: Self = .init(
    intensityRed: 1,
    intensityGreen: 1,
    intensityBlue: 1,
    shiftRed: 0,
    shiftGreen: 0,
    shiftBlue: 0,
    contrast: 1,
    brightness: 0,
    saturation: 1,
    invert: 0,
    hueRotate: .zero,
    opacity: 1
  );

  // MARK: - Properties
  // ------------------

  public var intensityRed: Float;
  public var intensityGreen: Float;
  public var intensityBlue: Float;
  
  public var shiftRed: Float;
  public var shiftGreen: Float;
  public var shiftBlue: Float;
  
  public var contrast: Float;
  public var brightness: Float;
  
  public var saturation: Float;
  public var invert: Float;
  public var hueRotate: Angle<Float>;
  
  public var opacity: Float;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var colorMatrix: ColorMatrixRGBA {
    ColorMatrixRGBA.identity
      .concatByAddingLastColumn(
        with: .colorChannel(
          r: self.intensityRed,
          g: self.intensityBlue,
          b: self.intensityGreen
        )
      )
      .concatByAddingLastColumn(
        with: .colorShift(
          r: self.shiftRed,
          g: self.shiftBlue,
          b: self.shiftGreen
        )
      )
      .concatByAddingLastColumn(
        with: .contrast(withFactor: self.contrast)
      )
      .concatByAddingLastColumn(
        with: .brightness(withAmount: self.brightness)
      )
      .concatByAddingLastColumn(
        with: .invert(withPercent: self.invert)
      )
      .concatByAddingLastColumn(
        with: .saturation(withFactor: self.saturation)
      )
      .concatByAddingLastColumn(
        with: .hueRotate(withAngle: self.hueRotate)
      )
      .concatByAddingLastColumn(
        with: .opacity(withPercent: self.opacity)
      );
  };
  
  // MARK: - Init
  // ------------
  
  public init() {
    self = .default;
  };
  
  public init(
    intensityRed: Float,
    intensityGreen: Float,
    intensityBlue: Float,
    shiftRed: Float,
    shiftGreen: Float,
    shiftBlue: Float,
    contrast: Float,
    brightness: Float,
    saturation: Float,
    invert: Float,
    hueRotate: Angle<Float>,
    opacity: Float
  ) {
    self.intensityRed = intensityRed;
    self.intensityGreen = intensityGreen;
    self.intensityBlue = intensityBlue;
    
    self.shiftRed = shiftRed;
    self.shiftGreen = shiftGreen;
    self.shiftBlue = shiftBlue;
    
    self.contrast = contrast;
    self.brightness = brightness;
    
    self.saturation = saturation;
    self.invert = invert;
    self.hueRotate = hueRotate;
    
    self.opacity = opacity;
  };
  
  // MARK: - Chain Functions
  // -----------------------
  
  public func withChannelIntensity(r: Float, g: Float, b: Float) -> Self {
    var copy = self;
    copy.intensityRed = r;
    copy.intensityGreen = g;
    copy.intensityBlue = b;
    
    return copy;
  };
  
  public func withIntensityRed(_ value: Float) -> Self {
    var copy = self;
    copy.intensityRed = value;
    return copy;
  };
  
  public func withIntensityGreen(_ value: Float) -> Self {
    var copy = self;
    copy.intensityGreen = value;
    return copy;
  };
  
  public func withIntensityBlue(_ value: Float) -> Self {
    var copy = self;
    copy.intensityBlue = value;
    return copy;
  };
  
  public func withShiftRed(_ value: Float) -> Self {
    var copy = self;
    copy.shiftRed = value;
    return copy;
  };
  
  public func withShiftGreen(_ value: Float) -> Self {
    var copy = self;
    copy.shiftGreen = value;
    return copy;
  };
  
  public func withShiftBlue(_ value: Float) -> Self {
    var copy = self;
    copy.shiftBlue = value;
    return copy;
  };
  
  public func withChannelShift(r: Float, g: Float, b: Float) -> Self {
    var copy = self;
    copy.shiftRed = r;
    copy.shiftGreen = g;
    copy.shiftBlue = b;
    
    return copy;
  };
  
  public func withContrast(_ value: Float) -> Self {
    var copy = self;
    copy.contrast = value;
    return copy;
  };
  
  public func withBrightness(_ value: Float) -> Self {
    var copy = self;
    copy.brightness = value;
    return copy;
  };
  
  public func withSaturation(_ value: Float) -> Self {
    var copy = self;
    copy.saturation = value;
    return copy;
  };
  
  public func withInvert(_ percent: Float) -> Self {
    var copy = self;
    copy.invert = percent;
    return copy;
  };
  
  public func withHueRotate(_ value: Angle<Float>) -> Self {
    var copy = self;
    copy.hueRotate = value;
    return copy;
  };
  
  public func withOpacity(_ percent: Float) -> Self {
    var copy = self;
    copy.opacity = percent;
    return copy;
  };
};

// MARK: - UnsafeMutablePointer+ColorTransform
// -------------------------------------------

public extension UnsafeMutablePointer<ColorTransform> {

  @discardableResult
  func withChannelIntensity(r: Float, g: Float, b: Float) -> Self {
    self.pointee.intensityRed = r;
    self.pointee.intensityGreen = g;
    self.pointee.intensityBlue = b;
    
    return self;
  };
  
  @discardableResult
  func withIntensityRed(_ value: Float) -> Self {
    self.pointee.intensityRed = value;
    return self;
  };
  
  @discardableResult
  func withIntensityGreen(_ value: Float) -> Self {
    self.pointee.intensityGreen = value;
    return self;
  };
  
  @discardableResult
  func withIntensityBlue(_ value: Float) -> Self {
    self.pointee.intensityBlue = value;
    return self;
  };
  
  @discardableResult
  func withShiftRed(_ value: Float) -> Self {
    self.pointee.shiftRed = value;
    return self;
  };
  
  @discardableResult
  func withShiftGreen(_ value: Float) -> Self {
    self.pointee.shiftGreen = value;
    return self;
  };
  
  @discardableResult
  func withShiftBlue(_ value: Float) -> Self {
    self.pointee.shiftBlue = value;
    return self;
  };
  
  @discardableResult
  func withChannelShift(r: Float, g: Float, b: Float) -> Self {
    self.pointee.shiftRed = r;
    self.pointee.shiftGreen = g;
    self.pointee.shiftBlue = b;
    
    return self;
  };
  
  @discardableResult
  func withContrast(_ value: Float) -> Self {
    self.pointee.contrast = value;
    return self;
  };
  
  @discardableResult
  func withBrightness(_ value: Float) -> Self {
    self.pointee.brightness = value;
    return self;
  };
  
  @discardableResult
  func withSaturation(_ value: Float) -> Self {
    self.pointee.saturation = value;
    return self;
  };
  
  @discardableResult
  func withInvert(_ percent: Float) -> Self {
    self.pointee.invert = percent;
    return self;
  };
  
  @discardableResult
  func withHueRotate(_ value: Angle<Float>) -> Self {
    self.pointee.hueRotate = value;
    return self;
  };
  
  @discardableResult
  func withOpacity(_ percent: Float) -> Self {
    self.pointee.opacity = percent;
    return self;
  };
};

// MARK: - ColorTransform+ElementInterpolatable
// --------------------------------------------

extension ColorTransform: ElementInterpolatable {
  
  public struct InterpolatableElements: OptionSet, CompositeInterpolatableElements {
    public let rawValue: Int;
    
    public static let intensityRed   = Self(rawValue: 1 << 2 );
    public static let intensityGreen = Self(rawValue: 1 << 3 );
    public static let intensityBlue  = Self(rawValue: 1 << 4 );
    public static let shiftRed       = Self(rawValue: 1 << 5 );
    public static let shiftGreen     = Self(rawValue: 1 << 6 );
    public static let shiftBlue      = Self(rawValue: 1 << 7 );
    public static let contrast       = Self(rawValue: 1 << 8 );
    public static let brightness     = Self(rawValue: 1 << 9 );
    public static let saturation     = Self(rawValue: 1 << 10);
    public static let invert         = Self(rawValue: 1 << 11);
    public static let hueRotate      = Self(rawValue: 1 << 12);
    public static let opacity        = Self(rawValue: 1 << 13);

    public var associatedAnyKeyPaths: [AnyKeyPath] {
      guard !self.isEmpty else {
        return [];
      };
      
      var keyPaths: [PartialKeyPath<InterpolatableValue>] = [];
      
      if self.contains(.intensityRed) {
        keyPaths.append(\.intensityRed);
      };
      
      if self.contains(.intensityGreen) {
        keyPaths.append(\.intensityGreen);
      };
      
      if self.contains(.intensityBlue) {
        keyPaths.append(\.intensityBlue);
      };
      
      if self.contains(.shiftRed) {
        keyPaths.append(\.shiftRed);
      };
      
      if self.contains(.shiftGreen) {
        keyPaths.append(\.shiftGreen);
      };
      
      if self.contains(.shiftBlue) {
        keyPaths.append(\.shiftBlue);
      };
      
      if self.contains(.contrast) {
        keyPaths.append(\.contrast);
      };
      
      if self.contains(.brightness) {
        keyPaths.append(\.brightness);
      };
      
      if self.contains(.saturation) {
        keyPaths.append(\.saturation);
      };
      
      if self.contains(.invert) {
        keyPaths.append(\.invert);
      };
      
      if self.contains(.hueRotate) {
        keyPaths.append(\.hueRotate);
      };
      
      return keyPaths;
    };
    
    public init(rawValue: Int) {
      self.rawValue = rawValue;
    };
  };

  public static var interpolatablePropertiesMap: InterpolatableValuesMap = [
    .init(keyPath: \.intensityRed): Float.self,
    .init(keyPath: \.intensityGreen): Float.self,
    .init(keyPath: \.intensityBlue): Float.self,
    .init(keyPath: \.shiftRed): Float.self,
    .init(keyPath: \.shiftGreen): Float.self,
    .init(keyPath: \.shiftBlue): Float.self,
    .init(keyPath: \.contrast): Float.self,
    .init(keyPath: \.brightness): Float.self,
    .init(keyPath: \.saturation): Float.self,
    .init(keyPath: \.invert): Float.self,
    .init(keyPath: \.hueRotate): Angle<Float>.self,
    .init(keyPath: \.opacity): Float.self,
  ];
};
