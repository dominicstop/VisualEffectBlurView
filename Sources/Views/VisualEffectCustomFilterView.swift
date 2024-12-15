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
    
    self.setOpacityForOtherSubviews(newOpacity: 0);
    try self.immediatelyApplyFilters(initialFilters);
  };
  
  public func prepareToApplyNewFilters(){
    self.effect = nil;
    let dummyEffect = UIBlurEffect(style: .regular);
    self.effect = dummyEffect;
    
    self.setOpacityForOtherSubviews(newOpacity: 0);
  };
  
  public func immediatelyApplyFilters(
    _ nextFilters: [LayerFilterConfig]
  ) throws {
    self.prepareToApplyNewFilters();
    
    let filterTypes = nextFilters.map {
      $0.associatedFilterType;
    };
    
    try self.setFiltersViaEffectDesc(
      withFilterTypes: filterTypes,
      shouldImmediatelyApplyFilter: true
    );
  };
};
