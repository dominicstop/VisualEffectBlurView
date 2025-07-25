//
//  VisualEffectCustomFilterView.swift
//
//
//  Created by Dominic Go on 12/13/24.
//

import UIKit
import DGSwiftUtilities

///
/// * `UIVisualEffectView` -> `VisualEffectView`
///   -> `VisualEffectCustomFilterView`
///
@available(iOS 13, *)
public class VisualEffectCustomFilterView: VisualEffectView {

  public var gradientCache: LayerFilterConfig.ImageGradientCache = [:];
  
  // MARK: - Init
  // ------------
  
  public convenience init(
    withInitialBackgroundFilters initialBackgroundFilters: [LayerFilterConfig],
    initialForegroundFilters: [LayerFilterConfig]? = nil,
    tintConfig: TintConfig? = nil,
    usingDummyFilter dummyEffect: UIVisualEffect? = nil
  ) throws {
    let dummyEffect = dummyEffect ?? UIBlurEffect(style: .regular);
    try self.init(withEffect: dummyEffect);
    
    try self.immediatelyApplyFilters(
      backgroundFilters: initialBackgroundFilters,
      foregroundFilters: initialForegroundFilters,
      tintConfig: tintConfig,
      isSettingFiltersForTheFirstTime: true
    );
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
    tintConfig: TintConfig? = nil,
    isSettingFiltersForTheFirstTime: Bool? = nil
  ) throws {
    
    self.prepareToApplyNewFilters();
    
    let isSettingFiltersForTheFirstTime =
          isSettingFiltersForTheFirstTime
       ?? !self.doesCurrentlyHaveCustomFilters;
    
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
      shouldImmediatelyApplyFilter: !isSettingFiltersForTheFirstTime
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
  
  @available(iOS 13, *)
  public func setBackgroundFiltersToIdentityViaEffectDesc(
    withFilterConfigItems filterConfigItems: [LayerFilterConfig],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    let filterTypes = filterConfigItems.map {
      $0.createAssociatedFilterType(gradientCache: &self.gradientCache);
    };
    
    let filterTypesIdentity = filterTypes.asIdentityForBackground;
    
    try self.setBackgroundFiltersViaEffectDesc(
      withFilterTypes: filterTypesIdentity,
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
  
  // MARK: - Methods - Foreground Filters
  // ------------------------------------
  
  @available(iOS 13, *)
  public func setForegroundFiltersViaEffectDesc(
    withFilterConfigItems filterConfigItems: [LayerFilterConfig],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    let filterTypes = filterConfigItems.map {
      $0.createAssociatedFilterType(gradientCache: &self.gradientCache);
    };
    
    try self.setForegroundFiltersViaEffectDesc(
      withFilterTypes: filterTypes,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
  };
  
  @available(iOS 13, *)
  public func setForegroundFiltersToIdentityViaEffectDesc(
    withFilterConfigItems filterConfigItems: [LayerFilterConfig],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    let filterTypes = filterConfigItems.map {
      $0.createAssociatedFilterType(gradientCache: &self.gradientCache);
    };
    
    let updatedFilterTypesIdentity = filterTypes.asIdentityForBackground;
    
    try self.setForegroundFiltersViaEffectDesc(
      withFilterTypes: updatedFilterTypesIdentity,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
  };
  
  @available(iOS 13, *)
  public func updateForegroundFiltersViaEffectDesc(
    withFilterConfigItems updatedFilterConfigItems: [LayerFilterConfig],
    options: EffectDescriptionUpdateOptions? = nil
  ) throws {
    
    let updatedFilterTypes = updatedFilterConfigItems.map {
      $0.createAssociatedFilterType(gradientCache: &self.gradientCache);
    };
    
    let options = options ?? [.useReferenceEqualityForImageComparison];
    
    try self.updateForegroundFiltersViaEffectDesc(
      withFilterTypes: updatedFilterTypes,
      options: options
    );
  };
  
  // MARK: - Methods - Filters
  // -------------------------
  
  public func setFiltersViaEffectDesc(
    backgroundFilterConfigItems: [LayerFilterConfig],
    foregroundFilterConfigItems: [LayerFilterConfig],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    try self.setBackgroundFiltersViaEffectDesc(
      withFilterConfigItems: backgroundFilterConfigItems,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
    
    try self.setForegroundFiltersViaEffectDesc(
      withFilterConfigItems: foregroundFilterConfigItems,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
  };
  
  // MARK: - Methods - Animation Related
  // -----------------------------------
  
  public func createAnimationBlocks(
    backgroundFilterConfigItems: [LayerFilterConfig],
    foregroundFilterConfigItems: [LayerFilterConfig],
    identityBackgroundFilterConfigItems: [LayerFilterConfig]? = nil,
    identityForegroundFilterConfigItems: [LayerFilterConfig]? = nil,
    shouldApplyIdentityFilters: Bool = false
  ) throws -> (
    prepare: () throws -> Void,
    animations: () -> Void,
    completion: () -> Void
  ) {
  
    func applyIdentityFiltersIfNeeded() throws {
      guard shouldApplyIdentityFilters else {
        return;
      };
      
      if let identityBackgroundFilterConfigItems = identityBackgroundFilterConfigItems {
        try self.setBackgroundFiltersViaEffectDesc(
          withFilterConfigItems: identityBackgroundFilterConfigItems,
          shouldImmediatelyApplyFilter: true
        );
        
      } else {
        try self.setBackgroundFiltersToIdentityViaEffectDesc(
          withFilterConfigItems: backgroundFilterConfigItems,
          shouldImmediatelyApplyFilter: true
        );
      };
      
      if let identityForegroundFilterConfigItems = identityForegroundFilterConfigItems {
        try self.setForegroundFiltersViaEffectDesc(
          withFilterConfigItems: identityForegroundFilterConfigItems,
          shouldImmediatelyApplyFilter: true
        );
        
      } else {
        try self.setForegroundFiltersToIdentityViaEffectDesc(
          withFilterConfigItems: foregroundFilterConfigItems,
          shouldImmediatelyApplyFilter: true
        );
      };
    };
    
    return (
      prepare: {
        self.isBeingAnimated = true;
        try applyIdentityFiltersIfNeeded();
        
        if backgroundFilterConfigItems.count > 0 {
          try self.updateBackgroundFiltersViaEffectDesc(
            withFilterConfigItems: backgroundFilterConfigItems
          );
        };
        
        if foregroundFilterConfigItems.count > 0 {
          try self.updateForegroundFiltersViaEffectDesc(
            withFilterConfigItems: foregroundFilterConfigItems
          );
        };
      },
      animations: {
        try? self.applyRequestedFilterEffects();
      },
      completion: {
        self.isBeingAnimated = true;
      }
    );
  };
};
