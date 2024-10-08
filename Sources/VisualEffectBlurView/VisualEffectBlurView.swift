//
//  VisualEffectBlurView.swift
//
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit
import DGSwiftUtilities


public class VisualEffectBlurView: VisualEffectView {

  // MARK: - Properties
  // ------------------

  private var initialBlurRadius: CGFloat?;
  
  public var blurEffectStyle: UIBlurEffect.Style? {
    willSet {
      self.clearAnimator();
      
      guard let newValue = newValue else {
        self.effect = nil;
        self.initialBlurRadius = nil;
        return;
      };
      
      self.effect = UIBlurEffect(style: newValue);
      self.initialBlurRadius = self.blurRadius;
    }
  };
  
  // MARK: Computed Properties
  // -------------------------
  
  private var _blurRadius: CGFloat?;
  public var blurRadius: CGFloat {
    set {
      self._blurRadius = newValue;
      
      guard #available(iOS 13, *),
            let bgLayerWrapper = self.bgLayerWrapper,
            let gaussianBlurFilterWrapper = bgLayerWrapper.gaussianBlurFilterWrapper
      else {
        return;
      };
      
      gaussianBlurFilterWrapper.inputRadius = newValue;
      try? self.setBlurRadius(newValue);
    }
    get {
      guard let bgLayerWrapper = self.bgLayerWrapper,
            let gaussianBlurFilterWrapper = bgLayerWrapper.gaussianBlurFilterWrapper,
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
      
      if let animatorWrapper = self.animatorWrapper {
        return inputRadius * animatorWrapper.animator.fractionComplete;
      };
      
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
  
  public init(blurEffectStyle: UIBlurEffect.Style?) throws {
    let blurEffect: UIBlurEffect? = {
      guard let blurEffectStyle = blurEffectStyle else {
        return nil;
      };
      
      return .init(style: blurEffectStyle);
    }();
    
    self.blurEffectStyle = blurEffectStyle;
    
    try super.init(withEffect: blurEffect);
  };
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  };
  
  // MARK: - Functions
  // -----------------
  
  @available(iOS 13, *)
  public func setBlurRadius(_ blurRadius: CGFloat) throws {
    guard let effectDescriptorWrapper = self.currentEffectMetadata else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "failed to get: effectDescriptorForCurrentEffect"
      );
    };
    
    guard let filterItemsWrapped = effectDescriptorWrapper.filterItemsWrapped,
          filterItemsWrapped.count > 0
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "failed to get: effectDescriptorForCurrentEffect"
      );
    };

    let filterItemMatchWrapped = filterItemsWrapped.enumerated().first {
      guard let filterType = $0.element.filterKind else {
        return false;
      };
    
      return filterType.lowercased().contains("blur");
    };

    guard let gaussianBlurFilterEntryWrapped = filterItemMatchWrapped?.element else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "unable to get matching filter from: filterItems"
      );
    };
    
    guard let filterValuesRequested = gaussianBlurFilterEntryWrapped.filterValuesRequested,
          filterValuesRequested.count > 0,
          
          let filterValuesCurrentCopy =
            filterValuesRequested.mutableCopy() as? NSMutableDictionary
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "failed to get filterValuesCurrent"
      );
    };
    
    filterValuesCurrentCopy["inputRadius"] = NSNumber(value: blurRadius);
    
    guard let wrapper = self.wrapper,
          let backgroundHostWrapper = wrapper.hostForBgWrapped,
          let contentViewWrapper = backgroundHostWrapper.viewContentWrapped
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "failed to get filterValuesCurrent"
      );
    };
    
    try gaussianBlurFilterEntryWrapped.setFilterValuesRequested(filterValuesCurrentCopy);
    try backgroundHostWrapper.setEffectDescriptor(effectDescriptorWrapper);
    try contentViewWrapper.applyRequestedFilterEffects();
  };
};

