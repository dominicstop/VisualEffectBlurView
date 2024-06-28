//
//  Array+UIBlurEffectStyle.swift
//  
//
//  Created by Dominic Go on 6/28/24.
//

import UIKit


public extension Array where Element == UIBlurEffect.Style {
  
  @available(iOS 13.0, *)
  var blurFilterEntryWrappers: [VisualEffectFilterEntryWrapper] {
    self.reduce(into: []) {
      $0 += $1.blurFilterEntryWrappers ?? [];
    };
  };
  
  @available(iOS 13.0, *)
  var vibrancyFilterEntryWrappers: [VisualEffectFilterEntryWrapper] {
    self.reduce(into: []) {
      $0 += $1.vibrancyFilterEntryWrappers;
    };
  };
  
  @available(iOS 13.0, *)
  var filterEntryWrappers: [VisualEffectFilterEntryWrapper] {
      self.blurFilterEntryWrappers
    + self.vibrancyFilterEntryWrappers;
  };
  
  @available(iOS 13.0, *)
  var filterEntries: [FilterEntryMetadata] {
    self.filterEntryWrappers.compactMap {
      .init(fromWrapper: $0);
    };
  };
};

