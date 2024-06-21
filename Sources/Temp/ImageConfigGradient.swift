//
//  ImageConfigGradient.swift
//  
//
//  Created by Dominic Go on 6/20/24.
//

import UIKit
import DGSwiftUtilities


public struct ImageConfigGradient {

  // MARK: Properties
  // ----------------
  
  public var type: CAGradientLayerType;
  
  public var colors: [CGColor];
  public var locations: [NSNumber]?;
  
  public var startPoint: CGPoint;
  public var endPoint: CGPoint;
  public var size: CGSize;
  
  public var cornerRadius: CGFloat;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var gradientLayer: CALayer {
    let layer = CAGradientLayer();
    
    layer.type = self.type;
    layer.colors = self.colors;
    layer.locations = self.locations;
    layer.startPoint = self.startPoint;
    layer.endPoint = self.endPoint;
    layer.cornerRadius = self.cornerRadius;
    
    return layer;
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    type: CAGradientLayerType = .axial,
    colors: [UIColor],
    locations: [NSNumber]? = nil,
    startPointPreset: PointPreset = .top,
    endPointPreset: PointPreset = .bottom,
    cornerRadius: CGFloat = 0,
    size: CGSize
  ){
    
    self.type = type;
    
    self.colors = colors.map {
      $0.cgColor;
    };
    
    self.locations = locations;
    self.startPoint = startPointPreset.point;
    self.endPoint = endPointPreset.point;
    self.size = size;
    self.cornerRadius = cornerRadius;
  };
  
  public init(
    type: CAGradientLayerType,
    colors: [CGColor],
    locations: [NSNumber]? = nil,
    startPoint: CGPoint,
    endPoint: CGPoint,
    size: CGSize,
    cornerRadius: CGFloat
  ) {
    self.type = type;
    self.colors = colors;
    self.locations = locations;
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    self.size = size;
    self.cornerRadius = cornerRadius;
  }
  
  // MARK: - Functions
  // -----------------
  
  public mutating func setSizeIfNotSet(_ newSize: CGSize){
    let nextWidth = self.size.width  <= 0
      ? newSize.width
      : self.size.width;
      
    let nextHeight = self.size.height <= 0
      ? newSize.height
      : self.size.height;
  
    self.size = CGSize(width : nextWidth, height: nextHeight);
  };
  
  public func makeImage() -> UIImage {
    return UIGraphicsImageRenderer(size: self.size).image { context in
      let rect = CGRect(origin: .zero, size: self.size);
      
      let gradient = self.gradientLayer;
      gradient.frame = rect;
      gradient.render(in: context.cgContext);
      
      let clipPath = UIBezierPath(
        roundedRect : rect,
        cornerRadius: self.cornerRadius
      );
      
      clipPath.addClip();
    };
  };
};

// MARK: - Static Alias
// --------------------

extension ImageConfigGradient {

  public func topDownGradient(
    colors: [UIColor],
    locations: [NSNumber]? = nil,
    cornerRadius: CGFloat = 0,
    size: CGSize
  ) -> Self {
    .init(
      type: .axial,
      colors: colors,
      locations: locations,
      startPointPreset: .top,
      endPointPreset: .bottom,
      cornerRadius: cornerRadius,
      size: size
    );
  };
  
  public func bottomToTopGradient(
    colors: [UIColor],
    locations: [NSNumber]? = nil,
    cornerRadius: CGFloat = 0,
    size: CGSize
  ) -> Self {
    .init(
      type: .axial,
      colors: colors,
      locations: locations,
      startPointPreset: .bottom,
      endPointPreset: .top,
      cornerRadius: cornerRadius,
      size: size
    );
  };
  
  public func leftToRightGradient(
    colors: [UIColor],
    locations: [NSNumber]? = nil,
    cornerRadius: CGFloat = 0,
    size: CGSize
  ) -> Self {
    .init(
      type: .axial,
      colors: colors,
      locations: locations,
      startPointPreset: .left,
      endPointPreset: .right,
      cornerRadius: cornerRadius,
      size: size
    );
  };
  
  public func rightToLeft(
    colors: [UIColor],
    locations: [NSNumber]? = nil,
    cornerRadius: CGFloat = 0,
    size: CGSize
  ) -> Self {
    .init(
      type: .axial,
      colors: colors,
      locations: locations,
      startPointPreset: .right,
      endPointPreset: .left,
      cornerRadius: cornerRadius,
      size: size
    );
  };
};
