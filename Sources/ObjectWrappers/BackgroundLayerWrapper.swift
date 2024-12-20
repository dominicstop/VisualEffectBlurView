//
//  BackgroundLayerWrapper.swift
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
public class BackgroundLayerWrapper:
  PrivateObjectWrapper<CALayer, BackgroundLayerWrapper.EncodedString>,
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
    
    public var encodedString: String {
      switch self {
        case .className:
          // UICABackdropLayer
          return "VUlDQUJhY2tkcm9wTGF5ZXI=";
          
          // allowsInPlaceFiltering
        case .propertyGetterShouldAllowFilteringInPlace:
          return "YWxsb3dzSW5QbGFjZUZpbHRlcmluZw==";
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
};
