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
public class LayerWrapper: PrivateObjectWrapper<
  CALayer,
  LayerWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    case propertySetterFilters;
    case propertyGetterFilters;
    
    public var encodedString: String {
      switch self {
        case .className:
          // UICABackdropLayer
          return "VUlDQUJhY2tkcm9wTGF5ZXI=";
          
        case .propertySetterFilters:
          // setFilters:
          return "c2V0RmlsdGVyczo=";
          
        case .propertyGetterFilters:
          // filters
          return "ZmlsdGVycw==";
      };
    };
  };
  
  // MARK: - Properties: Getters
  // --------------------------
  
  public var currentFilters: [NSObject]? {
    let values = try? self.getValue(forHashedString: .propertyGetterFilters);
    
    guard let values = values else {
      return nil;
    };
    
    return values as? [NSObject];
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  // TODO: temp - replace w/ `CIFilter`
  public var gaussianBlurFilterWrapper: GaussianBlurFilterWrapper? {
    guard let filters = self.currentFilters,
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
    
    guard let match = match else {
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
