//
//  BackgroundLayerWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities

/// Wrapper for:`UICABackdropLayer`
/// Old name: `BackdropLayerWrapper`
///
@available(iOS 12, *)
public class BackgroundLayerWrapper: PrivateObjectWrapper<
  CALayer,
  BackgroundLayerWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    case propertySetterFilters;
    
    public var encodedString: String {
      switch self {
        case .className:
          // UICABackdropLayer
          return "VUlDQUJhY2tkcm9wTGF5ZXI=";
          
        case .propertySetterFilters:
          // setFilters:
          return "c2V0RmlsdGVyczo=";
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

  // MARK: - Wrapped Methods
  // -----------------------
  
  public func setValuesForFilters(newFilters: [AnyObject]) throws {
    try self.performSelector(
      usingEncodedString: .propertySetterFilters,
      withArg1: newFilters
    );
  };
};
