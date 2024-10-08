//
//  ColorMatrixRGBA+UniformInterpolatable.swift
//
//  Created by Dominic Go on 10/8/24.
//

import Foundation
import DGSwiftUtilities


extension ColorMatrixRGBA: UniformInterpolatable {

  public static func lerp(
    valueStart: ColorMatrixRGBA,
    valueEnd: ColorMatrixRGBA,
    percent: CGFloat,
    easing: InterpolationEasing?
  ) -> ColorMatrixRGBA {
  
    var newValue: Self = .zero;
    
    for matrixKeyPath in Self.keyPathsMatrixAll {
      let valueStartElement = valueStart[keyPath: matrixKeyPath];
      let valueEndElement = valueEnd[keyPath: matrixKeyPath];
      
      newValue[keyPath: matrixKeyPath] = Float.lerp(
        valueStart: valueStartElement,
        valueEnd: valueEndElement,
        percent: percent,
        easing: easing
      );
    };
    
    return newValue;
  };
};
