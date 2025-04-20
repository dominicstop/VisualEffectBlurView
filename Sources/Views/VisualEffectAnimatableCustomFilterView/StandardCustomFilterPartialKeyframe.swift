//
//  StandardCustomFilterPartialKeyframe.swift
//  VisualEffectBlurView
//
//  Created by Dominic Go on 4/21/25.
//


import UIKit
import DGSwiftUtilities

@available(iOS 13, *)
public struct StandardCustomFilterPartialKeyframe:
  BaseCustomFilterPartialKeyframe,
  BaseVisualEffectSubviewPartialKeyframe
{
  
  public typealias ConcreteKeyframe = StandardCustomFilterConcreteKeyframe;
  public typealias KeyframeTarget = VisualEffectAnimatableCustomFilterView;
    
  public static var empty: Self {
    .init();
  };
  
  // MARK: - Base View Keyframes
  // ---------------------------
  
  public var rootKeyframe: GenericViewPartialKeyframe?;
  public var contentKeyframe: GenericViewPartialKeyframe?;
  public var backdropKeyframe: GenericViewPartialKeyframe?;
  
  // MARK: - Filter Keyframes
  // ------------------------
  
  public var backgroundFilters: [LayerFilterConfig]?;
  public var foregroundFilters: [LayerFilterConfig]?;
  public var tintConfig: TintConfig?;
  
  // MARK: - Init
  // ------------
  
  public init(
    rootKeyframe: GenericViewPartialKeyframe? = nil,
    contentKeyframe: GenericViewPartialKeyframe? = nil,
    backdropKeyframe: GenericViewPartialKeyframe? = nil,
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
  }
};

