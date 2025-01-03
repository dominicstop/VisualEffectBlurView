//
//  LayerWrapper.swift
//  
//
//  Created by Dominic Go on 12/20/24.
//

import UIKit
import DGSwiftUtilities


/// Wraps: `CALayer`
///
public class LayerWrapper: ObjectWrapper<
  CALayer,
  LayerWrapper.EncodedString
> {
  
  public enum EncodedString: HashedStringDecodable {
    case propertySetterFilters;
    case propertyGetterFilters;
    
    case propertyGetterCompFilter;
    case propertySetterCompFilter;
    
    public var encodedString: String {
      switch self {
        case .propertySetterFilters:
          // setFilters:
          return "c2V0RmlsdGVyczo=";
          
        case .propertyGetterFilters:
          // filters
          return "ZmlsdGVycw==";
          
        case .propertyGetterCompFilter:
          // compositingFilter
          return "Y29tcG9zaXRpbmdGaWx0ZXI=";
          
        case .propertySetterCompFilter:
          // setCompositingFilter:
          return "c2V0Q29tcG9zaXRpbmdGaWx0ZXI6";
      };
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  public var currentFilters: [NSObject]? {
    let values = try? self.getValue(forHashedString: .propertyGetterFilters);
    
    guard let values = values else {
      return nil;
    };
    
    return values as? [NSObject];
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  public var currentFiltersWrapped: [LayerFilterWrapper]? {
    guard let currentFilters = self.currentFilters else {
      return nil;
    };
    
    return currentFilters.compactMap {
      .init(objectToWrap: $0);
    };
  };
  
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
  
  public func setValueForCompFilter(_ value: Any?) throws {
    try self.setValue(
      forHashedString: .propertyGetterCompFilter,
      value: value
    );
  };
  
  public func getValueForCompFilter() throws -> Any? {
    try self.getValue(forHashedString: .propertyGetterCompFilter);
  };
  
  // MARK: - Helpers
  // ---------------
  
  public func setBlendModeForCompFilter(with blendMode: BlendMode?) throws {
    try self.setValueForCompFilter(blendMode?.asCompositingFilterName);
  };
};

// MARK: - `LayerWrappable`
// ------------------------

public protocol LayerWrappable {
  
  var asLayerWrapper: LayerWrapper? { get };
};

// MARK: - `LayerWrappable+Helpers`
// --------------------------------

public extension LayerWrappable {
  
  var currentFilters: [NSObject]? {
    self.asLayerWrapper?.currentFilters;
  };
  
  var currentFiltersWrapped: [LayerFilterWrapper]? {
    self.asLayerWrapper?.currentFiltersWrapped;
  };
  
  var gaussianBlurFilterWrapper: GaussianBlurFilterWrapper? {
    self.asLayerWrapper?.gaussianBlurFilterWrapper;
  };
  
  func setValuesForFilters(newFilters: [AnyObject]) throws {
    guard let layerWrapped = self.asLayerWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get wrapper for layer"
      );
    };
    
    try layerWrapped.setValuesForFilters(newFilters: newFilters);
  };
  
  func setValueForCompFilter(_ value: Any) throws {
    guard let layerWrapped = self.asLayerWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get wrapper for layer"
      );
    };
    
    try layerWrapped.setValueForCompFilter(value);
  };
  
  func setBlendModeForCompFilter(with blendMode: BlendMode) throws {
    try self.setValueForCompFilter(blendMode.asCompositingFilterName);
  };
};

// MARK: - `CALayer+LayerWrappable`
// -------------------------------

extension CALayer: LayerWrappable {
  
  public var asLayerWrapper: LayerWrapper? {
    .init(objectToWrap: self);
  };
};
