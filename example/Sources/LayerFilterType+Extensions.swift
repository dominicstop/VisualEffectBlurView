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
    self.getFilterDescAsAttributedConfig(shouldIncludeFilterName: false);
  };
  
  func getFilterDescAsAttributedConfig(
    shouldIncludeFilterName: Bool
  ) -> [CardContentItem] {
  
    var debugDisplayItems: [CardLabelValueDisplayItemConfig] = [];
    
    if shouldIncludeFilterName,
       let filterName = self.decodedFilterName
    {
      debugDisplayItems.append(
        .singleRowPlain(label: "filterName", value: filterName)
      );
    };
      
    switch self {
      case .alphaFromLuminance:
        break;

      case .averagedColor:
        break;
        
      case let .luminosityCurveMap(inputAmount, inputValues):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputAmount",
            value: "\(inputAmount)"
          ),
          .singleRowPlain(
            label: "inputValues",
            value: inputValues.description
          ),
        ];
        
      case let .colorBlackAndWhite(inputAmount):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputAmount",
            value: "\(inputAmount)"
          ),
        ];
        
      case let .saturateColors(inputAmount):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputAmount",
            value: "\(inputAmount)"
          ),
        ];
        
      case let .brightenColors(inputAmount):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputAmount",
            value: "\(inputAmount)"
          ),
        ];
        
      case let .contrastColors(inputAmount):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputAmount",
            value: "\(inputAmount)"
          ),
        ];
        
      case let .colorHueAdjust(angle):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputAngle",
            value: "\(angle.degrees)"
          ),
        ];
        
      case let .luminanceCompression(inputAmount):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputAmount",
            value: "\(inputAmount)"
          ),
        ];
        
      case let .bias(inputAmount):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputAmount",
            value: "\(inputAmount)"
          ),
        ];
          
      case let .gaussianBlur(inputRadius, inputNormalizeEdges):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputRadius",
            value: "\(inputRadius)"
          ),
          .singleRowPlain(
            label: "inputNormalizeEdges",
            value: "\(inputNormalizeEdges)"
          ),
        ];
        
      case let .darkVibrant(inputReversed, inputColor0, inputColor1):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputReversed",
            value: "\(inputReversed)"
          ),
          .singleRowPlain(
            label: "inputColor0",
            value: "\(inputColor0.components?.description ?? "N/A")"
          ),
          .singleRowPlain(
            label: "inputColor1",
            value: "\(inputColor1.components?.description ?? "N/A")"
          ),
        ];
        
      case let .lightVibrant(inputReversed, inputColor0, inputColor1):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputReversed",
            value: "\(inputReversed)"
          ),
          .singleRowPlain(
            label: "inputColor0",
            value: "\(inputColor0.components?.description ?? "N/A")"
          ),
          .singleRowPlain(
            label: "inputColor1",
            value: "\(inputColor1.components?.description ?? "N/A")"
          ),
        ];
        
      case let .colorMatrixVibrant(colorMatrix):
        debugDisplayItems += [
          .multiLineRow(
            label: [
              .init(text: "inputColorMatrix")
            ],
            value: colorMatrix.descAsAttributedConfig
          ),
        ];
        
      case let .colorMatrix(colorMatrix):
        debugDisplayItems +=  [
          .multiLineRow(
            label: [
              .init(text: "inputColorMatrix")
            ],
            value: colorMatrix.descAsAttributedConfig
          ),
        ];
        
      case let .variadicBlur(
        inputRadius,
        _ /* inputMaskImage */,
        inputNormalizeEdges
      ):
        debugDisplayItems += [
          .singleRowPlain(
            label: "inputRadius",
            value: "\(inputRadius)"
          ),
          .singleRowPlain(
            label: "inputNormalizeEdges",
            value: inputNormalizeEdges.description
          ),
        ];
    };
    
    return [
      .labelValueDisplay(items: debugDisplayItems),
    ];
  };
};
