//
//  VisualEffectBackdropViewWrapper.swift
//  
//
//  Created by Dominic Go on 9/17/23.
//

import UIKit

// Wrapper for: _UIVisualEffectBackdropView
class VisualEffectBackdropViewWrapper: ObjectWrapping {
  var objectWrapper: ObjectWrapper<UIView>;
  
  var backdropLayerWrapper: BackdropLayerWrapper? {
    .init(fromVisualEffectBackdropView: self.wrappedObject);
  };
  
  init?(
    fromVisualEffectBackgroundHostView sourceObject: AnyObject?,
    shouldRetainObject: Bool = false
  ){
    
    guard let sourceObject = sourceObject else { return nil };
    
    let selectorResult = VisualEffectBlurHelpers.performSelector(
      forObject: sourceObject,
      selector: NSSelectorFromString("contentView"),
      type: UIView.self
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "VisualEffectBackdropViewWrapper.init",
        "- selector failed to get value from: \("contentView")"
      );
      #endif
      return nil;
    };
  
    self.objectWrapper = .init(
      objectToWrap: selectorResult,
      shouldRetainObject: shouldRetainObject
    );
  };
  
  func applyRequestedFilterEffects(){
    guard let wrappedObject = self.wrappedObject else {
      #if DEBUG
      print(
        "VisualEffectBackdropViewWrapper.applyRequestedFilterEffects",
        "- failed to get wrappedObject"
      );
      #endif
      return;
    };
  
    VisualEffectBlurHelpers.performSelector(
      forObject: wrappedObject,
      selector: NSSelectorFromString("applyRequestedFilterEffects")
    );
  };
};
