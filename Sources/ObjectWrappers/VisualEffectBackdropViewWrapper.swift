//
//  VisualEffectBackdropViewWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for:`_UIVisualEffectBackdropView`
@available(iOS 12, *)
public class VisualEffectBackdropViewWrapper: PrivateObjectWrapper<
  UIView,
  VisualEffectBackdropViewWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    /// `backdropLayer`
    case getterBgLayer;
    
    /// `applyRequestedFilterEffects`
    case methodApplyCurrentFilterEffects;
    
    /// `applyIdentityFilterEffects`
    case methodApplyDefaultFilterEffects;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectBackdropView
          return "X1VJVmlzdWFsRWZmZWN0QmFja2Ryb3BWaWV3";
          
        case .getterBgLayer:
          // backdropLayer
          return "YmFja2Ryb3BMYXllcg==";
          
        case .methodApplyCurrentFilterEffects:
          // applyRequestedFilterEffects
          return "YXBwbHlSZXF1ZXN0ZWRGaWx0ZXJFZmZlY3Rz";
          
        case .methodApplyDefaultFilterEffects:
          // applyIdentityFilterEffects
          return "YXBwbHlJZGVudGl0eUZpbHRlckVmZmVjdHM=";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  /// Selector:
  /// `-(CABackdropLayer *)backdropLayer;`
  public var bgLayerWrapper: BackdropLayerWrapper? {
    let result = try? self.performSelector(
      usingEncodedString: .getterBgLayer,
      type: CALayer.self
    );
    
    guard let result = result else {
      return nil;
    };
    
    return .init(objectToWrap: result);
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Selector:
  /// `-(void)applyRequestedFilterEffects`
  public func applyRequestedFilterEffects() throws {
    try self.performSelector(
      usingEncodedString: .methodApplyCurrentFilterEffects
    );
  };
  
  /// Selector:
  /// `-(void)applyIdentityFilterEffects`
  public func applyIdentityFilterEffects() throws {
    try self.performSelector(
      usingEncodedString: .methodApplyDefaultFilterEffects
    );
  };
};
