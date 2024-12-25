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

  private var _didSetup = false;
  public var gradientCache: LayerFilterConfig.ImageGradientCache = [:];
  
  // MARK: - Init
  // ------------
  
  public convenience init(
    withInitialBackgroundFilters initialBackgroundFilters: [LayerFilterConfig],
    initialForegroundFilters: [LayerFilterConfig]? = nil,
    tintConfig: TintConfig? = nil
  ) throws {
    let dummyEffect = UIBlurEffect(style: .regular);
    try self.init(withEffect: dummyEffect);
    
    try self.immediatelyApplyFilters(
      backgroundFilters: initialBackgroundFilters,
      foregroundFilters: initialForegroundFilters,
      tintConfig: tintConfig
    );
    
    self._didSetup = true;
  };
  
  // MARK: - Methods
  // ---------------
  
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
      $0.createAssociatedFilterType(gradientCache: &self.gradientCache);
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
      shouldImmediatelyApplyFilter: self._didSetup
    );
    
    if let foregroundFilterConfigs = foregroundFilterConfigs {
      let foregroundFilterTypes = foregroundFilterConfigs.map {
        $0.createAssociatedFilterType(gradientCache: &self.gradientCache);
      };
      
      let isResettingForegroundFilters = foregroundFilterTypes.count == 0;
      
      if isResettingForegroundFilters {
        try self.immediatelyRemoveAllForegroundFilters();
      };
      
      try self.setForegroundFiltersViaEffectDesc(
        withFilterTypes: foregroundFilterTypes,
        shouldImmediatelyApplyFilter: true
      );
    };
    
    if let tintConfig = tintConfig {
      try self.directlySetTint(forConfig: tintConfig);
    };
    
    self.currentTintConfig = tintConfig;
  };
  
  override public func reapplyEffects() throws {
    try super.reapplyEffects();
  };
  
  // MARK: - Methods - Background Filters
  // ------------------------------------
  
  @available(iOS 13, *)
  public func setBackgroundFiltersViaEffectDesc(
    withFilterConfigItems filterConfigItems: [LayerFilterConfig],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    let filterTypes = filterConfigItems.map {
      $0.createAssociatedFilterType(gradientCache: &self.gradientCache);
    };
    
    try self.setBackgroundFiltersViaEffectDesc(
      withFilterTypes: filterTypes,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
  };
  
  public func updateBackgroundFiltersViaEffectDesc(
    withFilterConfigItems updatedFilterConfigItems: [LayerFilterConfig],
    options: EffectDescriptionUpdateOptions? = nil
  ) throws {
    
    let updatedFilterTypes = updatedFilterConfigItems.map {
      $0.createAssociatedFilterType(gradientCache: &self.gradientCache);
    };
    
    let options = options ?? [.useReferenceEqualityForImageComparison];
    
    try self.updateBackgroundFiltersViaEffectDesc(
      withFilterTypes: updatedFilterTypes,
      options: options
    );
  };
};
