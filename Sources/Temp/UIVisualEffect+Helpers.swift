//
//  UIVisualEffect+Helpers.swift
//  
//
//  Created by Dominic Go on 12/13/24.
//

import UIKit

public extension UIVisualEffect {
  
  @available(iOS 13, *)
  func extractColorMatrixValues() -> [NSValue] {
    let effectView = UIVisualEffectView(effect: self);
    
    guard let effectViewWrappers = UVEViewWrapper(objectToWrap: self),
          let effectMetadataWrapped = try? effectViewWrappers.getEffectMetadata(
            forEffects: [self],
            usage: true
          ),
          let filterItemsWrapped = effectMetadataWrapped.filterItemsWrapped
    else {
      return [];
    };
    
    let targetKey =
      LayerFilterWrapper.EncodedString.propertyFilterInputKeyColorMatrix;

    return filterItemsWrapped.compactMap {
      guard let keyValue = targetKey.decodedString,
            let filterValuesRequested = $0.filterValuesRequested,
            let colorMatrixRaw = filterValuesRequested[keyValue],
            let colorMatrixValue = colorMatrixRaw as? NSValue
      else {
        return nil;
      };
      
      return colorMatrixValue;
    };
  };
};
