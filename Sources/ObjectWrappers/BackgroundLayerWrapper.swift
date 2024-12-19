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
    
    public var encodedString: String {
      switch self {
        case .className:
          // UICABackdropLayer
          return "VUlDQUJhY2tkcm9wTGF5ZXI=";
      };
    };
  };
  
  public lazy var asLayerWrapper: LayerWrapper? = {
    guard let instance = self.wrappedObject else {
      return nil;
    };
    
    return .init(objectToWrap: instance);
  }();
};
