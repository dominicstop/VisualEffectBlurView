//
//  VisualEffectView.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import UIKit
import DGSwiftUtilities


open class VisualEffectView: UIVisualEffectView {
  
  public var wrapper: UVEViewWrapper!;
  public var currentFilterTypes: [LayerFilterType] = [];
  
  /// Old name: `shouldOnlyShowBackdropLayer`
  public var shouldOnlyShowBgLayer: Bool = false {
    willSet {
      guard let bgLayerWrapper = self.backgroundLayerWrapped,
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
  
  open override var effect: UIVisualEffect? {
    get {
      super.effect;
    }
    set {
      super.effect = newValue;
      
      guard #available(iOS 13, *),
            let filterMetadataMap = try? self.createFilterMetadataMapForCurrentEffect()
      else {
        self._filterMetadataMapForCurrentEffect = nil;
        return;
      };
      
      self._filterMetadataMapForCurrentEffect = filterMetadataMap;
    }
  };

  /// Shorthand for setting the `UIView.alpha` for the subview that contains
  /// the filters that affect the background (i.e. `UIVisualEffectView._backgroundHost.contentView`)
  ///
  public var effectOpacity: CGFloat? {
    get {
      self.wrapper.backgroundViewWrapped?.wrappedObject?.alpha;
    }
    set {
      guard let newValue = newValue else {
        return;
      };
      
      self.wrapper.backgroundViewWrapped?.wrappedObject?.alpha = newValue;
    }
  };
  
  public var backgroundLayerSamplingSizeScale: CGFloat? {
    didSet {
      self.applyBackgroundLayerSamplingSizeScaleIfNeeded();
    }
  };
  
  // MARK: Computed Properties - Wrappers
  // ------------------------------------
  
  /// Type: `_UIVisualEffectHost`
  /// Property: `UIVisualEffectView._backgroundHost`
  ///
  public var hostForBackgroundWrapped: UVEHostWrapper? {
    self.wrapper?.hostForBgWrapped;
  };
  
  /// Type: `_UIVisualEffectBackdropView`
  /// Property: `_UIVisualEffectHost.contentView`
  /// Full Path: `UIVisualEffectView._backgroundHost.contentView`
  ///
  public var hostForBackgroundContentViewWrapped: UVEBackdropViewWrapper? {
    self.wrapper?.backgroundViewWrapped;
  };
  
  /// Type: `UICABackdropLayer` - `CALayer` subclass
  /// Property: `_UIVisualEffectBackdropView.backdropLayer`
  /// Full Path: `UIVisualEffectView._backgroundHost.contentView.backdropLayer`
  ///
  /// The "backdrop" that composites the views/layers behind it, and applies
  /// filters to it (e.g. blurring the views behind the content view).
  ///
  public var backgroundLayerWrapped: LayerBackgroundWrapper? {
    self.wrapper?.backgroundViewWrapped?.backgroundLayerWrapped;
  };
  
  /// Type: `_UIVisualEffectHost`
  /// Property: `UIVisualEffectView._contentHost`
  ///
  public var hostForContentWrapped: UVEHostWrapper? {
    guard let wrapper = self.wrapper else {
      return nil;
    };
  
    if let contentHost = wrapper.hostForContentWrapped {
      return contentHost;
    };
    
    try? wrapper.setViewForContent(self.contentView);
    return wrapper.hostForContentWrapped;
  };
  
  /// Type: `_UIVisualEffectContentView`
  /// Property: `_UIVisualEffectHost.contentView`
  ///
  /// Full Path:
  /// * `UIVisualEffectView._contentHost.contentView`
  /// * `UIVisualEffectView.contentView`
  ///
  public var viewContentWrapped: UVEContentViewWrapper? {
    self.wrapper?.viewContentWrapped;
  };
  
  /// Type: `_UIVisualEffectContentView`
  /// Full Path:
  /// * `UIVisualEffectView._contentHost.contentView.layer`
  /// * `UIVisualEffectView.contentView.layer`
  ///
  public var viewContentLayerWrapped: LayerWrapper? {
    .init(objectToWrap: self.contentView.layer);
  };
  
  /// Contains the filter effect that only affects the content view
  /// Related: `allowsInPlaceFiltering`, `disableInPlaceFiltering`
  ///
  public var viewContentLayer: CALayer {
    self.contentView.layer;
  };
  
  /// Selector:
  /// `_effectDescriptorForEffects:(id)arg1 usage:(long long)arg2`
  ///
  @available(iOS 13, *)
  public var currentEffectMetadata: UVEDescriptorWrapper? {
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
  
  // MARK: - Properties
  // ------------------
  
  public var animatorWrapper: ViewPropertyAnimatorWrapper?;
  
  private var _filterMetadataMapForCurrentEffect: Dictionary<String, FilterMetadata>?;
  public var filterMetadataMapForCurrentEffect: Dictionary<String, FilterMetadata>? {
    if let cached = self._filterMetadataMapForCurrentEffect {
      return cached;
    };
    
    guard #available(iOS 13, *),
          let filterMetadataMap = try? self.createFilterMetadataMapForCurrentEffect()
    else {
      return nil;
    };
    
    self._filterMetadataMapForCurrentEffect = filterMetadataMap;
    return filterMetadataMap;
  };

  // MARK: - Init
  // ------------
  
  public init(withEffect effect: UIVisualEffect?) throws {
    super.init(effect: effect);
    
    guard let wrapper = UVEViewWrapper(objectToWrap: self) else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `UVEViewWrapper` instance"
      );
    };
    
    self.wrapper = wrapper;
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
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };

  // MARK: - Methods
  // ---------------
  
  @available(iOS 13, *)
  public func createFilterMetadataMapForCurrentEffect() throws -> [String: FilterMetadata] {
    let filterEntries =
      try self.getCurrentFilterEntriesFromCurrentEffectDescriptor();
      
    var filterMetadataMap: [String: FilterMetadata] = [:];
    
    filterEntries.forEach {
      guard let filterName = $0.filterKind else {
        return;
      };
      
      guard let filterMetadata: FilterMetadata = .init(fromWrapper: $0) else {
        return;
      };
      
      filterMetadataMap[filterName] = filterMetadata;
    };
      
    return filterMetadataMap;
  };
  
  public func applyBackgroundLayerSamplingSizeScaleIfNeeded(){
    
    guard let nextScale = self.backgroundLayerSamplingSizeScale,
          let currentScale = wrapper.backgroundLayerSamplingSizeScale,
          currentScale != nextScale,
          let wrapper = self.wrapper
    else {
      return;
    };
    
    wrapper.backgroundLayerSamplingSizeScale = nextScale;
  };
  
  // TODO: Rename: `setOpacityForTintView`
  public func setOpacityForOtherSubviews(newOpacity: CGFloat){
    guard let wrapper = self.wrapper,
          let tintViewWrapped = wrapper.tintViewWrapped,
          let tintView = tintViewWrapped.wrappedObject
    else {
      return;
    };
    
    tintView.alpha = newOpacity.clamped(min: 0, max: 1);
  };
  
  // TODO: Rename: `clearTintColorInTintView`
  public func removeTintingInSubviews() throws {
    guard let wrapper = self.wrapper,
          let tintViewWrapped = wrapper.tintViewWrapped,
          let tintView = tintViewWrapped.wrappedObject
    else {
      return;
    };
    
    tintView.backgroundColor = .clear;
    
    // just in case
    tintView.tintColor = nil;
  };
  
  // MARK: - Methods for Background Effects
  // --------------------------------------
  
  // TODO: Rename: `getCurrentBackgroundEffectDescriptor`
  @available(iOS 13, *)
  public func getCurrentEffectDescriptor() throws -> UVEDescriptorWrapper {
    guard let bgHostWrapper = self.hostForBackgroundWrapped else {
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
    
    return effectDescWrapped;
  };
  
  // TODO: Rename: `getCurrentFilterEntriesFromCurrentBackgroundEffectDescriptor`
  @available(iOS 13, *)
  public func getCurrentFilterEntriesFromCurrentEffectDescriptor() throws -> [UVEFilterEntryWrapper] {
    let effectDescWrapped = try self.getCurrentEffectDescriptor();
  
    guard let filterItemsWrapped = effectDescWrapped.filterItemsWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get filter items"
      );
    };
    
    return filterItemsWrapped;
  };
  
