//
//  BaseCustomFilterConcreteKeyframe.swift
//  VisualEffectBlurView
//
//  Created by Dominic Go on 4/17/25.
//

import UIKit
import DGSwiftUtilities


@available(iOS 13, *)
public protocol BaseCustomFilterConcreteKeyframe:
  BaseCustomViewConcreteKeyframe,
  BaseConcreteKeyframe where
    KeyframeTarget: VisualEffectAnimatableCustomFilterView,
    PartialKeyframe: BaseCustomFilterPartialKeyframe
{
  var backgroundFilters: [LayerFilterConfig] { get set };
  var foregroundFilters: [LayerFilterConfig] { get set };
  var tintConfig: TintConfig { get set };
};

// MARK: - BaseCustomFilterConcreteKeyframe+BaseCustomViewConcreteKeyframe (Default Conformance)
// --------------------------------------------------

@available(iOS 13, *)
public extension BaseCustomFilterConcreteKeyframe {

  func applyBaseViewCustomKeyframe(
    toTarget keyframeTarget: KeyframeTarget
  ) throws {
    
    try self.applyBaseCustomFilterKeyframe(toTarget: keyframeTarget);
  };
  
  func createBaseViewCustomAnimations(
    forTarget keyframeTarget: KeyframeTarget,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
    
    try self.createBaseCustomFilterKeyframeAnimations(
      forTarget: keyframeTarget,
      withPrevKeyframe: keyframeConfigPrev,
      forPropertyAnimator: propertyAnimator
    );
  };
};

// MARK: - BaseCustomFilterConcreteKeyframe+Helpers
// --------------------------------------

@available(iOS 13, *)
public extension BaseCustomFilterConcreteKeyframe {
  
  static var baseCustomFilterPartialToConcreteKeyframePropertyMap: KeyframePropertyMap {
    return [
      .init(keyPath: \.backgroundFilters): .init(keyPath: \.backgroundFilters),
      .init(keyPath: \.foregroundFilters): .init(keyPath: \.foregroundFilters),
      .init(keyPath: \.tintConfig): .init(keyPath: \.tintConfig),
    ];
  };
  
  static func extractBaseCustomFilterPartialToConcreteKeyframePropertyMap<T: BaseConcreteKeyframe>(
    forType concreteKeyframeType: T.Type = T.self
  ) -> T.KeyframePropertyMap {
    
    var map: T.KeyframePropertyMap = [:];

    for (key, value) in Self.baseCustomFilterPartialToConcreteKeyframePropertyMap {
      let partialKeyframeKeyPath = key as? T.KeyframePropertyMap.Key;
      let concreteKeyframeKeyPath = value as? T.KeyframePropertyMap.Value;
      
      map[partialKeyframeKeyPath!] = concreteKeyframeKeyPath!;
    };
    
    return map;
  };

  func applyBaseCustomFilterKeyframe(toTarget target: KeyframeTarget) throws {    
    if self.tintConfig == .noTint {
      try target.directlySetTint(forConfig: tintConfig);
    };
    
    var shouldApplyFilters = false;
    
    if self.backgroundFilters.count > 0 {
      shouldApplyFilters = true;
      try target.updateBackgroundFiltersViaEffectDesc(
        withFilterConfigItems: backgroundFilters
      );
    };
    
    if foregroundFilters.count > 0 {
      shouldApplyFilters = true;
      try target.updateForegroundFiltersViaEffectDesc(
        withFilterConfigItems: foregroundFilters
      );
    };
    
    if shouldApplyFilters {
      try target.applyRequestedFilterEffects();
    };
  };
  
  func createBaseCustomFilterKeyframeAnimations(
    forTarget keyframeTarget: KeyframeTarget,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
  
    let tintAnimationBlock = try? self.tintConfig.createAnimations(
      forTarget: keyframeTarget,
      withPrevKeyframe: keyframeConfigPrev?.tintConfig,
      forPropertyAnimator: propertyAnimator
    );
    
    let prevBackgroundFilterTypes = keyframeTarget.currentBackgroundFilterTypes;
    let prevForegroundFilterTypes = keyframeTarget.currentForegroundFilterTypes;
    
    return (
      setup: {
        keyframeTarget.isBeingAnimated = true;
        try tintAnimationBlock?.setup();
        
        if backgroundFilters.count > 0 {
          try keyframeTarget.updateBackgroundFiltersViaEffectDesc(
            withFilterConfigItems: backgroundFilters
          );
        };
        
        if foregroundFilters.count > 0 {
          try keyframeTarget.updateForegroundFiltersViaEffectDesc(
            withFilterConfigItems: foregroundFilters
          );
        };
      },
      applyKeyframe: {
        self.applyBaseKeyframe(toView: keyframeTarget);
        tintAnimationBlock?.applyKeyframe();
        try? keyframeTarget.applyRequestedFilterEffects();
      },
      completion: { didCancel in
        keyframeTarget.isBeingAnimated = false;
        tintAnimationBlock?.completion(didCancel);
        
        if didCancel {
          keyframeTarget.currentBackgroundFilterTypes = prevBackgroundFilterTypes;
          keyframeTarget.currentForegroundFilterTypes = prevForegroundFilterTypes;
        };
      }
    );
  };
  
  // MARK: - Chain Setter Methods
  // ----------------------------
  
  func withBackgroundFilters(_ newValue: [LayerFilterConfig]) -> Self {
    var copy = self;
    copy.backgroundFilters = newValue;
    return copy;
  };
  
  func withForegroundFilters(_ newValue: [LayerFilterConfig]) -> Self {
    var copy = self;
    copy.foregroundFilters = newValue;
    return copy;
  };
  
  func withTintConfig(_ newValue: TintConfig) -> Self {
    var copy = self;
    copy.tintConfig = newValue;
    return copy;
  };
};




