//
//  BaseVisualEffectSubviewConcreteKeyframe.swift
//  VisualEffectBlurView
//
//  Created by Dominic Go on 4/21/25.
//

import UIKit
import DGSwiftUtilities


@available(iOS 13, *)
public protocol BaseVisualEffectSubviewConcreteKeyframe:
  BaseCustomViewConcreteKeyframe,
  BaseConcreteKeyframe where
    KeyframeTarget: VisualEffectAnimatableCustomFilterView,
    PartialKeyframe: BaseVisualEffectSubviewPartialKeyframe
{
  var rootKeyframe: GenericViewConcreteKeyframe { get set };
  var contentKeyframe: GenericViewConcreteKeyframe { get set };
  var backdropKeyframe: GenericViewConcreteKeyframe { get set };
};


// MARK: - BaseVisualEffectSubviewConcreteKeyframe+Helpers
// --------------------------------------

@available(iOS 13, *)
public extension BaseVisualEffectSubviewConcreteKeyframe {
  
  static var baseVisualEffectSubviewPartialToConcreteKeyframePropertyMap: KeyframePropertyMap {
    return [
      .init(keyPath: \.rootKeyframe): .init(keyPath: \.rootKeyframe),
      .init(keyPath: \.contentKeyframe): .init(keyPath: \.contentKeyframe),
      .init(keyPath: \.backdropKeyframe): .init(keyPath: \.backdropKeyframe),
    ];
  };
  
  static func extractBaseVisualEffectSubviewPartialToConcreteKeyframePropertyMap<T: BaseConcreteKeyframe>(
    forType concreteKeyframeType: T.Type = T.self
  ) -> T.KeyframePropertyMap {
    
    var map: T.KeyframePropertyMap = [:];

    for (key, value) in Self.baseVisualEffectSubviewPartialToConcreteKeyframePropertyMap {
      let partialKeyframeKeyPath = key as? T.KeyframePropertyMap.Key;
      let concreteKeyframeKeyPath = value as? T.KeyframePropertyMap.Value;
      
      map[partialKeyframeKeyPath!] = concreteKeyframeKeyPath!;
    };
    
    return map;
  };

  func applyBaseVisualEffectSubviewKeyframe<T: VisualEffectView>(
    toTarget target: T
  ) throws {
    try? self.rootKeyframe.apply(toTarget: target);
    
    if let backgroundViewWrapped = target.hostForBackgroundContentViewWrapped,
       let backgroundView = backgroundViewWrapped.wrappedObject
    {
      try? self.backdropKeyframe.apply(toTarget: backgroundView);
    };
    
    try? self.contentKeyframe.apply(toTarget: target.contentView);
  };
  
  func createVisualEffectSubviewFilterKeyframeAnimations<T: VisualEffectView>(
    forTarget keyframeTarget: T,
    withPrevKeyframe keyframeConfigPrev: (any BaseVisualEffectSubviewConcreteKeyframe)?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
    
    return (
      setup: {
        // no-op
      },
      applyKeyframe: {
        try? self.applyBaseVisualEffectSubviewKeyframe(toTarget: keyframeTarget);
      },
      completion: { _ in
        // no-op
      }
    );
  };
  
  // MARK: - Chain Setter Methods
  // ----------------------------
  
  func withRootKeyframe(newValue: GenericViewConcreteKeyframe) -> Self {
    var copy = self;
    copy.rootKeyframe = newValue;
    return copy;
  };
  
  func withContentKeyframe(newValue: GenericViewConcreteKeyframe) -> Self {
    var copy = self;
    copy.contentKeyframe = newValue;
    return copy;
  };
  
  func withBackdropKeyframe(newValue: GenericViewConcreteKeyframe) -> Self {
    var copy = self;
    copy.backdropKeyframe = newValue;
    return copy;
  };
};
