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
    withInitialBackgroundFilters initialBackgroundFilters: [LayerFilterConfig],
    initialForegroundFilters: [LayerFilterConfig]? = nil
  ) throws {
    let dummyEffect = UIBlurEffect(style: .regular);
    try self.init(withEffect: dummyEffect);
    
    try self.immediatelyApplyFilters(
      backgroundFilters: initialBackgroundFilters,
      foregroundFilters: initialForegroundFilters
    );
  };
  
  public func prepareToApplyNewFilters(){
    self.effect = nil;
    let dummyEffect = UIBlurEffect(style: .regular);
    self.effect = dummyEffect;
  };
  
  public func immediatelyApplyFilters(
    backgroundFilters backgroundFilterConfigs: [LayerFilterConfig],
    foregroundFilters foregroundFilterConfigs: [LayerFilterConfig]? = nil,
    tintConfig: TintConfig? = nil
  ) throws {
    self.prepareToApplyNewFilters();
    
    let backgroundFilterTypes = backgroundFilterConfigs.map {
      $0.associatedFilterType;
    };
    
    let isResettingBackgroundFilters = backgroundFilterTypes.count == 0;
    
    if isResettingBackgroundFilters {
      try self.immediatelyRemoveAllBackgroundFilters();
      self.backgroundEffectOpacity = 0;
      
    } else {
      self.backgroundEffectOpacity = 1;
    };
    
    try self.setBackgroundFiltersViaEffectDesc(
      withFilterTypes: backgroundFilterTypes,
      shouldImmediatelyApplyFilter: true
    );
    
    var error: Error? = nil;
    
    block:
    if let tintConfig = tintConfig {
      guard let tintViewWrapped = self.wrapper?.tintViewWrapped else {
        error = VisualEffectBlurViewError(
          errorCode: .unexpectedNilValue,
          description: "Unable to get `tintViewWrapped`"
        );
        break block;
      };
      
      if tintViewWrapped.wrappedObject == nil {
        self.displayNow();
      };
      
      guard let tintView = tintViewWrapped.wrappedObject else {
        error = VisualEffectBlurViewError(
          errorCode: .unexpectedNilValue,
          description: "Unable to get `tintView`"
        );
        break block;
      };
    };
    
    if let foregroundFilterConfigs = foregroundFilterConfigs {
      let foregroundFilterTypes = foregroundFilterConfigs.map {
        $0.associatedFilterType;
      };
      
      let isResettingForegroundFilters = foregroundFilterTypes.count == 0;
      
      if isResettingForegroundFilters {
        try self.immediatelyRemoveAllForegroundFilters();
        print(isResettingForegroundFilters);
      };
      
      try self.setForegroundFiltersViaEffectDesc(
        withFilterTypes: foregroundFilterTypes,
        shouldImmediatelyApplyFilter: true
      );
    };
    
    if let error = error {
      throw error;
    };
  };
};
