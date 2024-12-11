//
//  ColorTransform.swift
//  
//
//  Created by Dominic Go on 12/11/24.
//

import Foundation
import DGSwiftUtilities


public struct ColorTransform: Equatable {

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
};
