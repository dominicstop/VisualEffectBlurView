//
//  LayerFilterType+Extensions.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/30/24.
//

import UIKit
import VisualEffectBlurView
import DGSwiftUtilities

extension LayerFilterType {

  var filterNameAsAttributedConfig: [AttributedStringConfig] {
    return [
      .init(
        text: "Filter Name:",
        fontConfig: .init(size: nil, isBold: true)
      ),
      .init(text: self.decodedFilterName ?? "N/A"),
    ];
  };

  var filterDescAsAttributedConfig: [CardContentItem] {
    switch self {
      case .luminanceToAlpha:
        return [];

      case .averageColor:
        return [];
        
      case let .curves(inputAmount, inputValues):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
            .singleRowPlain(
              label: "inputValues",
              value: inputValues.description
            ),
          ]),
        ];
        
      case let .luminanceCurveMap(inputAmount, inputValues):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
            .singleRowPlain(
              label: "inputValues",
              value: inputValues.description
            ),
          ]),
        ];
        
      case let .colorMonochrome(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .colorSaturate(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .colorBrightness(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .colorContrast(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .compressLuminance(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .bias(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .gaussianBlur(inputRadius, inputNormalizeEdges):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputRadius",
              value: "\(inputRadius)"
            ),
            .singleRowPlain(
              label: "inputNormalizeEdges",
              value: "\(inputNormalizeEdges)"
            ),
          ]),
        ];
        
      case let .vibrantDark(inputReversed, inputColor0, inputColor1):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputReversed",
              value: "\(inputReversed)"
            ),
            .singleRowPlain(
              label: "inputReversed",
              value: "\(inputColor0.components?.description ?? "N/A")"
            ),
            .singleRowPlain(
              label: "inputReversed",
              value: "\(inputColor1.components?.description ?? "N/A")"
            ),
          ]),
        ];
        
      case let .vibrantLight(inputReversed, inputColor0, inputColor1):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputReversed",
              value: "\(inputReversed)"
            ),
            .singleRowPlain(
              label: "inputReversed",
              value: "\(inputColor0.components?.description ?? "N/A")"
            ),
            .singleRowPlain(
              label: "inputReversed",
              value: "\(inputColor1.components?.description ?? "N/A")"
            ),
          ]),
        ];
        
      case let .vibrantColorMatrix(colorMatrix):
        return [
          .multiLineLabel(colorMatrix.descAsAttributedConfig),
        ];
        
      case let .colorMatrix(colorMatrix):
        return [
          .multiLineLabel(colorMatrix.descAsAttributedConfig),
        ];
    };
  };
};
