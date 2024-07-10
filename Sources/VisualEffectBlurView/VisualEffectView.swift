//
//  VisualEffectView.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import UIKit
import DGSwiftUtilities


public class VisualEffectView: UIVisualEffectView {
  
  public var wrapper: UVEViewWrapper!;
  
  /// Old name: `shouldOnlyShowBackdropLayer`
  public var shouldOnlyShowBgLayer: Bool = false {
    willSet {
      guard let bgLayerWrapper = self.bgLayerWrapper,
            let backdropLayer = bgLayerWrapper.wrappedObject
      else {
        return;
      };
      
      self.subviews.forEach {
        guard $0.layer !== backdropLayer else {
          return;
        };
        
        $0.isHidden = newValue;
      };
    }
  };
  
  /// Old name: `backgroundHostWrapper`
  var bgHostWrapper: UVEHostWrapper? {
    self.wrapper.bgHostWrapped;
  };
  
  /// Old name: `contentViewWrapper`
  var viewContentWrapper: UVEBackdropViewWrapper? {
    self.bgHostWrapper?.viewContentWrapped;
  };
  
  /// Old name: `backdropLayerWrapper`
  var bgLayerWrapper: BackgroundLayerWrapper? {
    self.viewContentWrapper?.bgLayerWrapper
  };
  
  /// Old name: `effectDescriptorForCurrentEffectWrapper`
  @available(iOS 13, *)
  var currentEffectMetadata: UVEDescriptorWrapper? {
    guard let effect = self.effect,
          let wrapper = self.wrapper
    else {
      return nil;
    };
    
    return try? wrapper.getEffectMetadata(
      forEffects: [effect],
      usage: true
    );
  };
  
  // MARK: - Init
  // ------------
  
  public init?(rawFilterTypes: [String]? = nil){
    super.init(effect: UIBlurEffect(style: .regular));
    
    guard let wrapper = UVEViewWrapper(objectToWrap: self) else {
      return nil;
    };
    
    self.wrapper = wrapper;
    
    guard let bgLayerWrapper = self.bgLayerWrapper,
          let backdropLayer = bgLayerWrapper.wrappedObject
    else {
      return;
    };
    
    try? self.setFiltersViaLayers([]);
    if #available(iOS 13, *) {
      try? self.setFiltersUsingEffectDesc([])
    };
    
    guard let rawFilterTypes = rawFilterTypes else {
      return;
    };
    
    let filterWrappers: [LayerFilterWrapper] = rawFilterTypes.compactMap {
      .init(rawFilterType: $0);
    };
    
    let filters = filterWrappers.compactMap {
      $0.wrappedObject;
    };
    
    backdropLayer.filters = filters;
  };
  
  public init?(withEffect effect: UIVisualEffect?){
    super.init(effect: UIBlurEffect(style: .regular));
    
    guard let wrapper = UVEViewWrapper(objectToWrap: self) else {
      return nil;
    };
    
    self.wrapper = wrapper;
  };

  public init?(
    filterTypes: [LayerFilterType],
    shouldSetFiltersUsingEffectDesc: Bool = true
  ) throws {
  
    super.init(effect: UIBlurEffect(style: .regular));
    guard let wrapper = UVEViewWrapper(objectToWrap: self) else {
      return nil;
    };
    
    self.wrapper = wrapper;
    
    if #available(iOS 13, *),
       shouldSetFiltersUsingEffectDesc
    {
      try self.setFiltersUsingEffectDesc(filterTypes);
      
    } else {
      try self.setFiltersViaLayers(filterTypes);
    };
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  // MARK: - Methods
  // ---------------
  
  @available(iOS 13, *)
  public func setFiltersUsingEffectDesc(
    _ filterTypes: [LayerFilterType],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    guard let bgHostWrapper = self.bgHostWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
    guard let viewContentWrapper = self.viewContentWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.viewContentWrapper`"
      );
    };
    
    guard let effectDescWrapper = UVEDescriptorWrapper(),
          effectDescWrapper.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `UVEDescriptorWrapper` instance"
      );
    };
    
    let filterEntriesWrapped: [UVEFilterEntryWrapper] = filterTypes.compactMap {
      try? .init(
        filterKind: $0.associatedFilterTypeName,
        filterValuesConfig: $0.filterValuesConfig,
        filterValuesRequested: $0.filterValuesRequested,
        filterValuesIdentity: $0.filterValuesIdentity
      );
    };
    
    try effectDescWrapper.setFilterItems(filterEntriesWrapped);
    try bgHostWrapper.setEffectDescriptor(effectDescWrapper);
    
    if shouldImmediatelyApplyFilter {
      try viewContentWrapper.applyRequestedFilterEffects();
    };
  };
  
  public func setFiltersViaLayers(
    _ filterTypes: [LayerFilterType],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
    guard let bgHostWrapper = self.bgHostWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
    guard let contentViewWrapper = bgHostWrapper.viewContentWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `UVEHostWrapper.viewContentWrapped`"
      );
    };
    
    guard let bgLayerWrapper = contentViewWrapper.bgLayerWrapper,
          let bgLayer = bgLayerWrapper.wrappedObject
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgLayerWrapper`"
      );
    };
    
    let filterWrappers = filterTypes.compactMap {
      $0.createFilterWrapper();
    };
    
    let filters = filterWrappers.compactMap {
      $0.wrappedObject;
    };
    
    bgLayer.filters = filters;
    if shouldImmediatelyApplyFilter {
      try contentViewWrapper.applyRequestedFilterEffects();
    };
  };
  
  public func applyRequestedFilterEffects() throws {
    guard let viewContentWrapper = self.viewContentWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.viewContentWrapper`"
      );
    };
    
    try viewContentWrapper.applyRequestedFilterEffects();
  };
};
