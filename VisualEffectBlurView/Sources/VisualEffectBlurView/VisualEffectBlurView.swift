//
//  VisualEffectBlurView.swift
//
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit


public class VisualEffectBlurView: UIVisualEffectView {

  // MARK: - Properties
  // ------------------

  private var initialBlurRadius: CGFloat?;
  
  public var blurEffectStyle: UIBlurEffect.Style? {
    willSet {
      guard let newValue = newValue else {
        self.effect = nil;
        self.initialBlurRadius = nil;
        return;
      };
      
      self.effect = UIBlurEffect(style: newValue);
      self.initialBlurRadius = self.blurRadius;
    }
  };
  
  // MARK: - Properties - Private API
  // --------------------------------
  
  // _UIVisualEffectHost
  private weak var _visualEffectBackgroundHostView: AnyObject?;
  var visualEffectBackgroundHostView: AnyObject? {
    if let _visualEffectHostView = self._visualEffectBackgroundHostView {
      return _visualEffectHostView;
    };

    let selectorResult = VisualEffectBlurHelpers.performSelector(
      forObject: self,
      selector: NSSelectorFromString("_backgroundHost")
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "BlurView.visualEffectHostView - get",
        "- selector failed to get value"
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
    
    guard let visualEffectHostView = self.visualEffectBackgroundHostView
    else { return nil };
    
    let selectorResult = VisualEffectBlurHelpers.performSelector(
      forObject: visualEffectHostView,
      selector: NSSelectorFromString("contentView"),
      type: UIView.self
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "BlurView.visualEffectBackdropView - get",
        "- selector failed to get value"
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
    
    guard let visualEffectBackdropView = self.visualEffectBackdropView
    else { return nil };
    
    let selectorResult = VisualEffectBlurHelpers.performSelector(
      forObject: visualEffectBackdropView,
      selector: NSSelectorFromString("backdropLayer"),
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
      let filterType = VisualEffectBlurHelpers.performSelector(
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
    guard let effect = self.effect else { return nil };
    
    let selectorResult = VisualEffectBlurHelpers.performSelector(
      forObject: self,
      selector: NSSelectorFromString("_effectDescriptorForEffects:usage:"),
      withArg1: [effect],
      withArg2: 1
    );
    
    guard let selectorResult = selectorResult else {
      #if DEBUG
      print(
        "BlurView.effectDescriptorForCurrentEffect - get",
        "- selector failed to get value"
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
      self.setBlurRadius(newValue);
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
    if let defaultBlurRadius = self.blurEffectStyle?.defaultBlurRadius {
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
      self.blurRadius = defaultBlurRadius * newValue;
    }
    get {
      let defaultBlurRadius = self.defaultBlurRadius;
      let currentBlurRadius = self.blurRadius;
      
      return currentBlurRadius / defaultBlurRadius;
    }
  };
  
  // MARK: - Init
  // ------------
  
  public init(blurEffectStyle: UIBlurEffect.Style?) {
    let blurEffect: UIVisualEffect? = {
      guard let blurEffectStyle = blurEffectStyle else { return nil };
      return UIBlurEffect(style: blurEffectStyle);
    }();
    
    super.init(effect: blurEffect);
    self.blurEffectStyle = blurEffectStyle;
  };
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  };
  
  // MARK: - Functions
  // -----------------
  
  func setBlurRadius(_ blurRadius: CGFloat){
    guard let effectDescriptor = self.effectDescriptorForCurrentEffect
    else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- failed to get: effectDescriptorForCurrentEffect"
      );
      #endif
      return;
    };
    
    // NSArray<_UIVisualEffectFilterEntry *>
    let filterEntries = VisualEffectBlurHelpers.performSelector(
      forObject: effectDescriptor,
      selector: NSSelectorFromString("filterEntries"),
      type: NSArray.self
    );
    
    guard let filterEntries = filterEntries,
          filterEntries.count > 0,
          let filterEntriesCopy = filterEntries.mutableCopy() as? NSMutableArray
    else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- selector failed to get value for: filterEntries"
      );
      #endif
      return;
    };
    
    /// `_UIVisualEffectFilterEntry`
    /// * `filter: String`
    /// * `parameters: NSDictionary`
    let filterEntryMatch = filterEntries.enumerated().first {
      let filterType = VisualEffectBlurHelpers.performSelector(
        forObject: $0.element as AnyObject,
        selector:  NSSelectorFromString("filterType"),
        type: String.self
      );
      
      guard let filterType = filterType else {
        #if DEBUG
        print(
          "BlurView.setBlurRadius",
          "- selector failed for: \($0.element)",
          "- unable to get: filterType",
          "- at index: \($0.offset)"
        );
        #endif
        return false;
      };
      
      return filterType.lowercased().contains("blur");
    };

    guard let filterEntryMatch = filterEntryMatch else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- unable to get matching filter from: filterEntries"
      );
      #endif
      return;
    };
    
    let (gaussianBlurFilterEntryIndex, gaussianBlurFilterEntry) = filterEntryMatch;
    
    let requestedValues = VisualEffectBlurHelpers.performSelector(
      forObject: gaussianBlurFilterEntry as AnyObject,
      selector: NSSelectorFromString("requestedValues"),
      type: NSDictionary.self
    );
    
    guard let requestedValues = requestedValues,
          requestedValues.count > 0,
          
          let requestedValuesCopy =
            requestedValues.mutableCopy() as? NSMutableDictionary
    else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- selector failed to get value for: requestedValues"
      );
      #endif
      return;
    };
    
    requestedValuesCopy["inputRadius"] = NSNumber(value: blurRadius);
    
    guard let backgroundHostView = self.visualEffectBackgroundHostView,
          let backdropView = self.visualEffectBackdropView
    else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- unable to get backgroundHostView and/or backdropView"
      );
      #endif
      return;
    };
    
    VisualEffectBlurHelpers.performSelector(
      forObject: gaussianBlurFilterEntry as AnyObject,
      selector: NSSelectorFromString("setRequestedValues:"),
      withArg1: requestedValuesCopy as NSDictionary
    );
    
    filterEntriesCopy[gaussianBlurFilterEntryIndex] = gaussianBlurFilterEntry;
    
    VisualEffectBlurHelpers.performSelector(
      forObject: backgroundHostView,
      selector: NSSelectorFromString("setCurrentEffectDescriptor:"),
      withArg1: effectDescriptor
    );
    
    VisualEffectBlurHelpers.performSelector(
      forObject: backdropView,
      selector: NSSelectorFromString("applyRequestedFilterEffects")
    );
  };
};

