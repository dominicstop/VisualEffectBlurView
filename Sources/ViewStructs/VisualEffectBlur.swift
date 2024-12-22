//
//  VisualEffectBlur.swift
//  
//
//  Created by Dominic Go on 9/14/23.
//

import SwiftUI


@available(iOS 13.0, *)
public struct VisualEffectBlur: UIViewRepresentable {

  @Binding public var blurEffectStyle: UIBlurEffect.Style;
  @Binding public var blurRadius: Double?;
  @Binding public var backgroundLayerSamplingSizeScale: Double?;
  
  public init(
    blurEffectStyle: Binding<UIBlurEffect.Style>,
    blurRadius: Binding<Double?> = .constant(nil),
    backgroundLayerSamplingSizeScale: Binding<Double?> = .constant(nil)
  ) {
    self._blurEffectStyle = blurEffectStyle;
    self._blurRadius = blurRadius;
    self._backgroundLayerSamplingSizeScale = backgroundLayerSamplingSizeScale;
  };

  public func makeUIView(context: Context) -> VisualEffectBlurView {
    try! VisualEffectBlurView(blurEffectStyle: self.blurEffectStyle);
  };

  public func updateUIView(
    _ view: VisualEffectBlurView,
    context: Context
  ) {
    view.blurEffectStyle = self.blurEffectStyle;
    
    if let blurRadius = self.blurRadius {
      view.blurRadius = CGFloat(blurRadius);
    };
    
    if let backgroundLayerSamplingSizeScale = self.backgroundLayerSamplingSizeScale {
      view.backgroundLayerSamplingSizeScale = CGFloat(backgroundLayerSamplingSizeScale);
    };
  };
};
