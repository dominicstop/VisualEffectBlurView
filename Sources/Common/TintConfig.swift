//
//  TintConfig.swift
//  
//
//  Created by Dominic Go on 12/23/24.
//

import UIKit
import DGSwiftUtilities


public struct TintConfig: Comparable {

  public static let noTint: Self = .init(
    tintColor: .clear,
    opacity: 0,
    blendMode: nil
  );
  
  public var tintColor: UIColor;
  public var opacity: CGFloat;
  public var blendMode: BlendMode?;
  
  public init(
    tintColor: UIColor,
    opacity: CGFloat,
    blendMode: BlendMode? = nil
  ) {
    self.tintColor = tintColor
    self.opacity = opacity
    self.blendMode = blendMode
  };
  
  public func apply(toLayer layer: CALayer) throws {
    guard let layerWrapped = layer.asLayerWrapper,
          layerWrapped.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get wrapper for layer"
      );
    };
    
    try self.apply(toLayerWrapper: layerWrapped);
  };
  
  public func apply(toLayerWrapper layerWrapped: LayerWrapper) throws {
    guard let layer = layerWrapped.wrappedObject else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get layer"
      );
    };
    
    layer.backgroundColor = self.tintColor.cgColor;
    layer.opacity = .init(self.opacity);
    
    try layerWrapped.setBlendModeForCompFilter(with: blendMode);
  };
};
