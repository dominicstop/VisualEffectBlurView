//
//  VisualEffectBlurView.swift
//
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit
import DGSwiftUtilities


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
  
  public lazy var wrapper: VisualEffectViewWrapper? = .init(objectToWrap: self);

  @available(iOS 13, *)
  public var effectDescriptorForCurrentEffectWrapper: VisualEffectDescriptorWrapper? {
    guard let effect = self.effect,
          let wrapper = self.wrapper
    else {
      return nil;
    };
    
    return try? wrapper.effectDescriptor(
      forEffects: [effect],
      usage: true
    );
  };
  
  // MARK: Computed Properties
  // -------------------------
  
  private var _blurRadius: CGFloat?;
  public var blurRadius: CGFloat {
    set {
      self._blurRadius = newValue;
      
      guard #available(iOS 13, *),
            let wrapper = self.wrapper,
            let backgroundHostWrapper = wrapper.backgroundHostWrapper,
            let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
            let bgLayerWrapper = contentViewWrapper.bgLayerWrapper,
            let gaussianBlurFilterWrapper = bgLayerWrapper.gaussianBlurFilterWrapper
      else {
        return;
      };
      
      gaussianBlurFilterWrapper.inputRadius = newValue;
      try? self.setBlurRadius(newValue);
    }
    get {
      guard let wrapper = self.wrapper,
            let backgroundHostWrapper = wrapper.backgroundHostWrapper,
            let contentViewWrapper = backgroundHostWrapper.contentViewWrapper,
            let bgLayerWrapper = contentViewWrapper.bgLayerWrapper,
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
  
  @available(iOS 13, *)
  func setBlurRadius(_ blurRadius: CGFloat) throws {
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
    
    guard let wrapper = self.wrapper,
          let backgroundHostWrapper = wrapper.backgroundHostWrapper,
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
    
    try gaussianBlurFilterEntryWrapped.setRequestedValues(requestedValuesCopy);
    try backgroundHostWrapper.setCurrentEffectDescriptor(effectDescriptorWrapper);
    try contentViewWrapper.applyRequestedFilterEffects();
  };
  
  // wip
  @available(iOS 13, *)
  func setFilterIntensity(
    _ nextEffectIntensity: Double,
    shouldSetBlurRadiusIntensity: Bool = false
  ) throws {
    guard let blurEffectStyle = self.blurEffectStyle,
          let effectDescriptorWrapper = self.effectDescriptorForCurrentEffectWrapper
    else {
      #if DEBUG
      print(
        "BlurView.setEffectIntensity",
        "- failed to get: effectDescriptorForCurrentEffect",
        "- for blurEffectStyle:", self.blurEffectStyle?.description ?? "N/A"
      );
      #endif
      return;
    };
    
    guard let filterEntriesWrapped = effectDescriptorWrapper.filterEntriesWrapped,
          filterEntriesWrapped.count > 0
    else {
      #if DEBUG
      print(
        "BlurView.setEffectIntensity",
        "- selector failed to get value for: filterEntries"
      );
      #endif
      return;
    };
    
    guard let wrapper = self.wrapper,
          let backgroundHostWrapper = wrapper.backgroundHostWrapper,
          let contentViewWrapper = backgroundHostWrapper.contentViewWrapper
    else {
      #if DEBUG
      print(
        "BlurView.setEffectIntensity",
        "- unable to get backgroundHostWrapper and/or contentViewWrapper"
      );
      #endif
      return;
    };
    

    for (offset, filterEntryWrapped) in filterEntriesWrapped.enumerated() {
      guard let filterType = filterEntryWrapped.filterType else {
        #if DEBUG
        print(
          "BlurView.setEffectIntensity",
          "- unable to get: filterType",
          "- at index: \(offset)"
        );
        #endif
        continue;
      };
      
      guard let requestedValues = filterEntryWrapped.requestedValues,
            requestedValues.count > 0,
            
            let requestedValuesCopy =
              requestedValues.mutableCopy() as? NSMutableDictionary
      else {
        #if DEBUG
        print(
          "BlurView.setEffectIntensity",
          "- failed to get requestedValues",
          "- at index: \(offset)"
        );
        #endif
        continue;
      };
      
      guard let identityValues = filterEntryWrapped.identityValues,
            identityValues.count > 0
      else {
        #if DEBUG
        print(
          "BlurView.setEffectIntensity",
          "- failed to get identityValues",
          "- at index: \(offset)"
        );
        #endif
        continue;
      };
      
      let defaultFilterEntry = blurEffectStyle.defaultFilterEntries.first {
        $0.filterTypeRaw == filterType;
      };
      
      guard let defaultFilterEntry = defaultFilterEntry else { return };
      
      try requestedValuesCopy.forEach {
        guard let key = $0.key as? String,
              let prevValue = $0.value as? Double
        else { return };
        
        let identityValue =
          identityValues[key] as? Double ?? 0;
        
        let defaultValue = {
          guard let match = defaultFilterEntry.requestedValues[key],
                let value = match as? NSNumber
          else {
            return prevValue;
          };
          
          return value.doubleValue;
        }();
        
        let nextValue = InterpolationHelpers.lerp(
          valueStart: identityValue,
          valueEnd: defaultValue,
          percent: nextEffectIntensity
        );
        
        requestedValuesCopy[key] = nextValue;
        
        try filterEntryWrapped.setRequestedValues(requestedValuesCopy);
        try backgroundHostWrapper.setCurrentEffectDescriptor(effectDescriptorWrapper);
        try contentViewWrapper.applyRequestedFilterEffects();
      };
    };
  };
};

