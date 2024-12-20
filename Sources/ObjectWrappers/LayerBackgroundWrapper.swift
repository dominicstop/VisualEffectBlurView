//
//  LayerBackgroundWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities

/// Wrapper for:`UICABackdropLayer`
/// Old name: `BackdropLayerWrapper` -> `LayerWrapper`
///
@available(iOS 12, *)
public class LayerBackgroundWrapper:
  PrivateObjectWrapper<CALayer, LayerBackgroundWrapper.EncodedString>,
  LayerWrappable
{
  
  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    /// Selectors:
    /// `@property (assign) BOOL allowsInPlaceFiltering;
    /// `-(BOOL)allowsInPlaceFiltering;
    /// `-(void)setAllowsInPlaceFiltering:(BOOL)arg1 ;`
    ///
    case propertyGetterShouldAllowFilteringInPlace;
    
    /// Selectors:
    /// `@property (assign) double scale;
    /// `-(double)scale;`
    /// `-(void)setScale:(double)arg1 ;`
    ///
    case propertyGetterSamplingSizeScale;
    
    public var encodedString: String {
      switch self {
        case .className:
          // UICABackdropLayer
          return "VUlDQUJhY2tkcm9wTGF5ZXI=";
          
          
        case .propertyGetterShouldAllowFilteringInPlace:
          // allowsInPlaceFiltering
          return "YWxsb3dzSW5QbGFjZUZpbHRlcmluZw==";
          
        case .propertyGetterSamplingSizeScale:
          // scale
          return "c2NhbGU=";
      };
    };
  };
  
  public lazy var asLayerWrapper: LayerWrapper? = {
    guard let instance = self.wrappedObject else {
      return nil;
    };
    
    return .init(objectToWrap: instance);
  }();
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  /// Selectors:
  /// `@property (assign) BOOL allowsInPlaceFiltering;
  /// `-(BOOL)allowsInPlaceFiltering;
  ///
  public func getShouldAllowFilteringInPlace() throws -> Bool {
    let value = try self.getValue(
      forHashedString: .propertyGetterShouldAllowFilteringInPlace,
      type: Bool.self
    );
    
    guard let value = value else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value for property"
      );
    };
    
    return value;
  };
  
  /// Selectors:
  /// `@property (assign) BOOL allowsInPlaceFiltering;
  /// `-(void)setAllowsInPlaceFiltering:(BOOL)arg1 ;`
  ///
  public func setShouldAllowFilteringInPlace(_ isEnabled: Bool) throws {
    try self.setValue(
      forHashedString: .propertyGetterShouldAllowFilteringInPlace,
      value: isEnabled
    );
  };

  /// Selectors:
  /// `@property (assign) double scale;
  /// `-(double)scale;`
  ///
  public func getSamplingSizeScale() throws -> CGFloat {
    let value = try self.getValue(
      forHashedString: .propertyGetterSamplingSizeScale,
      type: CGFloat.self
    );
    
    guard let value = value else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value for property"
      );
    };
    
    return value;
  };
  
  /// Selectors:
  /// `@property (assign) double scale;
  /// `-(void)setScale:(double)arg1 ;`
  ///
  public func setSamplingSizeScale(_ scale: CGFloat) throws {
    try self.setValue(
      forHashedString: .propertyGetterShouldAllowFilteringInPlace,
      value: scale
    );
  };
};
