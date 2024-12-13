//
//  VisualEffectCustomFilterView.swift
//
//
//  Created by Dominic Go on 12/13/24.
//

import UIKit
import DGSwiftUtilities

@available(iOS 13, *)
public class VisualEffectCustomFilterView: VisualEffectView {
  
  public convenience init(
    withInitialFilters initialFilters: [LayerFilterType]
  ) throws {
    let dummyEffect = UIBlurEffect(style: .regular);
    try self.init(withEffect: dummyEffect);
    try self.immediatelyApplyFilters(initialFilters);
  };
  
  public func immediatelyApplyFilters(
    _ nextFilters: [LayerFilterType]
  ) throws {
  
    self.effect = nil;
    let dummyEffect = UIBlurEffect(style: .regular);
    self.effect = dummyEffect;
    
    try self.setFiltersViaEffectDesc(
      withFilterTypes: nextFilters,
      shouldImmediatelyApplyFilter: true
    );
  };
};
