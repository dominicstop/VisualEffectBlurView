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
  
   var backgroundHostWrapper: VisualEffectBackgroundHostViewWrapper? {
    VisualEffectBackgroundHostViewWrapper(
      fromVisualEffectView: self,
      shouldRetainObject: false
    );
  };
  
  var effectDescriptorForCurrentEffectWrapper: VisualEffectDescriptorWrapper? {
    guard let effect = self.effect else { return nil };
    return self.effectDescriptorForEffects(effects: [effect], usage: true);
  };
  
  // MARK: Computed Properties
  // -------------------------
  
  private var _blurRadius: CGFloat?;
  public var blurRadius: CGFloat {
    set {
      self._blurRadius = newValue;
      
      guard let backgroundHostWrapper = self.backgroundHostWrapper,
            let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
            let backdropLayerWrapper = contentViewWrapper.backdropLayerWrapper,
            let gaussianBlurFilterWrapper = backdropLayerWrapper.gaussianBlurFilterWrapper
      else { return };
      
      gaussianBlurFilterWrapper.inputRadius = newValue;
      self.setBlurRadius(newValue);
    }
    get {
    
      guard let backgroundHostWrapper = self.backgroundHostWrapper,
            let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
            let backdropLayerWrapper = contentViewWrapper.backdropLayerWrapper,
            let gaussianBlurFilterWrapper = backdropLayerWrapper.gaussianBlurFilterWrapper,
            let inputRadius = gaussianBlurFilterWrapper.inputRadius
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
  
  func effectDescriptorForEffects(
    effects: [UIVisualEffect],
    usage: Bool
  ) -> VisualEffectDescriptorWrapper? {
  
    let selectorResult = VisualEffectBlurHelpers.performSelector(
      forObject: self,
      selector: NSSelectorFromString("_effectDescriptorForEffects:usage:"),
      withArg1: effects,
      withArg2: usage ? 1 : 0
    );
    
    guard let selectorResult = selectorResult else { return nil };
    
    return VisualEffectDescriptorWrapper(
      sourceObject: selectorResult,
      shouldRetainObject: false
    );
  };
  
  func setBlurRadius(_ blurRadius: CGFloat){
    guard let effectDescriptorWrapper = self.effectDescriptorForCurrentEffectWrapper
    else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- failed to get: effectDescriptorForCurrentEffect"
      );
      #endif
      return;
    };
    
    guard let filterEntriesWrapped = effectDescriptorWrapper.filterEntriesWrapped,
          filterEntriesWrapped.count > 0
    else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- selector failed to get value for: filterEntries"
      );
      #endif
      return;
    };

    let filterEntryMatchWrapped = filterEntriesWrapped.enumerated().first {
      guard let filterType = $0.element.filterType else {
        #if DEBUG
        print(
          "BlurView.setBlurRadius",
          "- unable to get: filterType",
          "- at index: \($0.offset)"
        );
        #endif
        return false;
      };
    
      return filterType.lowercased().contains("blur");
    };

    guard let gaussianBlurFilterEntryWrapped = filterEntryMatchWrapped?.element else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- unable to get matching filter from: filterEntries"
      );
      #endif
      return;
    };
    
    guard let requestedValues = gaussianBlurFilterEntryWrapped.requestedValues,
          requestedValues.count > 0,
          
          let requestedValuesCopy =
            requestedValues.mutableCopy() as? NSMutableDictionary
    else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- failed to get requestedValues"
      );
      #endif
      return;
    };
    
    requestedValuesCopy["inputRadius"] = NSNumber(value: blurRadius);
    
    guard let backgroundHostWrapper = self.backgroundHostWrapper,
          let contentViewWrapper = backgroundHostWrapper.contentViewWrapper
    else {
      #if DEBUG
      print(
        "BlurView.setBlurRadius",
        "- unable to get backgroundHostWrapper and/or contentViewWrapper"
      );
      #endif
      return;
    };
    
    gaussianBlurFilterEntryWrapped.setRequestedValues(requestedValuesCopy);
    backgroundHostWrapper.setCurrentEffectDescriptor(effectDescriptorWrapper);
    contentViewWrapper.applyRequestedFilterEffects();
  };
};

