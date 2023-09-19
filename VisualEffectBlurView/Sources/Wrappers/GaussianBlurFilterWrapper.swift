//
//  GaussianBlurFilterWrapper.swift
//  
//
//  Created by Dominic Go on 9/17/23.
//

import UIKit

class GaussianBlurFilterWrapper: ObjectWrapping {

  fileprivate enum EncodedString: String, HashedStringDecodable {
    case inputRadius;
    
    var encodedString: String {
      switch self {
        case .inputRadius:
          // inputRadius
          return "aW5wdXRSYWRpdXM=";
      };
    };
  };
  
  var objectWrapper: ObjectWrapper<AnyObject>;
  
  var inputRadius: CGFloat? {
    get {
      let encodedString: EncodedString = .inputRadius;
      guard let decodedString = encodedString.decodedString else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.inputRadius - get",
          "- failed to get decodedString",
          "- encodedString.rawValue:", encodedString.rawValue,
          "- encodedString.encodedString:", encodedString.encodedString
        );
        #endif
        return nil;
      };
    
      guard let wrappedObject = self.wrappedObject,
            let inputRadiusRaw = wrappedObject.value(forKey: decodedString),
            let inputRadius = inputRadiusRaw as? CGFloat
      else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.inputRadius - get",
          "- failed to get inputRadius"
        );
        #endif
        return nil;
      };
      
      return inputRadius;
    }
    set {
      let encodedString: EncodedString = .inputRadius;
      guard let decodedString = encodedString.decodedString else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.inputRadius - set",
          "- failed to get decodedString",
          "- encodedString.rawValue:", encodedString.rawValue,
          "- encodedString.encodedString:", encodedString.encodedString
        );
        #endif
        return;
      };
      
      guard let wrappedObject = self.wrappedObject else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.inputRadius - set",
          "- failed to get wrappedObject"
        );
        #endif
        return;
      };
      
      wrappedObject.setValue(newValue, forKey: decodedString);
    }
  };
  
  init?(
    fromBackdropLayer backdropLayer: CALayer?,
    shouldRetainObject: Bool = false
  ){
  
    guard let backdropLayer = backdropLayer,
          let filters = backdropLayer.filters,
          filters.count > 0
    else {
      #if DEBUG
      print(
        "GaussianBlurFilterWrapper.init",
        "- could not get backdropLayer filters"
      );
      #endif
      return nil;
    };
    
    let match = filters.first {
      let filterType = VisualEffectBlurHelpers.performSelector(
        forObject: $0 as AnyObject,
        selector:  NSSelectorFromString("type"),
        type: String.self
      );
      
      guard let filterType = filterType else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.init",
          "- unable to get: filterType",
          "- selector failed for: \($0)"
        );
        #endif
        return false;
      };
      
      return filterType.lowercased().contains("blur");
    };
    
    guard let match = match else {
      #if DEBUG
      print(
        "GaussianBlurFilterWrapper.init",
        "- no matching filters found"
      );
      #endif
      return nil;
    };
    
    self.objectWrapper = .init(
      objectToWrap: match as AnyObject,
      shouldRetainObject: shouldRetainObject
    );
  };
};

