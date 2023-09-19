//
//  BackdropLayerWrapper.swift
//  
//
//  Created by Dominic Go on 9/17/23.
//

import UIKit

// Wrapper for: UICABackdropLayer
class BackdropLayerWrapper: ObjectWrapping {

  fileprivate enum EncodedString: String, HashedStringDecodable {
    case backdropLayer;
    
    var encodedString: String {
      switch self {
        case .backdropLayer:
          // backdropLayer
          return "YmFja2Ryb3BMYXllcg==";
      };
    };
  };

  var objectWrapper: ObjectWrapper<CALayer>;
  
  var gaussianBlurFilterWrapper: GaussianBlurFilterWrapper? {
    .init(fromBackdropLayer: self.wrappedObject);
  };

  init?(
    fromVisualEffectBackdropView sourceObject: AnyObject?,
    shouldRetainObject: Bool = false
  ){
    
    guard let sourceObject = sourceObject else { return nil };
    
    let selectorResult = VisualEffectBlurHelpers.performSelector(
      forObject: sourceObject,
      selectorFromHashedString: EncodedString.backdropLayer,
      type: CALayer.self
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "BackdropLayerWrapper.init",
        "- selector failed to get value for backdropLayer"
      );
      #endif
      return nil;
    };
    
    self.objectWrapper = .init(
      objectToWrap: selectorResult,
      shouldRetainObject: shouldRetainObject
    );
  };
};
