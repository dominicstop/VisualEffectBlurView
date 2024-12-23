//
//  UVESubviewWrapper.swift
//  
//
//  Created by Dominic Go on 12/18/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `_UIVisualEffectSubview`
///
/// Conforms to: `_UIVisualEffectViewParticipating` (wrapper:
/// `UVEViewParticipatingWrapper`)
///
/// Subclasses:
/// * `_UIVisualEffectBackdropView` (wrapper: `UVEBackdropViewWrapper`)
/// * `_UIVisualEffectContentView` (wrapper: `UVEContentViewWrapper`)
///
public class UVESubviewWrapper:
  PrivateObjectWrapper<UIView, UVESubviewWrapper.EncodedString>,
  UVEViewParticipatingWrappable
{
  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectSubview
          return "X1VJVmlzdWFsRWZmZWN0U3Vidmlldw==";
      };
    };
  };
  
  public lazy var asEffectViewParticipatingWrapped: UVEViewParticipatingWrapper? = {
    guard let wrappedObject = self.wrappedObject else {
      return nil;
    };
    
    return .init(objectToWrap: wrappedObject);
  }();
  
  private var _layerWrapped: LayerWrapper?;
  public var layerWrapped: LayerWrapper? {
    if let layerWrapped = self._layerWrapped {
      return layerWrapped;
    };
    
    guard let view = self.wrappedObject,
          let layerWrapped = LayerWrapper(objectToWrap: view.layer)
    else {
      return nil;
    };
    
    self._layerWrapped = layerWrapped;
    return layerWrapped;
  };
};
