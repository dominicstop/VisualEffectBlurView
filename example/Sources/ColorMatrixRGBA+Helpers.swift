//
//  ColorMatrixRGBA+Helpers.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/30/24.
//

import UIKit
import VisualEffectBlurView
import DGSwiftUtilities


extension ColorMatrixRGBA {

  var descAsAttributedConfig: [AttributedStringConfig] {
    self.matrix4x5.enumerated().reduce(into: []) { acc, curr in
      if curr.offset == 0 {
        acc += [
          .init(
            text: "ColorMatrixRGBA:",
            fontConfig: .init(size: nil, isBold: true)
          ),
          .newLine,
        ];
      };
      
      acc += curr.element.map {
        .init(
          text: $0 < 0
            ? String(format: "%.2f,", $0)
            : String(format: " %.2f,", $0),
          fontConfig: .init(
            size: nil,
            weight: nil,
            symbolicTraits: [.traitMonoSpace]
          ),
          color: .init(white: 0, alpha: 0.7)
        )
      };
      
      if curr.offset != (self.matrix4x5.count - 1) {
        acc.append(.newLine);
      };
    };
  };
};
