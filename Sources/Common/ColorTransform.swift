//
//  ColorTransform.swift
//  
//
//  Created by Dominic Go on 12/11/24.
//

import Foundation
import DGSwiftUtilities


public struct ColorTransform: Equatable, MutableReference {

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
  public var hueRotate: Angle<Float>;
  
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
        with: .saturation(withFactor: self.saturation)
      )
      .concatByAddingLastColumn(
        with: .hueRotate(withAngle: self.hueRotate)
      );
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    intensityRed: Float = 1,
    intensityGreen: Float = 1,
    intensityBlue: Float = 1,
    shiftRed: Float = 0,
    shiftGreen: Float = 0,
    shiftBlue: Float = 0,
    contrast: Float = 1,
    brightness: Float = 0,
    saturation: Float = 1,
    hueRotate: Angle<Float> = .zero
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
    self.hueRotate = hueRotate;
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
  
  public func withHueRotate(_ value: Angle<Float>) -> Self {
    var copy = self;
    copy.hueRotate = value;
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
  func withHueRotate(_ value: Angle<Float>) -> Self {
    self.pointee.hueRotate = value;
    return self;
  };
};
