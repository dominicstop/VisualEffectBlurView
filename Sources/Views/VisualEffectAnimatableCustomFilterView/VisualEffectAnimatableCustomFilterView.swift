//
//  VisualEffectAnimatableCustomFilterView.swift
//  
//
//  Created by Dominic Go on 12/26/24.
//

import UIKit
import DGSwiftUtilities


 @available(iOS 13, *)
 public class VisualEffectAnimatableCustomFilterView: VisualEffectCustomFilterView {

  public typealias KeyframeConfig = CustomFilterKeyframeConfig;
  
  public var identityBackgroundFilters: [LayerFilterConfig] = [];
  public var identityForegroundFilters: [LayerFilterConfig] = [];

  public convenience init(
    identityBackgroundFilters: [LayerFilterConfig],
    identityForegroundFilters: [LayerFilterConfig],
    initialKeyframe: KeyframeConfig? = nil,
    usingDummyFilter dummyEffect: UIVisualEffect? = nil
  ) throws {
    
    let dummyEffect = dummyEffect ?? UIBlurEffect(style: .regular);
    try self.init(withEffect: dummyEffect);
    
    self.identityBackgroundFilters = identityBackgroundFilters;
    self.identityForegroundFilters = identityForegroundFilters;
    
    let backgroundFiltersMergeResults = identityBackgroundFilters.updateAndMergeElements(
      withOther: initialKeyframe?.backgroundFilters ?? []
    );
    
    let foregroundFiltersMergeResults = identityForegroundFilters.updateAndMergeElements(
      withOther: initialKeyframe?.foregroundFilters ?? []
    );
    
    try self.immediatelyApplyFilters(
      backgroundFilters: backgroundFiltersMergeResults.mergedItems,
      foregroundFilters: foregroundFiltersMergeResults.mergedItems,
      tintConfig: initialKeyframe?.tintConfig,
      isSettingFiltersForTheFirstTime: true
    );
    
    try self.applyRequestedFilterEffects();
    
    if let tintConfig = initialKeyframe?.tintConfig {
      try self.directlySetTint(forConfig: tintConfig);
    };
    
    initialKeyframe?.applyBaseKeyframe(toView: self);
  };
  
  public func immediatelyApplyKeyframe(_ keyframeConfig: KeyframeConfig) throws {
    try self.immediatelyApplyFilters(
      backgroundFilters: keyframeConfig.backgroundFilters ?? [],
      foregroundFilters: keyframeConfig.foregroundFilters,
      tintConfig: keyframeConfig.tintConfig
    );
    
    keyframeConfig.applyBaseKeyframe(toView: self);
  };
};
