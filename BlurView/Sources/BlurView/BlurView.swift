//
//  BlurView.swift
//
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit


public class BlurView: UIVisualEffectView {

  // MARK: - Properties
  // ------------------

  private var initialBlurRadius: CGFloat?;
  public var blurEffectStyle: UIBlurEffect.Style;
  
  // MARK: - Properties - Private API
  // --------------------------------
  
  // _UIVisualEffectHost
  private weak var _visualEffectBackgroundHostView: AnyObject?;
  var visualEffectBackgroundHostView: AnyObject? {
    if let _visualEffectHostView = self._visualEffectBackgroundHostView {
      return _visualEffectHostView;
    };
  
    let swizzlingString: BlurViewSwizzlingString = .backgroundHost;
    guard let decodedString = swizzlingString.decodedString else {
      #if DEBUG
      print(
        "BlurView.visualEffectHostView - get",
        "- failed to decode string for: \(swizzlingString)"
      );
      #endif
      return nil;
    };
    
    let selectorResult = Helpers.performSelector(
      forObject: self,
      selector: NSSelectorFromString(decodedString)
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "BlurView.visualEffectHostView - get",
        "- selector failed to get value from: \(decodedString)"
      );
      #endif
      return nil;
    };
    
    self._visualEffectBackgroundHostView = selectorResult;
    return selectorResult;
  };
  
  // _UIVisualEffectBackdropView
  private var _visualEffectBackdropView: UIView?;
  var visualEffectBackdropView: UIView? {
    if let _visualEffectBackdropView = self._visualEffectBackdropView {
      return _visualEffectBackdropView;
    };
  
    let swizzlingString: BlurViewSwizzlingString = .contentView;
    guard let decodedString = swizzlingString.decodedString else {
      #if DEBUG
      print(
        "BlurView.visualEffectBackdropView - get",
        "- failed to decode string for: \(swizzlingString)"
      );
      #endif
      return nil;
    };
    
    guard let visualEffectHostView = self.visualEffectBackgroundHostView
    else { return nil };
    
    let selectorResult = Helpers.performSelector(
      forObject: visualEffectHostView,
      selector: NSSelectorFromString(decodedString),
      type: UIView.self
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "BlurView.visualEffectBackdropView - get",
        "- selector failed to get value from: \(decodedString)"
      );
      #endif
      return nil;
    };
    
    self._visualEffectBackdropView = selectorResult;
    return selectorResult;
  };
  
  // UICABackdropLayer
  private weak var _visualEffectBackdropLayer: CALayer?;
  var visualEffectBackdropLayer: CALayer? {
    if let _visualEffectBackdropLayer = self._visualEffectBackdropLayer {
      return _visualEffectBackdropLayer;
    };
  
    let swizzlingString: BlurViewSwizzlingString = .backdropLayer;
    guard let decodedString = swizzlingString.decodedString else {
      #if DEBUG
      print(
        "BlurView.visualEffectBackdropLayer - get",
        "- failed to decode string for: \(swizzlingString)"
      );
      #endif
      return nil;
    };
    
    guard let visualEffectBackdropView = self.visualEffectBackdropView
    else { return nil };
    
    let selectorResult = Helpers.performSelector(
      forObject: visualEffectBackdropView,
      selector: NSSelectorFromString(decodedString),
      type: CALayer.self
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "BlurView.visualEffectBackdropLayer - get",
        "- selector failed to get value"
      );
      #endif
      return nil;
    };
    
    self._visualEffectBackdropLayer = selectorResult;
    return selectorResult;
  };
  
  private weak var _gaussianBlurFilter: AnyObject?;
  var gaussianBlurFilter: AnyObject? {
    if let _gaussianBlurFilter = self._gaussianBlurFilter {
      return _gaussianBlurFilter;
    };
  
    guard let visualEffectBackdropLayer = self.visualEffectBackdropLayer,
          let filtersRaw = visualEffectBackdropLayer.filters,
          filtersRaw.count > 0
    else {
      #if DEBUG
      print(
        "BlurView.gaussianBlurFilter - get",
        "- could not get visualEffectBackdropLayer filters"
      );
      #endif
      return nil;
    };
    
    let filters = filtersRaw.map {
      $0 as AnyObject
    };
    
    let match = filters.first {
      let filterType = Helpers.performSelector(
        forObject: $0,
        selector:  NSSelectorFromString("type"),
        type: String.self
      );
      
      guard let filterType = filterType else {
        #if DEBUG
        print(
          "BlurView.gaussianBlurFilter - get",
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
        "BlurView.gaussianBlurFilter - get",
        "- no matching filters found"
      );
      #endif
      return nil;
    };
    
    self._gaussianBlurFilter = match;
    return match;
  };
  
  /// `_UIVisualEffectDescriptor`
  /// * `disableInPlaceFiltering`
  /// * `filters: [_UIVisualEffectFilterEntry]`
  /// * `overlays: [_UIOverlayEffectViewEntry]`
  ///
  var effectDescriptorForCurrentEffect: AnyObject? {
    let swizzlingString: BlurViewSwizzlingString = .effectDescriptorForEffectsUsage;
    guard let decodedString = swizzlingString.decodedString else {
      #if DEBUG
      print(
        "BlurView.effectDescriptorForCurrentEffect - get",
        "- failed to decode string for: \(swizzlingString)"
      );
      #endif
      return nil;
    };
    
    guard let effect = self.effect else { return nil };
    
    let selectorResult = Helpers.performSelector(
      forObject: self,
      selector: NSSelectorFromString(decodedString),
      withArg1: [effect],
      withArg2: 1
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "BlurView.effectDescriptorForCurrentEffect - get",
        "- selector failed to get value from: \(decodedString)"
      );
      #endif
      return nil;
    };
    
    return selectorResult;
  };
  
  private var _blurRadius: CGFloat?;
  public var blurRadius: CGFloat {
    set {
      self._blurRadius = newValue;
      
      guard let gaussianBlurFilter = self.gaussianBlurFilter
      else { return };
      
      gaussianBlurFilter.setValue(newValue, forKey: "inputRadius");
    }
    get {
      guard let gaussianBlurFilter = self.gaussianBlurFilter,
            let inputRadiusRaw = gaussianBlurFilter.value(forKey: "inputRadius"),
            let inputRadius = inputRadiusRaw as? CGFloat
      else {
        #if DEBUG
        print(
          "BlurView.blurRadius - get",
          "- failed to get inputRadius"
        );
        #endif
        return self._blurRadius ?? self.defaultBlurRadius;
      };
      
      self._blurRadius = inputRadius;
      return inputRadius;
    }
  };

  // MARK: - Computed Properties
  // ---------------------------
  
  public var defaultBlurRadius: CGFloat {
    if let defaultBlurRadius = self.blurEffectStyle.defaultBlurRadius {
      return defaultBlurRadius;
    };
    
    if let initialBlurRadius = self.initialBlurRadius {
      return initialBlurRadius;
    };
    
    return 30;
  };
  
  public var blurIntensity: CGFloat {
    set {
      let defaultBlurRadius = self.defaultBlurRadius;
      
      let nextBlurRadius = defaultBlurRadius * newValue;
      let clampedBlurRadius = max(min(0, nextBlurRadius), 1);
      
      self.blurRadius = clampedBlurRadius;
    }
    get {
      let defaultBlurRadius = self.defaultBlurRadius;
      let currentBlurRadius = self.blurRadius;
      
      let intensity = currentBlurRadius / defaultBlurRadius;
      let intensityClamped = max(min(0, intensity), 1);
      
      return intensityClamped;
    }
  };
  
  public init(blurEffectStyle: UIBlurEffect.Style) {
    self.blurEffectStyle = blurEffectStyle;
    let blurEffect = UIBlurEffect(style: blurEffectStyle);
    
    super.init(effect: blurEffect);
    self.initialBlurRadius = self.blurRadius;
  };
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  };
};

