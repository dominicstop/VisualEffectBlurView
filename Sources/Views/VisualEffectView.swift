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
  public var bgHostWrapper: UVEHostWrapper? {
    self.wrapper.hostForBgWrapped;
  };
  
  /// Old name: `contentViewWrapper`
  /// The view instance that contains the `CALayer` + `CAFilter` items
  ///
  public var viewContentWrapper: UVEBackdropViewWrapper? {
    self.bgHostWrapper?.viewContentWrapped;
  };
  
  /// Old name: `backdropLayerWrapper`
  /// Contains the filter effect that affects the bg views
  ///
  public var bgLayerWrapper: LayerWrapper? {
    self.viewContentWrapper?.bgLayerWrapper
  };
  
  /// Contains the filter effect that only affects the content view
  /// Related: `allowsInPlaceFiltering`, `disableInPlaceFiltering`
  ///
  public var contentLayer: CALayer {
    self.contentView.layer;
  };
  
  public var contentLayerWrapped: LayerWrapper? {
    .init(objectToWrap: self.contentLayer);
  };
  
  /// Old name: `effectDescriptorForCurrentEffectWrapper`
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
  
  /// Shorthand for setting the `UIView.alpha` for `viewContentWrapper` (i.e.
  /// the view that contains the filters
  ///
  public var effectOpacity: CGFloat? {
    get {
      self.viewContentWrapper?.wrappedObject?.alpha;
    }
    set {
      guard let newValue = newValue else {
        return;
      };
      self.viewContentWrapper?.wrappedObject?.alpha = newValue;
    }
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
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  // MARK: - View Lifecycle
  // ----------------------
  
  open override func didMoveToWindow() {
    super.didMoveToWindow();
    
    if let window = self.window,
       let backdropLayerWrapped = self.bgLayerWrapper,
       let backdropLayer = backdropLayerWrapped.wrappedObject
    {
      backdropLayer.setValue(window.screen.scale, forKey: "scale");
    };
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
  
  public func getOtherSubviews() throws -> [UIView] {
    guard let bgLayerWrapper = self.bgLayerWrapper,
          let backdropLayer = bgLayerWrapper.wrappedObject
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgLayerWrapper`"
      );
    };
    
    return self.subviews.filter {
      guard $0.layer !== backdropLayer else {
        return false;
      };
      
      return true;
    };
  };
  
  public func setOpacityForOtherSubviews(newOpacity: CGFloat){
    let otherSubviews = (try? self.getOtherSubviews()) ?? [];
    
    otherSubviews.forEach {
      $0.alpha = newOpacity.clamped(min: 0, max: 1);
    };
  };
  
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
  
    guard let bgHostWrapper = self.bgHostWrapper else {
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
  
  public func removeTintingInSubviews() throws {
    try self.getOtherSubviews().forEach {
      $0.backgroundColor = .clear;
    };
  };
  
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
  
  @available(iOS 13, *)
  public func immediatelyRemoveAllFilters(
    shouldResetEffectDescriptor: Bool = false
  ) throws {
    guard let bgHostWrapper = self.bgHostWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
    guard let bgLayerWrapper = self.bgLayerWrapper else {
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
    try self.contentLayerWrapped?.setValuesForFilters(newFilters: []);
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
  public func getCurrentEffectDescriptor() throws -> UVEDescriptorWrapper {
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
    
    return effectDescWrapped;
  };
  
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
