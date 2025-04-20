//
//  TintConfig.swift
//  
//
//  Created by Dominic Go on 12/23/24.
//

import UIKit
import DGSwiftUtilities


public struct TintConfig: Equatable {

  public static let noTint: Self = .init(
    tintColor: .clear,
    opacity: 0,
    blendMode: nil
  );
  
  public var tintColor: UIColor;
  public var opacity: CGFloat;
  public var blendMode: BlendMode?;
  
  public init(
    tintColor: UIColor,
    opacity: CGFloat,
    blendMode: BlendMode? = nil
  ) {
    self.tintColor = tintColor
    self.opacity = opacity
    self.blendMode = blendMode
  };
  
  public func apply(toLayerWrapper layerWrapped: LayerWrapper) throws {
    guard let layer = layerWrapped.wrappedObject else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get layer"
      );
    };
    
    layer.backgroundColor = self.tintColor.cgColor;
    layer.opacity = .init(self.opacity);
    
    try layerWrapped.setBlendModeForCompFilter(with: blendMode);
  };
  
  public func apply(toLayer layer: CALayer) throws {
    guard let layerWrapped = layer.asLayerWrapper,
          layerWrapped.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get wrapper for layer"
      );
    };
    
    try self.apply(toLayerWrapper: layerWrapped);
  };
};

// MARK: - TintConfig+BaseKeyframeConfig
// -------------------------------------

@available(iOS 13, *)
extension TintConfig: KeyframeAppliable {
  
  public func apply(toTarget target: KeyframeTarget) throws {
    guard let tintViewWrapped = target.wrapper?.tintViewWrapped,
          tintViewWrapped.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `tintViewWrapped`"
      );
    };
    
    guard let tintLayerWrapped = tintViewWrapped.layerWrapped,
          tintLayerWrapped.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `tintView` layer wrapper"
      );
    };
    
    try tintViewWrapped.setEffectsForView([]);
    try self.apply(toLayerWrapper: tintLayerWrapped);
  };
};

// MARK: - TintConfig+KeyframeConfigAnimating
// ------------------------------------------

@available(iOS 13, *)
extension TintConfig: KeyframeAnimating {

  public typealias KeyframeTarget = VisualEffectAnimatableCustomFilterView;
  
  public func createAnimations(
    forTarget keyframeTarget: KeyframeTarget,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
  
    guard let tintViewWrapped = keyframeTarget.wrapper?.tintViewWrapped,
          tintViewWrapped.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `tintViewWrapped`"
      );
    };
    
    guard let tintLayerWrapped = tintViewWrapped.layerWrapped,
          let tintLayer = tintLayerWrapped.wrappedObject
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `tintView` layer wrapper"
      );
    };
    
    let keyframeConfigPrev =
      keyframeConfigPrev ?? keyframeTarget.currentTintConfig;
      
    try tintViewWrapped.setEffectsForView([]);
    
    let prevCompositingFilterName: String? = {
      if let rawCompFilter = try? tintLayerWrapped.getValueForCompFilter(),
         let compFilterName = rawCompFilter as? String
      {
        return compFilterName;
      };

      if let tintConfigPrev = keyframeConfigPrev {
        return tintConfigPrev.blendMode?.asCompositingFilterName;
      };
      
      return nil;
    }();
    
    let didCompFilterChange =
      prevCompositingFilterName != self.blendMode?.asCompositingFilterName;
      
    let shouldCrossfade =
      didCompFilterChange && propertyAnimator != nil;
    
    let shouldImmediatelyApplyCompFilter: Bool =
      didCompFilterChange && propertyAnimator == nil;
    
    let inlinedDisplayLink = InLineDisplayLink(
      shouldImmediatelyStart: false,
      delegates: []
    );
    
    if #available(iOS 15.0, *) {
      inlinedDisplayLink.displayLink.preferredFrameRateRange = .init(minimum: 30, maximum: 60);
    };
    
    /// ```
    /// 0              0.5            1
    /// +----------+--------+---------+
    /// | fade out | hidden | fade in |
    /// +----------+--------+---------+
    ///            │    │   │
    ///            │    │   └─ relativeCrossFadeInStartTime
    ///            │    └───── relativeCrossFadeHiddenDuration
    ///            └────────── relativeCrossFadeDuration
    /// ```
    ///
    let relativeCrossFadeHiddenDuration = 0.15;
    let relativeCrossFadeDuration = 1/2 - relativeCrossFadeHiddenDuration / 2;
    let relativeCrossFadeInStartTime = relativeCrossFadeDuration + relativeCrossFadeHiddenDuration;
    
    // adds to 1
    // let relativeCrossFadeEndTime = relativeCrossFadeInStartTime + relativeCrossFadeDuration;
    
    return (
      setup: {
        keyframeTarget.isBeingAnimated = true;
        
        guard didCompFilterChange,
              let propertyAnimator = propertyAnimator
        else {
          return;
        };
        
        inlinedDisplayLink.startIfNeeded();
        
        var currentCompositingFilterName = prevCompositingFilterName;
        let nextCompositingFilterName = self.blendMode?.asCompositingFilterName;
        
        inlinedDisplayLink.updateBlock = { _ in
          guard keyframeTarget.window != nil else {
            return;
          };
        
          let shouldApplyNextFrame = propertyAnimator.isReversed
            ? propertyAnimator.fractionComplete <= relativeCrossFadeDuration
            : propertyAnimator.fractionComplete >= relativeCrossFadeDuration;
        
          if shouldApplyNextFrame,
             currentCompositingFilterName != nextCompositingFilterName,
             (tintLayer.presentation()?.opacity ?? 0) == 0
          {
            try? tintLayerWrapped.setValueForCompFilter(nextCompositingFilterName);
            currentCompositingFilterName = nextCompositingFilterName;
            
          } else if !shouldApplyNextFrame,
                    currentCompositingFilterName != prevCompositingFilterName,
                    (tintLayer.presentation()?.opacity ?? 0) == 0
          {
            try? tintLayerWrapped.setValueForCompFilter(prevCompositingFilterName);
            currentCompositingFilterName = prevCompositingFilterName;
          };
        };
      },
      applyKeyframe: {
        if shouldCrossfade {
          UIView.animateKeyframes(
            withDuration: UIView.inheritedAnimationDuration,
            delay: 0
          ) {
            UIView.addKeyframe(
              withRelativeStartTime: 0,
              relativeDuration: relativeCrossFadeDuration
            ) {
              tintLayer.opacity = 0;
              tintLayer.backgroundColor = self.tintColor.cgColor;
            };
            UIView.addKeyframe(
              withRelativeStartTime: relativeCrossFadeInStartTime,
              relativeDuration: relativeCrossFadeDuration
            ) {
              tintLayer.opacity = .init(self.opacity);
            };
          };
          
        } else {
          tintLayer.opacity = .init(self.opacity);
          tintLayer.backgroundColor = self.tintColor.cgColor;
        };
      },
      completion: { didCancel in
        keyframeTarget.isBeingAnimated = false;
        inlinedDisplayLink.stop();
        
        let keyframeConfigCurrent = didCancel
          ? keyframeConfigPrev
          : self;
          
        keyframeTarget.currentTintConfig = keyframeConfigCurrent;
      
        if shouldImmediatelyApplyCompFilter,
           let currentBlendMode = keyframeConfigCurrent?.blendMode?.asCompositingFilterName,
           keyframeTarget.window != nil
        {
          try? tintLayerWrapped.setValueForCompFilter(currentBlendMode)
        };
      }
    );
  };
};
