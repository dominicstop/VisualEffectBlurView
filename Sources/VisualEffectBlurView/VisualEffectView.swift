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
  
  public var currentFilterTypes: [LayerFilterType] = [];
  
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
  
  public init(withEffect effect: UIVisualEffect) throws {
    super.init(effect: effect);
    
    guard let wrapper = UVEViewWrapper(objectToWrap: self) else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `UVEViewWrapper` instance"
      );
    };
    
    self.wrapper = wrapper;
  };
  
  public convenience init(rawFilterTypes: [String]?) throws {
    try self.init(withEffect: UIBlurEffect(style: .regular));
    
    let rawFilterTypes = rawFilterTypes ?? [];
    
    let filterWrappers: [LayerFilterWrapper] = rawFilterTypes.compactMap {
      .init(rawFilterType: $0);
    };
    
    try self.setFiltersViaLayers(
      withLayerFilterWrappers: filterWrappers,
      shouldImmediatelyApplyFilter: true
    );
  };
  
  public convenience init(
    filterTypes: [LayerFilterType],
    shouldSetFiltersUsingEffectDesc: Bool = true
  ) throws {
  
    try self.init(withEffect: UIBlurEffect(style: .regular));
    
    if #available(iOS 13, *),
       shouldSetFiltersUsingEffectDesc
    {
      try self.setFiltersViaEffectDesc(
        withFilterTypes: filterTypes,
        shouldImmediatelyApplyFilter: true
      );
      
    } else {
      try self.setFiltersViaLayers(
        withFilterTypes: filterTypes,
        shouldImmediatelyApplyFilter: true
      );
    };
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  // MARK: - Methods
  // ---------------
  
  @available(iOS 13, *)
  public func setFiltersViaEffectDesc(
    withFilterEntryWrappers filterEntryWrappers: [UVEFilterEntryWrapper],
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
    
    try effectDescWrapper.setFilterItems(filterEntryWrappers);
    try bgHostWrapper.setEffectDescriptor(effectDescWrapper);
    
    if shouldImmediatelyApplyFilter {
      try viewContentWrapper.applyRequestedFilterEffects();
    };
  };
  
  @available(iOS 13, *)
  public func setFiltersViaEffectDesc(
    withFilterTypes filterTypes: [LayerFilterType],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
      
    var filterEntriesWrapped: [UVEFilterEntryWrapper] = [];
    
    filterEntriesWrapped += filterTypes.compactMap {
      try? .init(
        filterKind: $0.associatedFilterTypeName,
        filterValuesConfig: $0.filterValuesConfig,
        filterValuesRequested: $0.filterValuesRequested,
        filterValuesIdentity: $0.filterValuesIdentity
      );
    };
    
    try self.setFiltersViaEffectDesc(
      withFilterEntryWrappers: filterEntriesWrapped,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
    
    self.currentFilterTypes = filterTypes;
  };
  
  public func setFiltersViaLayers(
    withLayerFilterWrappers layerFilterWrappers: [LayerFilterWrapper],
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
    
    let filters = layerFilterWrappers.compactMap {
      $0.wrappedObject;
    };
    
    bgLayer.filters = filters;
    
    if shouldImmediatelyApplyFilter {
      try contentViewWrapper.applyRequestedFilterEffects();
    };
  };
  
  public func setFiltersViaLayers(
    withFilterTypes filterTypes: [LayerFilterType],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    let filterWrappers = filterTypes.compactMap {
      $0.createFilterWrapper();
    };
    
    try self.setFiltersViaLayers(
      withLayerFilterWrappers: filterWrappers,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
    
    self.currentFilterTypes = filterTypes;
  };
  
  @available(iOS 13, *)
  public func updateCurrentFiltersViaEffectDesc(
    withFilterTypes updatedFilterTypes: [LayerFilterType]
  ) throws {
  
    guard let bgHostWrapper = self.bgHostWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
    guard let effectDescWrapper = UVEDescriptorWrapper(),
          effectDescWrapper.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `UVEDescriptorWrapper` instance"
      );
    }
    
    guard let effectDescWrapper = try? bgHostWrapper.getEffectDescriptorCurrent() else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `effectDescWrapper` instance"
      );
    };
    
    guard let filterItemsWrapped = effectDescWrapper.filterItemsWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `filterItemsWrapped` instance"
      );
    };
    
    filterItemsWrapped.forEach { wrappedFilterItem in
      let match = updatedFilterTypes.first {
        $0.decodedFilterName == $0.decodedFilterName;
      };
      
      guard let match = match else { return };
      try? match.applyTo(filterEntryWrapper: wrappedFilterItem);
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
  
  @available(iOS 13, *)
  public func getCurrentFilterEntriesFromCurrentEffectDescriptor() throws -> [UVEFilterEntryWrapper] {
  
    guard let bgHostWrapper = self.bgHostWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
    let effectDescWrapped = try bgHostWrapper.getEffectDescriptorCurrent();
     guard let effectDescWrapped = effectDescWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get effect desc for current effect"
      );
    };
    
    guard let filterItemsWrapped = effectDescWrapped.filterItemsWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get filter items"
      );
    };
    
    return filterItemsWrapped;
  };
};
