//
//  CustomFilterKeyframeConfig.swift
//  
//
//  Created by Dominic Go on 12/28/24.
//

import UIKit
import DGSwiftUtilities


public struct CustomFilterKeyframeConfig: KeyframeAppliable {

  @available(iOS 13, *)
  public typealias KeyframeTarget = VisualEffectAnimatableCustomFilterView;
  
  // MARK: - Base View Keyframes
  // ---------------------------
  
  public var rootKeyframe: GenericViewKeyframe<UIView>?;
  public var contentKeyframe: BasicViewKeyframe<UIView>?;
  public var backdropKeyframe: BasicViewKeyframe<UIView>?;
  
  // MARK: - Filter Keyframes
  // ------------------------
  
  public var backgroundFilters: [LayerFilterConfig]?;
  public var foregroundFilters: [LayerFilterConfig]?;
  
  public var tintConfig: TintConfig?;
  
  // MARK: - Init
  // ------------
  
  public init(
    rootKeyframe: GenericViewKeyframe<UIView>? = nil,
    contentKeyframe: BasicViewKeyframe<UIView>? = nil,
    backdropKeyframe: BasicViewKeyframe<UIView>? = nil,
    backgroundFilters: [LayerFilterConfig]? = nil,
    foregroundFilters: [LayerFilterConfig]? = nil,
    tintConfig: TintConfig? = nil
  ) {
    self.rootKeyframe = rootKeyframe;
    self.contentKeyframe = contentKeyframe;
    self.backdropKeyframe = backdropKeyframe;

    self.backgroundFilters = backgroundFilters;
    self.foregroundFilters = foregroundFilters;
    self.tintConfig = tintConfig;
  };
};

// MARK: - CustomFilterKeyframeConfig+KeyframeConfigAnimating
// ----------------------------------------------------------

@available(iOS 13, *)
extension CustomFilterKeyframeConfig: KeyframeAnimating {

  public func applyBaseKeyframe(toView targetView: KeyframeTarget) {
    if let rootKeyframe = self.rootKeyframe {
      try? rootKeyframe.apply(toTarget: targetView);
    };
    
    if let backdropKeyframe = self.backdropKeyframe,
       let backgroundViewWrapped = targetView.hostForBackgroundContentViewWrapped,
       let backgroundView = backgroundViewWrapped.wrappedObject
    {
      try? backdropKeyframe.apply(toTarget: backgroundView);
    };
    
    if let contentKeyframe = self.contentKeyframe {
      try? contentKeyframe.apply(toTarget: targetView.contentView);
    };
  };
  
  public func apply(toTarget target: KeyframeTarget) throws {
    self.applyBaseKeyframe(toView: target);
    
    if let tintConfig = self.tintConfig {
      try target.directlySetTint(forConfig: tintConfig);
    };
    
    var shouldApplyFilters = false;
    
    if let backgroundFilters = backgroundFilters,
           backgroundFilters.count > 0
    {
      shouldApplyFilters = true;
      try target.updateBackgroundFiltersViaEffectDesc(
        withFilterConfigItems: backgroundFilters
      );
    };
    
    if let foregroundFilters = self.foregroundFilters,
       foregroundFilters.count > 0
    {
      shouldApplyFilters = true;
      try target.updateForegroundFiltersViaEffectDesc(
        withFilterConfigItems: foregroundFilters
      );
    };
    
    if shouldApplyFilters {
      try target.applyRequestedFilterEffects();
    };
  };
  
  public func createAnimations(
    forTarget keyframeTarget: KeyframeTarget,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
  
    let tintAnimationBlock = try? self.tintConfig?.createAnimations(
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
        
        if let backgroundFilters = backgroundFilters,
           backgroundFilters.count > 0
        {
          try keyframeTarget.updateBackgroundFiltersViaEffectDesc(
            withFilterConfigItems: backgroundFilters
          );
        };
        
        if let foregroundFilters = self.foregroundFilters,
           foregroundFilters.count > 0
        {
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
};
