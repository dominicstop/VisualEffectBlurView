//
//  BlurView.swift
//
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit


public class BlurView: UIVisualEffectView {
  
  // _UIVisualEffectHost
  weak var _visualEffectHostView: AnyObject?;
  var visualEffectHostView: AnyObject? {
    if let _visualEffectHostView = self._visualEffectHostView {
      return _visualEffectHostView;
    };
  
    let swizzlingString: BlurViewSwizzlingString = .backgroundHost;
    guard let decodedString = swizzlingString.decodedString else { return nil };
    
    let selectorResult = Helpers.performSelector(
      forObject: self,
      selector: NSSelectorFromString(decodedString)
    );
    
    self._visualEffectHostView = selectorResult;
    return selectorResult;
  };
  
  // _UIVisualEffectBackdropView
  var _visualEffectBackdropView: UIView?;
  var visualEffectBackdropView: UIView? {
    if let _visualEffectBackdropView = self._visualEffectBackdropView {
      return _visualEffectBackdropView;
    };
  
    let swizzlingString: BlurViewSwizzlingString = .contentView;
    guard let decodedString = swizzlingString.decodedString,
          let visualEffectHostView = self.visualEffectHostView
    else { return nil };
    
    let selectorResult = Helpers.performSelector(
      forObject: visualEffectHostView,
      selector: NSSelectorFromString(decodedString),
      type: UIView.self
    );
    
    self._visualEffectBackdropView = selectorResult;
    return selectorResult;
  };
  
  // UICABackdropLayer
  weak var _visualEffectBackdropLayer: CALayer?;
  var visualEffectBackdropLayer: CALayer? {
    if let _visualEffectBackdropLayer = self._visualEffectBackdropLayer {
      return _visualEffectBackdropLayer;
    };
  
    let swizzlingString: BlurViewSwizzlingString = .backdropLayer;
    guard let decodedString = swizzlingString.decodedString,
          let visualEffectBackdropView = self.visualEffectBackdropView
    else { return nil };
    
    let selectorResult = Helpers.performSelector(
      forObject: visualEffectBackdropView,
      selector: NSSelectorFromString(decodedString),
      type: CALayer.self
    );
    
    self._visualEffectBackdropLayer = selectorResult;
    return selectorResult;
  };
  
  weak var _gaussianBlurFilter: AnyObject?;
  var gaussianBlurFilter: AnyObject? {
    if let _gaussianBlurFilter = self._gaussianBlurFilter {
      return _gaussianBlurFilter;
    };
  
    guard let visualEffectBackdropLayer = self.visualEffectBackdropLayer,
          let filtersRaw = visualEffectBackdropLayer.filters
    else { return nil };
    
    let filters = filtersRaw.map {
      $0 as AnyObject
    };
    
    let match = filters.first {
      let filterType = Helpers.performSelector(
        forObject: $0,
        selector:  NSSelectorFromString("type"),
        type: String.self
      );
      
      return filterType == "gaussianBlur";
    };
    
    self._gaussianBlurFilter = match;
    return match;
  };
  
  public var blurRadius: CGFloat? {
    get {
      guard let gaussianBlurFilter = self.gaussianBlurFilter,
            let inputRadiusRaw = gaussianBlurFilter.value(forKey: "inputRadius"),
            let inputRadius = inputRadiusRaw as? CGFloat
      else { return nil };
      
      return inputRadius;
    }
    
    set {
      guard let gaussianBlurFilter = self.gaussianBlurFilter
      else { return };
      
      gaussianBlurFilter.setValue(newValue, forKey: "inputRadius");
    }
  };
  
  public init(blurEffect: UIBlurEffect) {
    super.init(effect: blurEffect);
    print("inital blurRadius:", self.blurRadius);
  };
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  };
};

