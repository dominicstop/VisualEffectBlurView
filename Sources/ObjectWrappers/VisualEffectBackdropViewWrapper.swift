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

  public enum EncodedString: String, PrivateObjectWrappingEncodedString {
    case className;
    case backdropLayer;
    case applyRequestedFilterEffects;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectBackdropView
          return "X1VJVmlzdWFsRWZmZWN0QmFja2Ryb3BWaWV3";
          
        case .backdropLayer:
          // backdropLayer
          return "YmFja2Ryb3BMYXllcg==";
          
        case .applyRequestedFilterEffects:
          // applyRequestedFilterEffects
          return "YXBwbHlSZXF1ZXN0ZWRGaWx0ZXJFZmZlY3Rz";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  /// Selector:
  /// `-(CABackdropLayer *)backdropLayer;`
  public var backdropLayerWrapper: BackdropLayerWrapper? {
    let result = try? self.performSelector(
      usingEncodedString: .backdropLayer,
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
      usingEncodedString: .applyRequestedFilterEffects
    );
  };
};
