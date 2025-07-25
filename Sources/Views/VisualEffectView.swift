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
  
  public var currentBackgroundFilterTypes: [LayerFilterType] = [];
  public var currentForegroundFilterTypes: [LayerFilterType] = [];
  public var currentTintConfig: TintConfig?;
  
  public var isBeingAnimated = false;
  
  internal var _shouldAutomaticallyReApplyEffects: Bool?;
  public var shouldAutomaticallyReApplyEffects: Bool {
    get {
      self._shouldAutomaticallyReApplyEffects ?? true;
    }
    set {
      self._shouldAutomaticallyReApplyEffects = newValue;
    }
  };
  
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
  /// the filters that affect the background
  /// (i.e. `UIVisualEffectView._backgroundHost.contentView`)
  ///
  public var backgroundEffectOpacity: CGFloat? {
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
  
  /// Full Path: `UIVisualEffectView.contentView`
  ///
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
  
  public var doesCurrentlyHaveCustomFilters: Bool {
       self.currentBackgroundFilterTypes.count > 0
    || self.currentForegroundFilterTypes.count > 0;
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
    self.setupObservers();
    
    guard let wrapper = UVEViewWrapper(objectToWrap: self) else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `UVEViewWrapper` instance"
      );
    };
    
    self.wrapper = wrapper;
  };
  
  public convenience init(
    filterTypesForBackground: [LayerFilterType],
    filterTypesForForeground: [LayerFilterType]? = nil,
    shouldSetFiltersUsingEffectDesc: Bool = true
  ) throws {
  
    try self.init(withEffect: UIBlurEffect(style: .regular));
    
    if #available(iOS 13, *),
       shouldSetFiltersUsingEffectDesc
    {
      try self.setBackgroundFiltersViaEffectDesc(
        withFilterTypes: filterTypesForBackground,
        shouldImmediatelyApplyFilter: true
      );
      
      if let filterTypesForForeground = filterTypesForForeground {
        try self.setBackgroundFiltersViaEffectDesc(
          withFilterTypes: filterTypesForForeground,
          shouldImmediatelyApplyFilter: true
        );
      };
      
    } else {
      try self.setBackgroundFiltersViaLayers(
        withFilterTypes: filterTypesForBackground,
        shouldImmediatelyApplyFilter: true
      );
    };
  };
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  deinit {
    self.clearAnimator();
    self.clearObservers();
  }
  
  // MARK: - View Lifecycle
  // ---------------------
  
  public override func layoutSubviews() {
    if #available(iOS 13, *),
       self.window != nil,
       UIApplication.shared.applicationState == .active,
       self.shouldAutomaticallyReApplyEffects,
       !self.isBeingAnimated
    {
      try? self.reapplyEffects();
    };
  };

  // MARK: - Methods
  // ---------------
  
  internal func setupObservers(){
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(Self._handleOnAppWillEnterForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    );
  };
  
  internal func clearObservers(){
    NotificationCenter.default.removeObserver(self);
  }
  
  // MARK: - Event Listeners
  // -----------------------
  
  @objc func _handleOnAppWillEnterForeground() {
    guard #available(iOS 13, *) else {
      return;
    };
    
    let repeatedExecution = RepeatedExecution(
      limit: .maxTimeInterval(1.5),
      debounce: .minTimeInterval(0.1),
      executeBlock: { _ in
        guard self.window != nil,
              self.shouldAutomaticallyReApplyEffects,
              !self.isBeingAnimated,
              UIApplication.shared.applicationState == .active
        else {
          return;
        };
        try? self.reapplyEffects();
      },
      executionEndConditionBlock: { _ in
        UIApplication.shared.applicationState == .active;
      }
    );
    
    repeatedExecution.start();
  };
  
  // MARK: - Public Methods
  // ----------------------

  @available(iOS 13, *)
  public func createFilterMetadataMapForCurrentEffect() throws -> [String: FilterMetadata] {
    let filterEntries =
      try self.getCurrentFilterEntriesFromCurrentBackgroundEffectDescriptor();
      
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
  
  public func setOpacityForTintView(newOpacity: CGFloat){
    guard let wrapper = self.wrapper,
          let tintViewWrapped = wrapper.tintViewWrapped,
          let tintView = tintViewWrapped.wrappedObject
    else {
      return;
    };
    
    tintView.alpha = newOpacity.clamped(min: 0, max: 1);
  };
  
  public func clearTintColorInTintView() throws {
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
  
  public func directlySetTint(forConfig tintConfig: TintConfig) throws {
    guard let tintViewWrapped = self.wrapper?.tintViewWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `tintViewWrapped`"
      );
    };
    
    guard let tintLayerWrapped = tintViewWrapped.layerWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `tintView` layer wrapper"
      );
    };
    
    try tintViewWrapped.setEffectsForView([]);
    try tintConfig.apply(toLayerWrapper: tintLayerWrapped);
  };
  
  // MARK: - Methods for Background Effects
  // --------------------------------------
  
  @available(iOS 13, *)
  public func getCurrentBackgroundEffectDescriptor() throws -> UVEDescriptorWrapper {
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
  
  @available(iOS 13, *)
  public func getCurrentFilterEntriesFromCurrentBackgroundEffectDescriptor() throws -> [UVEFilterEntryWrapper] {
    let effectDescWrapped = try self.getCurrentBackgroundEffectDescriptor();
  
    guard let filterItemsWrapped = effectDescWrapped.filterItemsWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get filter items"
      );
    };
    
    return filterItemsWrapped;
  };
  
  @available(iOS 13, *)
  public func setBackgroundFiltersViaEffectDesc(
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
    
    guard let effectDescCurrentWrapped = try bgHostWrapper.getEffectDescriptorCurrent(),
          effectDescCurrentWrapped.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get current `UVEDescriptorWrapper` instance"
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
        
        try effectDescWrapper.setEffectsForView(values: []);
        try effectDescWrapper.setCurrentOverlays(values: []);
        try effectDescWrapper.setFilterItems(acc);
        
        try bgHostWrapper.setEffectDescriptor(effectDescWrapper);
      };
      
    } else {
      try effectDescCurrentWrapped.setEffectsForView(values: []);
      try effectDescCurrentWrapped.setCurrentOverlays(values: []);
      try effectDescCurrentWrapped.setFilterItems(filterEntryWrappers);
      
      try bgHostWrapper.setEffectDescriptor(effectDescCurrentWrapped);
    };
    
    if shouldImmediatelyApplyFilter {
      try backdropViewWrapped.applyFilterEffectsRequested();
    };
  };
  
  @available(iOS 13, *)
  public func setBackgroundFiltersViaEffectDesc(
    withFilterTypes filterTypes: [LayerFilterType],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
      
    let filterEntriesWrapped = filterTypes.asBackgroundFilterEntriesWrapped;

    try self.setBackgroundFiltersViaEffectDesc(
      withFilterEntryWrappers: filterEntriesWrapped,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
    
    self.currentBackgroundFilterTypes = filterTypes;
  };
  
  public func setBackgroundFiltersViaLayers(
    withFilterTypes filterTypes: [LayerFilterType],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    let filterWrappers = filterTypes.compactMap {
      $0.createFilterWrapper();
    };
    
    try self.setBackgroundFiltersViaLayers(
      withLayerFilterWrappers: filterWrappers,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
    
    self.currentBackgroundFilterTypes = filterTypes;
  };
  
  public func setBackgroundFiltersViaLayers(
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
  public func updateBackgroundFiltersViaEffectDesc(
    withFilterTypes updatedFilterTypes: [LayerFilterType],
    options: EffectDescriptionUpdateOptions? = nil
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
    
    let options = options ?? [.useReferenceEqualityForImageComparison];
    
    let (_, orphanedFilterTypes, filterPairs) = filterItemsWrapped.paired(
      withFilterTypes: updatedFilterTypes,
      shouldUseReferenceEqualityForImageComparison: options.shouldUseReferenceEqualityForImageComparison
    );
    
    if options.shouldAddMissingFilterTypes,
       orphanedFilterTypes.count > 0
    {
      let orphanedFilterTypesConvertedToIdentity = orphanedFilterTypes.compactMap {
        $0.isNotVisibleWhenIdentity ? $0 : nil;
      };
      
      try self.setBackgroundFiltersViaEffectDesc(
        withFilterTypes: orphanedFilterTypesConvertedToIdentity,
        shouldImmediatelyApplyFilter: false
      );
    };
    
    filterPairs.forEach {
      try? $0.filterType.applyTo(
        filterEntryWrapper: $0.filterEntryWrapped,
        identityValuesSource: nil
      );
    };
    
    // overwrite updated elements
    self.currentBackgroundFilterTypes.replaceMatchingElements(
      withOther: updatedFilterTypes,
      shouldUseReferenceEqualityForImageComparison: true
    );
  };
  
  @available(iOS 13, *)
  public func updateMatchingBackgroundFilter(
    with newFilter: LayerFilterType,
    shouldImmediatelyApply: Bool = true
  ) throws {
    
    let filterDescs: [UVEFilterEntryWrapper] =
      try self.getCurrentFilterEntriesFromCurrentBackgroundEffectDescriptor();

    try filterDescs.updateFilterValuesRequested(with: newFilter);
    
    if shouldImmediatelyApply {
      try self.applyRequestedBackgroundFilterEffects();
    };
  };
  
  /// does not support animations, immediately applies the effect
  @available(iOS 13, *)
  public func immediatelyRemoveBackgroundFilters(
    matching nameOfFiltersToRemove: [LayerFilterTypeName]
  ) throws {

    guard let effectDescWrapper = try? self.getCurrentBackgroundEffectDescriptor() else {
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
      let dummyFilterEntry = try dummyFilter.createFilterEntryForBackground();
      
      nextFilterItems.append(dummyFilterEntry);
    };
    
    try self.setBackgroundFiltersViaEffectDesc(
      withFilterEntryWrappers: nextFilterItems,
      shouldImmediatelyApplyFilter: true
    );
  };
  
  @available(iOS 13, *)
  public func immediatelyRemoveAllBackgroundFilters(
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
      try self.applyRequestedBackgroundFilterEffects();
      
      self.currentBackgroundFilterTypes = [];
    };
    
    try? self.wrapper.setBGColorAlphaForBDView(0);
    try? self.wrapper.setOpacityForTint(0);
    
    try self.clearTintColorInTintView();
    
    // reset `CALayer.filters`
    try bgLayerWrapper.setValuesForFilters(newFilters: []);
    try self.viewContentLayerWrapped?.setValuesForFilters(newFilters: []);
  };
  
  public func applyRequestedBackgroundFilterEffects() throws {
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
  
  // MARK: - Methods for Foreground Content
  // --------------------------------------
  
  @available(iOS 13, *)
  public func setForegroundFiltersViaEffectDesc(
    withFilterTypes filterTypes: [LayerFilterType],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
      
    let filterEntriesWrapped = filterTypes.asBackgroundFilterEntriesWrapped;

    try self.setForegroundFiltersViaEffectDesc(
      withFilterEntryWrappers: filterEntriesWrapped,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
    
    self.currentForegroundFilterTypes = filterTypes;
  };
  
  @available(iOS 13, *)
  public func setForegroundFiltersViaEffectDesc(
    withFilterEntryWrappers filterEntryWrappers: [UVEFilterEntryWrapper],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    guard let contentHostWrapped = self.hostForContentWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.hostForContentWrapped`"
      );
    };
    
    if shouldImmediatelyApplyFilter {
      var acc: [UVEFilterEntryWrapper] = [];
      for filterEntryWrapper in filterEntryWrappers {
        acc.append(filterEntryWrapper);
        
        guard let effectDescWrapped = UVEDescriptorWrapper(),
              effectDescWrapped.wrappedObject != nil
        else {
          throw VisualEffectBlurViewError(
            errorCode: .unexpectedNilValue,
            description: "Unable to create `UVEDescriptorWrapper` instance"
          );
        };
        
        try effectDescWrapped.setFilterItems(acc);
        try contentHostWrapped.setEffectDescriptor(effectDescWrapped);
      };
      
    } else {
      guard let effectDescWrapped = try contentHostWrapped.getEffectDescriptorCurrent(),
            effectDescWrapped.wrappedObject != nil
      else {
        throw VisualEffectBlurViewError(
          errorCode: .unexpectedNilValue,
          description: "Unable to create `UVEDescriptorWrapper` instance"
        );
      };
      
      try effectDescWrapped.setFilterItems(filterEntryWrappers);
      try contentHostWrapped.setEffectDescriptor(effectDescWrapped);
    };
    
    if shouldImmediatelyApplyFilter {
      guard let viewContentWrapped = self.viewContentWrapped else {
        throw VisualEffectBlurViewError(
          errorCode: .unexpectedNilValue,
          description: "Unable to get `self.viewContentWrapped`"
        );
      };
    
      try viewContentWrapped.applyFilterEffectsRequested();
    };
  };
  
  /// NOTE: Not all filters are animatable.
  ///
  @available(iOS 13, *)
  public func updateForegroundFiltersViaEffectDesc(
    withFilterTypes updatedFilterTypes: [LayerFilterType],
    options: EffectDescriptionUpdateOptions? = nil
  ) throws {
  
    guard let foregroundHostWrapped = self.hostForContentWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.hostForContentWrapped`"
      );
    };
    
    guard let effectDescWrapped = try? foregroundHostWrapped.getEffectDescriptorCurrent() else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `effectDescWrapper` instance"
      );
    };
    
    guard let filterItemsWrapped = effectDescWrapped.filterItemsWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `filterItemsWrapped` instance"
      );
    };
    
    let options = options ?? [.useReferenceEqualityForImageComparison];

    let (_, orphanedFilterTypes, filterPairs) =
      filterItemsWrapped.paired(withFilterTypes: updatedFilterTypes);
    
    if options.shouldAddMissingFilterTypes,
       orphanedFilterTypes.count > 0
    {
      let orphanedFilterTypesConvertedToIdentity = orphanedFilterTypes.compactMap {
        $0.isNotVisibleWhenIdentity ? $0 : nil;
      };
      
      try self.setForegroundFiltersViaEffectDesc(
        withFilterTypes: orphanedFilterTypesConvertedToIdentity,
        shouldImmediatelyApplyFilter: false
      );
    };
    
    filterPairs.forEach {
      try? $0.filterType.applyTo(
        filterEntryWrapper: $0.filterEntryWrapped,
        identityValuesSource: \.filterValuesIdentityForBackground
      );
    };
    
    // overwrite, replace with updated filters
    self.currentForegroundFilterTypes.replaceMatchingElements(
      withOther: updatedFilterTypes,
      shouldUseReferenceEqualityForImageComparison: true
    );
  };
  
  public func setForegroundFiltersViaLayers(
    withFilterTypes filterTypes: [LayerFilterType],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
  
    let filterWrappers = filterTypes.compactMap {
      $0.createFilterWrapper();
    };
    
    try self.setBackgroundFiltersViaLayers(
      withLayerFilterWrappers: filterWrappers,
      shouldImmediatelyApplyFilter: shouldImmediatelyApplyFilter
    );
    
    self.currentBackgroundFilterTypes = filterTypes;
  };
  
  public func setForegroundFiltersViaLayers(
    withLayerFilterWrappers layerFilterWrappers: [LayerFilterWrapper],
    shouldImmediatelyApplyFilter: Bool = true
  ) throws {
    
    guard let viewContentWrapped = self.viewContentWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `viewContentWrapped`"
      );
    };
    
    guard let viewContentLayerWrapped = self.viewContentLayerWrapped,
          viewContentLayerWrapped.wrappedObject != nil
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.viewContentLayerWrapped`"
      );
    };
    
    let filters = layerFilterWrappers.compactMap {
      $0.wrappedObject;
    };
    
    try viewContentLayerWrapped.setValuesForFilters(newFilters: filters);
    
    if shouldImmediatelyApplyFilter {
      try viewContentWrapped.applyFilterEffectsRequested();
    };
  };
  
  @available(iOS 13, *)
  public func immediatelyRemoveAllForegroundFilters(
    shouldResetEffectDescriptor: Bool = false
  ) throws {
    guard let hostForContentWrapped = self.hostForContentWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.hostForContentWrapped`"
      );
    };
    
    guard let viewContentLayerWrapped = self.viewContentLayerWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.viewContentLayerWrapped`"
      );
    };
        
    if shouldResetEffectDescriptor {
      guard let effectDescWrapper = UVEDescriptorWrapper() else {
        throw VisualEffectBlurViewError(
          errorCode: .unexpectedNilValue,
          description: "Unable to create `effectDescWrapper` instance"
        );
      };
    
      try hostForContentWrapped.setEffectDescriptor(effectDescWrapper);
      try self.applyRequestedForegroundFilterEffects();
      
      self.currentForegroundFilterTypes = [];
    };

    // reset `CALayer.filters`
    try viewContentLayerWrapped.setValuesForFilters(newFilters: []);
  };
  
  public func applyRequestedForegroundFilterEffects() throws {
    guard let wrapper = self.wrapper,
          let foregroundContentWrapped = wrapper.viewContentWrapped
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `wrapper.viewContentWrapped`"
      );
    };
    
    try foregroundContentWrapped.applyFilterEffectsRequested();
  };
  
  // MARK: - Methods for Effects (Common)
  // ------------------------------------
  
  public func applyRequestedFilterEffects() throws {
    try self.applyRequestedBackgroundFilterEffects();
    try self.applyRequestedForegroundFilterEffects();
  };
  
  @available(iOS 13, *)
  public final func baseReapplyEffects() throws {
    if let animatorWrapper = self.animatorWrapper {
      let prevEffectIntensity = animatorWrapper.animator.fractionComplete
      self.clearAnimator();
      
      self.setEffectIntensityViaAnimator(prevEffectIntensity);
      
    } else {
      try self.setBackgroundFiltersViaEffectDesc(
        withFilterTypes: self.currentBackgroundFilterTypes,
        shouldImmediatelyApplyFilter: true
      );
      
      try self.setForegroundFiltersViaEffectDesc(
        withFilterTypes: self.currentForegroundFilterTypes,
        shouldImmediatelyApplyFilter: true
      );
      
      if let currentTintConfig = currentTintConfig {
        try self.directlySetTint(forConfig: currentTintConfig);
      };
      
      try self.applyRequestedFilterEffects();
    };
  };
  
  @available(iOS 13, *)
  public func reapplyEffects() throws {
    try self.baseReapplyEffects();
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
      try self.getCurrentFilterEntriesFromCurrentBackgroundEffectDescriptor();
    
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
        valueStart: currentFilterType.asIdentityForBackground,
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
      self.setOpacityForTintView(
        newOpacity: intensityPercent.clamped(min: 0, max: 1)
      );
    };
    
    if shouldImmediatelyApply {
      try self.applyRequestedBackgroundFilterEffects();
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
        try? self.applyRequestedBackgroundFilterEffects();
        self.setOpacityForTintView(
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
  
  // MARK: - Embedded Types
  // ----------------------
  
  public struct EffectDescriptionUpdateOptions: OptionSet {
    public let rawValue: Int;
    
    public static let addMissingFilterTypes = Self(rawValue: 1 << 0);
    public static let useReferenceEqualityForImageComparison = Self(rawValue: 1 << 3);
    
    public var shouldAddMissingFilterTypes: Bool {
      self.contains(.addMissingFilterTypes);
    };
    
    public var shouldUseReferenceEqualityForImageComparison: Bool {
      self.contains(.useReferenceEqualityForImageComparison);
    };
    
    public init(rawValue: Int) {
      self.rawValue = rawValue;
    };
  };
};
