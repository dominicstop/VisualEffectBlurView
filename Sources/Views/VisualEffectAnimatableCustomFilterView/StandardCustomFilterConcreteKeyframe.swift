//
//  StandardCustomFilterConcreteKeyframe.swift
//  VisualEffectBlurView
//
//  Created by Dominic Go on 4/21/25.
//

import UIKit
import DGSwiftUtilities


@available(iOS 13, *)
public struct StandardCustomFilterConcreteKeyframe:
  BaseCustomFilterConcreteKeyframe,
  BaseVisualEffectSubviewConcreteKeyframe
{
  
  public typealias PartialKeyframe = StandardCustomFilterPartialKeyframe;
  public typealias KeyframeTarget = PartialKeyframe.KeyframeTarget;
  
  public static let `default`: Self = .init(
    rootKeyframe: .init(
      backgroundColor: .clear
    ),
    contentKeyframe: .init(
      backgroundColor: .clear
    ),
    backdropKeyframe: .init(
      backgroundColor: .clear
    ),
    backgroundFilters: [],
    foregroundFilters: [],
    tintConfig: .noTint
  );
  
  // MARK: - Base View Keyframes
  // ---------------------------
  
  public var rootKeyframe: GenericViewConcreteKeyframe;
  public var contentKeyframe: GenericViewConcreteKeyframe;
  public var backdropKeyframe: GenericViewConcreteKeyframe;
  
  // MARK: - Filter Keyframes
  // ------------------------
  
  public var backgroundFilters: [LayerFilterConfig];
  public var foregroundFilters: [LayerFilterConfig];
  public var tintConfig: TintConfig;
  
  init(
    rootKeyframe: GenericViewConcreteKeyframe,
    contentKeyframe: GenericViewConcreteKeyframe,
    backdropKeyframe: GenericViewConcreteKeyframe,
    backgroundFilters: [LayerFilterConfig],
    foregroundFilters: [LayerFilterConfig],
    tintConfig: TintConfig
  ) {
    self.rootKeyframe = rootKeyframe
    self.contentKeyframe = contentKeyframe
    self.backdropKeyframe = backdropKeyframe
    self.backgroundFilters = backgroundFilters
    self.foregroundFilters = foregroundFilters
    self.tintConfig = tintConfig
  };
  
  
  @available(*, deprecated)
  public init(
    rootKeyframe: GenericViewConcreteKeyframe? = nil,
    contentKeyframe: GenericViewConcreteKeyframe? = nil,
    backdropKeyframe: GenericViewConcreteKeyframe? = nil,
    backgroundFilters: [LayerFilterConfig]? = nil,
    foregroundFilters: [LayerFilterConfig]? = nil,
    tintConfig: TintConfig? = nil
  ) {
    self.init(
      rootKeyframe:
        rootKeyframe ?? Self.default.rootKeyframe,
      
      contentKeyframe:
        contentKeyframe ?? Self.default.contentKeyframe,
      
      backdropKeyframe:
        backdropKeyframe ?? Self.default.backdropKeyframe,
      
      backgroundFilters:
        backgroundFilters ?? Self.default.backgroundFilters,
      
      foregroundFilters:
        foregroundFilters ?? Self.default.foregroundFilters,
      
      tintConfig:
        tintConfig ?? Self.default.tintConfig
    );
  };
  
  // MARK: - KeyframeAppliable
  // -------------------------
  
  public func apply(toTarget target: KeyframeTarget) throws {
    self.applyBaseKeyframe(toView: target);
    try? self.applyBaseCustomFilterKeyframe(toTarget: target);
    
    try? self.rootKeyframe.apply(toTarget: target);
    
    if let backgroundViewWrapped = target.hostForBackgroundContentViewWrapped,
       let backgroundView = backgroundViewWrapped.wrappedObject
    {
      try? self.backdropKeyframe.apply(toTarget: backgroundView);
    };
    
    try? self.contentKeyframe.apply(toTarget: target.contentView);
  };
};
