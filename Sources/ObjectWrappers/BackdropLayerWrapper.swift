//
//  BackdropLayerWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities

/// Wrapper for:`UICABackdropLayer`
@available(iOS 12, *)
public class BackdropLayerWrapper: PrivateObjectWrapper<
  CALayer,
  BackdropLayerWrapper.EncodedString
> {

  public enum EncodedString: String, PrivateObjectWrappingEncodedString {
    case className;
    
    public var encodedString: String {
      switch self {
        case .className:
          // UICABackdropLayer
          return "VUlDQUJhY2tkcm9wTGF5ZXI=";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  // TODO: temp - replace w/ `CIFilter`
  public var gaussianBlurFilterWrapper: GaussianBlurFilterWrapper? {
    guard let wrappedObject = self.wrappedObject,
          let filters = wrappedObject.filters,
          filters.count > 0
    else {
      return nil;
    };
    
    let match = filters.first {
      let filterType = ObjectWrapperHelpers.performSelector(
        forObject: $0 as AnyObject,
        selector:  NSSelectorFromString("type"),
        type: String.self
      );
      
      guard let filterType = filterType else {
        return false;
      };
      
      return filterType.lowercased().contains("blur");
    };
    
    guard let match = match as? AnyObject else {
      return nil;
    };
    
    return .init(objectToWrap: match);
  };
};
