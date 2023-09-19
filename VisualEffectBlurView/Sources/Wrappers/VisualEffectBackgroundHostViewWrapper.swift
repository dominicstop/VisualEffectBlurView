//
//  VisualEffectBackgroundHostViewWrapper.swift
//  
//
//  Created by Dominic Go on 9/17/23.
//

import UIKit


// Wrapper for: _UIVisualEffectHost
class VisualEffectBackgroundHostViewWrapper: ObjectWrapping {
  
  var objectWrapper: ObjectWrapper<AnyObject>;

  var contentViewWrapper: VisualEffectBackdropViewWrapper? {
    .init(fromVisualEffectBackgroundHostView: self.wrappedObject);
  };
  
  init?(
    fromVisualEffectView sourceObject: UIVisualEffectView,
    shouldRetainObject: Bool = false
  ){
    let selectorResult = VisualEffectBlurHelpers.performSelector(
      forObject: sourceObject,
      selector: NSSelectorFromString("_backgroundHost")
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "VisualEffectBackgroundHostViewWrapper.init",
        "- selector failed to get value from _backgroundHost"
      );
      #endif
      return nil;
    };
    
    self.objectWrapper = .init(
      objectToWrap: selectorResult,
      shouldRetainObject: shouldRetainObject
    );
  };
  
  func setCurrentEffectDescriptor(
    _ effectDescriptorWrapper: VisualEffectDescriptorWrapper
  ) {
  
    guard let backgroundHostView = self.wrappedObject,
          let effectDescriptor = effectDescriptorWrapper.wrappedObject
    else {
      #if DEBUG
      print(
        "VisualEffectBackgroundHostViewWrapper.setCurrentEffectDescriptor",
        "- failed to get wrappedObject or effectDescriptor"
      );
      #endif
      return;
    };
    
    VisualEffectBlurHelpers.performSelector(
      forObject: backgroundHostView,
      selector: NSSelectorFromString("setCurrentEffectDescriptor:"),
      withArg1: effectDescriptor
    );
  };
};
