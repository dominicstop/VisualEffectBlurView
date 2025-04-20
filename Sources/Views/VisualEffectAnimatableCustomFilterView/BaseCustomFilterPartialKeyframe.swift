//
//  BaseCustomFilterPartialKeyframe.swift
//  VisualEffectBlurView
//
//  Created by Dominic Go on 4/17/25.
//

import Foundation
import DGSwiftUtilities


@available(iOS 13, *)
public protocol BaseCustomFilterPartialKeyframe:
  BasePartialKeyframe where ConcreteKeyframe: BaseCustomFilterConcreteKeyframe
{
  var backgroundFilters: [LayerFilterConfig]? { get set };
  var foregroundFilters: [LayerFilterConfig]? { get set };
  var tintConfig: TintConfig? { get set };
};
  
