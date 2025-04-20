//
//  BaseVisualEffectSubviewPartialKeyframe.swift
//  VisualEffectBlurView
//
//  Created by Dominic Go on 4/21/25.
//

import UIKit
import DGSwiftUtilities


@available(iOS 13, *)
public protocol BaseVisualEffectSubviewPartialKeyframe:
  BasePartialKeyframe where ConcreteKeyframe: BaseVisualEffectSubviewConcreteKeyframe
{
  var rootKeyframe: GenericViewPartialKeyframe? { get set };
  var contentKeyframe: GenericViewPartialKeyframe? { get set };
  var backdropKeyframe: GenericViewPartialKeyframe? { get set };
};