  // TODO: Rename: `setBackgroundFiltersViaEffectDesc`
  @available(iOS 13, *)
  public func setFiltersViaEffectDesc(
    withFilterEntryWrappers filterEntryWrappers: [UVEFilterEntryWrapper],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    guard let wrapper = self.wrapper,
          let backdropViewWrapped = wrapper.backgroundViewWrapped
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `backdropViewWrapped`"
      );
    };
  
    guard let bgHostWrapper = self.hostForBackgroundWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
    if shouldImmediatelyApplyFilter {
      var acc: [UVEFilterEntryWrapper] = [];
      for filterEntryWrapper in filterEntryWrappers {
        acc.append(filterEntryWrapper);
        
        guard let effectDescWrapper = UVEDescriptorWrapper(),
              effectDescWrapper.wrappedObject != nil
        else {
          throw VisualEffectBlurViewError(
            errorCode: .unexpectedNilValue,
            description: "Unable to create `UVEDescriptorWrapper` instance"
          );
        };
        
        try effectDescWrapper.setFilterItems(acc);
        try bgHostWrapper.setEffectDescriptor(effectDescWrapper);
      };
      
    } else {
      guard let effectDescWrapper = try bgHostWrapper.getEffectDescriptorCurrent(),
            effectDescWrapper.wrappedObject != nil
      else {
        throw VisualEffectBlurViewError(
          errorCode: .unexpectedNilValue,
          description: "Unable to create `UVEDescriptorWrapper` instance"
        );
      };
      
      try effectDescWrapper.setFilterItems(filterEntryWrappers);
      try bgHostWrapper.setEffectDescriptor(effectDescWrapper);
    };
    
    if shouldImmediatelyApplyFilter {
      try backdropViewWrapped.applyFilterEffectsRequested();
    };
  };
  
  // TODO: Rename: `setBackgroundFiltersViaEffectDesc`
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
  
  // TODO: Rename: `setBackgroundFiltersViaLayers`
  public func setFiltersViaLayers(
    withLayerFilterWrappers layerFilterWrappers: [LayerFilterWrapper],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
    
    guard let wrapper = self.wrapper,
          let backdropViewWrapped = wrapper.backgroundViewWrapped
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `backdropViewWrapped`"
      );
    };
    
    guard let bgLayerWrapper = backdropViewWrapped.backgroundLayerWrapped,
          bgLayerWrapper.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgLayerWrapper`"
      );
    };
    
    let filters = layerFilterWrappers.compactMap {
      $0.wrappedObject;
    };
    
    try bgLayerWrapper.setValuesForFilters(newFilters: filters);
    
    if shouldImmediatelyApplyFilter {
      try backdropViewWrapped.applyFilterEffectsRequested();
    };
  };
  
  // TODO: Rename: `setBackgroundFiltersViaLayers`
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
  
  // TODO: Rename: `updateBackgroundFiltersViaEffectDesc`
  /// NOTE: Not all filters are animatable (see caveats below)
  ///
  /// * In order for the filter to animate, it has to be already set
  ///
  /// * this means that filters that don't have lerp-able values cannot
  ///   be animated, as there is nothing to update.
  ///
  /// * Also, since the filter has to be already been applied, filters
  ///   that aren't "invisible" when set to identity cannot be smoothly
  ///   animated in/out.
  ///
  @available(iOS 13, *)
  public func updateCurrentFiltersViaEffectDesc(
    withFilterTypes updatedFilterTypes: [LayerFilterType],
    shouldAddMissingFilterTypes: Bool = false
  ) throws {
  
    guard let bgHostWrapper = self.hostForBackgroundWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
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

    var filterTypesWithMatches: [LayerFilterType] = [];
    
    typealias FilterPair = (
      filterType: LayerFilterType,
      filterEntryWrapped: UVEFilterEntryWrapper
    );
    
    let filterTypesPaired: [FilterPair] = filterItemsWrapped.compactMap { wrappedFilterItem in
      let match = updatedFilterTypes.first {
        $0.decodedFilterName == wrappedFilterItem.filterKind;
      };
      
      guard let match = match else {
        return nil;
      };
      
      filterTypesWithMatches.append(match);
      return (match, wrappedFilterItem);
    };
    
    let orphanedFilterTypes = updatedFilterTypes.filter { filter in
      let match = filterTypesPaired.first {
        filter.decodedFilterName == $0.filterType.decodedFilterName;
      };
      
      return match == nil;
    };
    
    if shouldAddMissingFilterTypes,
       orphanedFilterTypes.count > 0
    {
      let orphanedFilterTypesConvertedToIdentity = orphanedFilterTypes.compactMap {
        $0.isNotVisibleWhenIdentity ? $0 : nil;
      };
      
      try self.setFiltersViaEffectDesc(
        withFilterTypes: orphanedFilterTypesConvertedToIdentity,
        shouldImmediatelyApplyFilter: false
      );
    };
    
    filterTypesPaired.forEach {
      try? $0.filterType.applyTo(
        filterEntryWrapper: $0.filterEntryWrapped,
        shouldSetValuesIdentity: true
      );
    };
  };
  
  // TODO: Rename: `updateMatchingBackgroundFilter`
  @available(iOS 13, *)
  public func updateMatchingFilter(
    with newFilter: LayerFilterType,
    shouldImmediatelyApply: Bool = true
  ) throws {
    
    let filterDescs: [UVEFilterEntryWrapper] =
      try self.getCurrentFilterEntriesFromCurrentEffectDescriptor();

    try filterDescs.updateFilterValuesRequested(with: newFilter);
    
    if shouldImmediatelyApply {
      try self.applyRequestedFilterEffects();
    };
  };
  
  // TODO: Rename: `immediatelyRemoveBackgroundFilters`
  /// does not support animations, immediately applies the effect
  @available(iOS 13, *)
  public func immediatelyRemoveFilters(
    matching nameOfFiltersToRemove: [LayerFilterTypeName]
  ) throws {

    guard let effectDescWrapper = try? self.getCurrentEffectDescriptor() else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `effectDescWrapper` instance"
      );
    };
    
    guard let currentFilterItems = effectDescWrapper.filterItemsWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `filterItemsWrapped` instance"
      );
    };
    
    var nextFilterItems = currentFilterItems.filter { filterItem in
      let hasMatch = nameOfFiltersToRemove.contains {
        $0.decodedString == filterItem.filterKind;
      };
      
      return !hasMatch;
    };
    
    if nextFilterItems.isEmpty {
      let dummyFilter: LayerFilterType = .saturateColors(amount: 1);
      let dummyFilterEntry = try dummyFilter.createFilterEntry();
      
      nextFilterItems.append(dummyFilterEntry);
    };
    
    try self.setFiltersViaEffectDesc(
      withFilterEntryWrappers: nextFilterItems,
      shouldImmediatelyApplyFilter: true
    );
  };
  
  // TODO: Rename: `immediatelyRemoveAllBackgroundFilters`
  @available(iOS 13, *)
  public func immediatelyRemoveAllFilters(
    shouldResetEffectDescriptor: Bool = false
  ) throws {
    guard let bgHostWrapper = self.hostForBackgroundWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
    guard let bgLayerWrapper = self.backgroundLayerWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgLayerWrapper`"
      );
    };
        
    if shouldResetEffectDescriptor {
      guard let effectDescWrapper = UVEDescriptorWrapper() else {
        throw VisualEffectBlurViewError(
          errorCode: .unexpectedNilValue,
          description: "Unable to create `effectDescWrapper` instance"
        );
      };
    
      try bgHostWrapper.setEffectDescriptor(effectDescWrapper);
      try self.applyRequestedFilterEffects();
      
      self.currentFilterTypes = [];
    };
    
    try? self.wrapper.setBGColorAlphaForBDView(0);
    try? self.wrapper.setOpacityForTint(0);
    
    try self.removeTintingInSubviews();
    
    // reset `CALayer.filters`
    try bgLayerWrapper.setValuesForFilters(newFilters: []);
    try self.viewContentLayerWrapped?.setValuesForFilters(newFilters: []);
  };
  
  // TODO: Rename: `applyRequestedBackgroundFilterEffects`
  public func applyRequestedFilterEffects() throws {
    guard let wrapper = self.wrapper,
          let backdropViewWrapped = wrapper.backgroundViewWrapped
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `backdropViewWrapped`"
      );
    };
    
    try backdropViewWrapped.applyFilterEffectsRequested();
  };
  
  // MARK: - Methods - Animation Related
  // -----------------------------------
  
  @available(iOS 13, *)
  public func setEffectIntensityViaEffectDescriptor(
    intensityPercent: CGFloat,
    shouldImmediatelyApply: Bool = true,
    shouldAdjustOpacityForOtherSubviews: Bool = true
  ) throws {
    
    let filterItemsWrapped =
      try self.getCurrentFilterEntriesFromCurrentEffectDescriptor();
    
    guard let filterMetadataMap = self.filterMetadataMapForCurrentEffect else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get filterMetadataMap"
      );
    };
    
    filterItemsWrapped.enumerated().forEach {
      guard let currentFilterType: LayerFilterType =
              .init(fromWrapper: $0.element),
              
            let currentFilterName = currentFilterType.decodedFilterName,
            let associatedFilterMetadata = filterMetadataMap[currentFilterName],
            let filterTypeEnd = associatedFilterMetadata.filterTypeParsed
      else {
        return;
      };
      
      
      let filterTypeInterpolated = try? LayerFilterType.lerp(
        valueStart: currentFilterType.identity,
        valueEnd: filterTypeEnd,
        percent: intensityPercent,
        easing: .linear
      );
      
      guard let filterTypeInterpolated = filterTypeInterpolated else {
        return;
      };
      
      let filterValuesRequested =
        NSDictionary(dictionary: filterTypeInterpolated.filterValuesRequested);
      
      try? $0.element.setFilterValuesRequested(filterValuesRequested);
    };
    
    if shouldAdjustOpacityForOtherSubviews {
      self.setOpacityForOtherSubviews(
        newOpacity: intensityPercent.clamped(min: 0, max: 1)
      );
    };
    
    if shouldImmediatelyApply {
      try self.applyRequestedFilterEffects();
    };
  };
  
  @available(iOS 13, *)
  public func createSetEffectIntensityAnimationBlock(
    nextEffectIntensity: CGFloat,
    prevEffectIntensity: CGFloat?
  ) throws -> (
    start: () -> Void,
    end: () -> Void
  ) {
  
    try self.setEffectIntensityViaEffectDescriptor(
      intensityPercent: nextEffectIntensity,
      shouldImmediatelyApply: false,
      shouldAdjustOpacityForOtherSubviews: false
    );
    
    return (
      start: {
        try? self.setEffectIntensityViaEffectDescriptor(
          intensityPercent: prevEffectIntensity ?? 1,
          shouldImmediatelyApply: true,
          shouldAdjustOpacityForOtherSubviews: true
        );
      },
      end: {
        try? self.applyRequestedFilterEffects();
        self.setOpacityForOtherSubviews(
          newOpacity: nextEffectIntensity
        );
      }
    );
  };
  
  // does not support animations
  public func setEffectIntensityViaAnimator(_ percent: CGFloat){
    let animatorWrapper: ViewPropertyAnimatorWrapper = {
      if let animatorWrapper = self.animatorWrapper {
        return animatorWrapper;
      };
      
      let currentEffect = self.effect;
      let animatorWrapper: ViewPropertyAnimatorWrapper = .init(forView: self) {
        $0.effect = currentEffect;
      };
      
      self.effect = nil;
      
      self.animatorWrapper = animatorWrapper;
      return animatorWrapper;
    }();
    
    animatorWrapper.setFractionComplete(forPercent: percent);
  };
  
  public func clearAnimator(){
    guard let animatorWrapper = self.animatorWrapper else { return };
    animatorWrapper.clear();
    self.animatorWrapper = nil;
  };
  
  // MARK: - Helpers
  // ---------------
  
  public func _debugRecursivelyPrintSubviews(){
    let subviews = self.recursivelyGetAllSubviews;
    
    subviews.enumerated().forEach {
      print(
        "\(self.className).\(#function)",
        "\n - Subview: \($0.offset) of \(subviews.count - 1)",
        "\n - className:", $0.element.className,
        "\n - parentName:", $0.element.superview?.className ?? "N/A",
        "\n - subviews.count:", $0.element.subviews.count,
        "\n - layer:", $0.element.layer.debugDescription,
        "\n"
      );
    };
  };
};
