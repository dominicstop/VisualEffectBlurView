//
//  UIVibrancyEffectStyle+CaseIterable.swift
//
//
//  Created by Dominic Go on 6/22/24.
//

import UIKit
import DGSwiftUtilities

@available(iOS 13.0, *)
extension UIVibrancyEffectStyle: CaseIterable {

  public static var allCases: [UIVibrancyEffectStyle] {
    return [
      .label,
      .secondaryLabel,
      .tertiaryLabel,
      .quaternaryLabel,
      .fill,
      .secondaryFill,
      .tertiaryFill,
      .separator,
    ];
  };
};
