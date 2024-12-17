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
    withInitialFilters initialFilters: [LayerFilterConfig]
  ) throws {
    let dummyEffect = UIBlurEffect(style: .regular);
    try self.init(withEffect: dummyEffect);
    
    try self.immediatelyApplyFilters(initialFilters);
  };
  
  public func prepareToApplyNewFilters(){
    self.effect = nil;
    let dummyEffect = UIBlurEffect(style: .regular);
    self.effect = dummyEffect;
  };
  
  public func immediatelyApplyFilters(
    _ nextFilters: [LayerFilterConfig]
  ) throws {
    self.prepareToApplyNewFilters();
    
    let filterTypes = nextFilters.map {
      $0.associatedFilterType;
    };
    
    let isResettingFilters = nextFilters.count == 0;
    if isResettingFilters {
      try self.immediatelyRemoveAllFilters();
      self.effectOpacity = 0;
      
    } else {
      self.effectOpacity = 1;
    };
    
    try self.setFiltersViaEffectDesc(
      withFilterTypes: filterTypes,
      shouldImmediatelyApplyFilter: true
    );
  };
};
