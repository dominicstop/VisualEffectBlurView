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
      case .alphaFromLuminance:
        return [];

      case .averagedColor:
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
        
      case let .luminosityCurveMap(inputAmount, inputValues):
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
        
      case let .colorBlackAndWhite(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .saturateColors(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .brightenColors(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .contrastColors(inputAmount):
        return [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "inputAmount",
              value: "\(inputAmount)"
            ),
          ]),
        ];
        
      case let .luminanceCompression(inputAmount):
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
        
      case let .darkVibrant(inputReversed, inputColor0, inputColor1):
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
        
      case let .lightVibrant(inputReversed, inputColor0, inputColor1):
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
        
      case let .colorMatrixVibrant(colorMatrix):
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
