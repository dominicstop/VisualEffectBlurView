//
//  Array+UIBlurEffectStyle.swift
//  
//
//  Created by Dominic Go on 6/28/24.
//

import UIKit


public extension Array where Element == UIBlurEffect.Style {
  
  @available(iOS 13.0, *)
  var blurFilterEntryWrappers: [UVEFilterEntryWrapper] {
    self.reduce(into: []) {
      $0 += $1.blurFilterEntryWrappers ?? [];
    };
  };
  
  @available(iOS 13.0, *)
  var vibrancyFilterEntryWrappers: [UVEFilterEntryWrapper] {
    self.reduce(into: []) {
      $0 += $1.vibrancyFilterEntryWrappers;
    };
  };
  
  @available(iOS 13.0, *)
  var filterEntryWrappers: [UVEFilterEntryWrapper] {
      self.blurFilterEntryWrappers
    + self.vibrancyFilterEntryWrappers;
  };
  
  @available(iOS 13.0, *)
  var filterItems: [FilterEntryMetadata] {
    self.filterEntryWrappers.compactMap {
      .init(fromWrapper: $0);
    };
  };
};

