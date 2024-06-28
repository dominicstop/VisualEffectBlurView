//
//  UIBlurEffectStyle+BlurViewHelpers.swift
//  
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit
import DGSwiftUtilities

extension UIBlurEffect.Style {
  
  // [filterType: [inputRadius/inputAmount: Number]]
  fileprivate static var defaultFilterEntriesCache:
    Dictionary<Self, [FilterEntryMetadata]> = [:];
    
  fileprivate static var defaultBlurRadiusCache: Dictionary<Self, CGFloat> = [:];
  fileprivate static var didSetDefaultCache = false;
  
  static func setDefaultCacheIfNeeded(){
    guard !self.didSetDefaultCache,
          #available(iOS 13, *)
    else { return };
    
    Self.didSetDefaultCache = true;
    
    Self.allCases.forEach { blurStyle in
      let blurView = VisualEffectBlurView(blurEffectStyle: nil);
      blurView.effect = UIBlurEffect(style: blurStyle);
      
      guard let effectDescriptionWrapper = blurView.effectDescriptorForCurrentEffectWrapper,
            let filterEntriesWrapped = effectDescriptionWrapper.filterEntriesWrapped,
            filterEntriesWrapped.count > 0
      else {
        return;
      };
      
      Self.defaultFilterEntriesCache[blurStyle] = filterEntriesWrapped.compactMap {
        .init(fromWrapper: $0);
      };
      
      self.defaultBlurRadiusCache[blurStyle] = blurView.blurRadius;
    };
    return;
  };
  
  // MARK:  - Computed Properties
  // ----------------------------
  
  var defaultBlurRadiusFallback: CGFloat? {
    switch self {
      case .regular:
        return 30.0;
        
      case .prominent:
        return 20.0;
        
      case .extraLight:
        return 20.0;
        
      case .light:
        return 30.0;
        
      case .dark:
        return 20.0;
        
      case .systemUltraThinMaterial:
        return 22.5;
        
      case .systemThinMaterial:
        return 29.5;
        
      case .systemMaterial:
        return 29.5;
        
      case .systemThickMaterial:
        return 45.0;
        
      case .systemChromeMaterial:
        return 22.5;
        
      case .systemUltraThinMaterialLight:
        return 22.5;
        
      case .systemThinMaterialLight:
        return 29.5;
        
      case .systemMaterialLight:
        return 29.5;
        
      case .systemThickMaterialLight:
        return 45.0;
        
      case .systemChromeMaterialLight:
        return 22.5;
        
      case .systemUltraThinMaterialDark:
        return 22.5;
        
      case .systemThinMaterialDark:
        return 29.5;
        
      case .systemMaterialDark:
        return 29.5;
        
      case .systemThickMaterialDark:
        return 45.0;
        
      case .systemChromeMaterialDark:
        return 22.5;
  
      @unknown default:
        return nil;
    };
  };

  public var defaultBlurRadius: CGFloat? {
    Self.setDefaultCacheIfNeeded();
    
    if let blurRadius = Self.defaultBlurRadiusCache[self] {
      return blurRadius;
    };
    
    return self.defaultBlurRadiusFallback;
  };
  
  public var defaultFilterEntries: [FilterEntryMetadata] {
    Self.setDefaultCacheIfNeeded();
    
    if let cachedFilterEntry = Self.defaultFilterEntriesCache[self] {
      return cachedFilterEntry;
    };
    
    #if DEBUG
    print(
      "UIBlurEffect.Style - defaultBlurRadius",
      "\n- get defaultFilterEntriesCache",
      "\n- could not set for item:", self.description,
      "\n"
    );
    #endif
    
    return [];
  };
  
  @available(iOS 13, *)
  public var blurFilterEntryWrappers: [VisualEffectFilterEntryWrapper]? {
    let blurView = VisualEffectBlurView(blurEffectStyle: self);
    
    guard let effectDescriptionWrapper = blurView.effectDescriptorForCurrentEffectWrapper,
          let filterEntriesWrapped = effectDescriptionWrapper.filterEntriesWrapped,
          filterEntriesWrapped.count > 0
    else {
      return nil;
    };
    
    return filterEntriesWrapped;
  };
  
  @available(iOS 13.0, *)
  public var vibrancyFilterEntryWrappers: [VisualEffectFilterEntryWrapper] {
    let blurEffect = UIBlurEffect(style: self);
    
    return UIVibrancyEffectStyle.allCases.reduce(into: []) {
      let effect = UIVibrancyEffect(
        blurEffect: blurEffect,
        style: $1
      );
      
      let effectView = UIVisualEffectView(effect: effect);
      guard let effectViewWrappers =
              VisualEffectViewWrapper(objectToWrap: effectView),
              
            let visualEffectDescriptorWrapper =
              try? effectViewWrappers.effectDescriptor(forEffects: [effect], usage: true),
              
            let filterEntries = visualEffectDescriptorWrapper.filterEntriesWrapped
      else {
        return;
      };
      
      $0 += filterEntries;
    };
  };
};
