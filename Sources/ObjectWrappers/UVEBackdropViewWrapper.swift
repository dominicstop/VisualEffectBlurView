//
//  VisualEffectBackdropViewWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for:`_UIVisualEffectBackdropView`
///
/// Subclass of: `_UIVisualEffectSubview`
/// * Wrapper: `UVESubviewWrapper`.
///
/// Inherits conformance to: `_UIVisualEffectViewParticipating`
/// * Wrapper: `UVEViewParticipatingWrappable`
///
/// Old name: `VisualEffectBackdropViewWrapper`
///
@available(iOS 12, *)
public class UVEBackdropViewWrapper:
  PrivateObjectWrapper<UIView, UVEBackdropViewWrapper.EncodedString>,
  UVEViewParticipatingWrappable
{

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    /// `backdropLayer`
    case getterBgLayer;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectBackdropView
          return "X1VJVmlzdWFsRWZmZWN0QmFja2Ryb3BWaWV3";
          
        case .getterBgLayer:
          // backdropLayer
          return "YmFja2Ryb3BMYXllcg==";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  public lazy var asEffectViewParticipatingWrapped: UVEViewParticipatingWrapper? = {
    guard let wrappedObject = self.wrappedObject else {
      return nil;
    };
    
    return .init(objectToWrap: wrappedObject);
  }();
  
  /// Selector:
  /// `-(CABackdropLayer *)backdropLayer;`
  public var bgLayerWrapper: LayerWrapper? {
    let result = try? self.performSelector(
      usingEncodedString: .getterBgLayer,
      type: CALayer.self
    );
    
    guard let result = result else {
      return nil;
    };
    
    return .init(objectToWrap: result);
  };
};
