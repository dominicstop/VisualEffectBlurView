//
//  UVEViewParticipatingWrapper.swift
//  
//
//  Created by Dominic Go on 12/19/24.
//

import UIKit
import DGSwiftUtilities


/// Protocol: `_UIVisualEffectViewParticipating`
///
/// Classes that conform:
/// * `_UIVisualEffectSubview` (`UVEViewParticipatingWrapper`),
/// * `_UIVisualEffectContentView` (`UVEContentViewWrapper`),
/// * `_UIVisualEffectBackdropView` (`VisualEffectBackdropViewWrapper`)
///
public class UVEViewParticipatingWrapper: ObjectWrapper<
  UIView,
  UVEViewParticipatingWrapper.EncodedString
> {

  public enum EncodedString: HashedStringDecodable {
    
    /// Selectors:
    /// `@property (assign,nonatomic) BOOL disableGroupFiltering;`
    /// `-(BOOL)disableGroupFiltering;`
    /// `-(void)setDisableGroupFiltering:(BOOL)arg1 ;`
    ///
    case propertyGetterShouldDisableFilteringTheGroup;
    case propertySetterShouldDisableFilteringTheGroup;
    
    /// Selectors:
    /// `@property (nonatomic,copy) NSArray * viewEffects;
    /// `-(NSArray *)viewEffects;`
    /// `-(void)setViewEffects:(NSArray *)arg1`
    ///
    case propertyGetterEffectsForView;
    case propertySetterEffectsForView;
    
    /// Selectors:
    /// `@property (nonatomic,copy) NSArray * filters;`
    /// `-(NSArray *)filters;`
    /// `-(void)setFilters:(NSArray *)arg1`
    ///
    case propertyGetterCurrentFilters;
    case propertySetterCurrentFilters;
    
    /// Selectors:
    /// `@property (nonatomic,retain) UIView*<_UIVisualEffectViewParticipating> containedView;`
    /// `-(void)setContainedView:(id)arg1;`
    /// `-(UIView*<_UIVisualEffectViewParticipating>)containedView;`
    ///
    case propertyGetterViewContained;
    case propertySetterViewContained;
    
    /// `-(void)applyRequestedFilterEffects;`
    case methodApplyFilterEffectsRequested
    
    /// `-(void)applyIdentityFilterEffects;`
    case methodApplyFilterEffectsIdentity
    
    /// `-(void)applyIdentityViewEffects;`
    case methodApplyViewEffectsIdentity;
    
    /// `-(void)applyRequestedViewEffects;`
    case methodApplyViewEffectsRequested;
    
    public var encodedString: String {
      switch self {
        case .propertyGetterShouldDisableFilteringTheGroup:
          /// `disableGroupFiltering`
          return "ZGlzYWJsZUdyb3VwRmlsdGVyaW5n";
          
        case .propertySetterShouldDisableFilteringTheGroup:
          /// `setDisableGroupFiltering:`
          return "c2V0RGlzYWJsZUdyb3VwRmlsdGVyaW5nOg==";
          
        case .propertyGetterEffectsForView:
          /// `viewEffects`
          return "dmlld0VmZmVjdHM=";
          
        case .propertySetterEffectsForView:
          /// `setViewEffects:`
          return "c2V0Vmlld0VmZmVjdHM6";
        
        case .propertyGetterCurrentFilters:
          /// `filters`
          return "ZmlsdGVycw==";
          
        case .propertySetterCurrentFilters:
          /// `setFilters:`
          return "c2V0RmlsdGVyczo=";
          
        case .propertyGetterViewContained:
          /// `containedView`
          return "Y29udGFpbmVkVmlldw==";
          
        case .propertySetterViewContained:
          /// `setContainedView:`
          return "c2V0Q29udGFpbmVkVmlldzo=";
          
        case .methodApplyFilterEffectsRequested:
          /// `applyRequestedFilterEffects`
          return "YXBwbHlSZXF1ZXN0ZWRGaWx0ZXJFZmZlY3Rz";

        case .methodApplyFilterEffectsIdentity:
          /// `applyIdentityFilterEffects`
          return "YXBwbHlJZGVudGl0eUZpbHRlckVmZmVjdHM=";

        case .methodApplyViewEffectsIdentity:
          /// `applyIdentityViewEffects`
          return "YXBwbHlJZGVudGl0eVZpZXdFZmZlY3Rz";

        case .methodApplyViewEffectsRequested:
          /// `applyRequestedViewEffects`
          return "YXBwbHlSZXF1ZXN0ZWRWaWV3RWZmZWN0cw==";
      };
    };
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Selectors:
  /// `@property (assign,nonatomic) BOOL disableGroupFiltering;`
  /// `-(BOOL)disableGroupFiltering;`
  ///
  public func getShouldDisableFilteringTheGroup() throws -> Bool {
    let value = try self.getValue(
      forHashedString: .propertyGetterShouldDisableFilteringTheGroup,
      type: Bool.self
    );
    
    guard let value = value else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value for property"
      );
    };
    
    return value;
  };
  
  /// Selectors:
  /// `@property (assign,nonatomic) BOOL disableGroupFiltering;`
  /// `-(void)setDisableGroupFiltering:(BOOL)arg1 ;`
  ///
  public func setFilterIsEnabled(_ isDisabled: Bool) throws {
    try self.setValue(
      forHashedString: .propertyGetterShouldDisableFilteringTheGroup,
      value: isDisabled
    );
  };
  
  /// Selectors:
  /// `@property (nonatomic,copy) NSArray * viewEffects;
  /// `-(NSArray *)viewEffects;`
  ///
  /// Array of `_UITintColorViewEntry`
  ///
  public func getEffectsForView() throws -> Bool {
    let value = try self.getValue(
      forHashedString: .propertyGetterEffectsForView,
      type: Bool.self
    );
    
    guard let value = value else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value for property"
      );
    };
    
    return value;
  };
  
  /// Selectors:
  /// `@property (nonatomic,copy) NSArray * viewEffects;
  /// `-(void)setViewEffects:(NSArray *)arg1`
  ///
  /// Array of `_UITintColorViewEntry`
  ///
  public func setEffectsForView(_ effects: Array<NSObject>) throws {
    try self.setValue(
      forHashedString: .propertyGetterEffectsForView,
      value: effects
    );
  };
    
  /// Selectors:
  /// `@property (nonatomic,copy) NSArray * filters;`
  /// `-(NSArray *)filters;`
  ///
  /// Array of `_UIVisualEffectFilterEntry`
  ///
  public func getCurrentFilters() throws -> Bool {
    let value = try self.getValue(
      forHashedString: .propertyGetterCurrentFilters,
      type: Bool.self
    );
    
    guard let value = value else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value for property"
      );
    };
    
    return value;
  };
  
  /// Selectors:
  /// `@property (nonatomic,copy) NSArray * filters;`
  /// `-(void)setFilters:(NSArray *)arg1`
  ///
  public func setCurrentFilters(_ effects: Array<NSObject>) throws {
    try self.setValue(
      forHashedString: .propertyGetterCurrentFilters,
      value: effects
    );
  };
  
  /// Selectors:
  /// `@property (nonatomic,retain) UIView*<_UIVisualEffectViewParticipating> containedView;`
  /// `-(UIView*<_UIVisualEffectViewParticipating>)containedView;`
  ///
  public func getViewContained() throws -> Bool {
    let value = try self.getValue(
      forHashedString: .propertyGetterViewContained,
      type: Bool.self
    );
    
    guard let value = value else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value for property"
      );
    };
    
    return value;
  };
  
  /// Selectors:
  /// `@property (nonatomic,retain) UIView*<_UIVisualEffectViewParticipating> containedView;`
  /// `-(void)setContainedView:(id)arg1;`
  ///
  public func setViewContained(_ effects: Array<NSObject>) throws {
    try self.setValue(
      forHashedString: .propertyGetterViewContained,
      value: effects
    );
  };
  
  /// Selector:
  /// `-(void)applyRequestedFilterEffects;`
  ///
  public func applyFilterEffectsRequested() throws {
    try self.performSelector(
      usingEncodedString: .methodApplyFilterEffectsRequested
    );
  };
  
  /// Selector:
  /// `-(void)applyIdentityFilterEffects;`
  ///
  public func applyFilterEffectsIdentity() throws {
    try self.performSelector(
      usingEncodedString: .methodApplyFilterEffectsIdentity
    );
  };
  
  /// Selector:
  /// `-(void)applyIdentityViewEffects;`
  ///
  public func applyViewEffectsIdentity() throws {
    try self.performSelector(
      usingEncodedString: .methodApplyViewEffectsIdentity
    );
  };
  
  /// Selector:
  /// `-(void)applyRequestedViewEffects;`
  ///
  public func applyViewEffectsRequested() throws {
    try self.performSelector(
      usingEncodedString: .methodApplyViewEffectsRequested
    );
  };
};

/// MARK: - `UVEViewParticipatingWrappable`
/// --------------------------------------

public protocol UVEViewParticipatingWrappable: ValueInjectable {
  
  var asEffectViewParticipatingWrapped: UVEViewParticipatingWrapper? { get };
};

/// MARK: - `UVEViewParticipatingWrappable+Default`
/// ----------------------------------------------

public extension UVEViewParticipatingWrappable {
  
  /// Selectors:
  /// `@property (assign,nonatomic) BOOL disableGroupFiltering;`
  /// `-(BOOL)disableGroupFiltering;`
  ///
  func getShouldDisableFilteringTheGroup() throws -> Bool {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    return try effectViewParticipatingWrapped.getShouldDisableFilteringTheGroup();
  };
  
  /// Selectors:
  /// `@property (assign,nonatomic) BOOL disableGroupFiltering;`
  /// `-(void)setDisableGroupFiltering:(BOOL)arg1 ;`
  ///
  func setFilterIsEnabled(_ isDisabled: Bool) throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.setFilterIsEnabled(isDisabled);
  };
  
  /// Selectors:
  /// `@property (nonatomic,copy) NSArray * viewEffects;
  /// `-(NSArray *)viewEffects;`
  ///
  /// Array of `_UITintColorViewEntry`
  ///
  func getEffectsForView() throws -> Bool {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    return try effectViewParticipatingWrapped.getEffectsForView();
  };
  
  /// Selectors:
  /// `@property (nonatomic,copy) NSArray * viewEffects;
  /// `-(void)setViewEffects:(NSArray *)arg1`
  ///
  /// Array of `_UITintColorViewEntry`
  ///
  func setEffectsForView(_ effects: Array<NSObject>) throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.setEffectsForView(effects);
  };
    
  /// Selectors:
  /// `@property (nonatomic,copy) NSArray * filters;`
  /// `-(NSArray *)filters;`
  ///
  /// Array of `_UIVisualEffectFilterEntry`
  ///
  func getCurrentFilters() throws -> Bool {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    return try effectViewParticipatingWrapped.getCurrentFilters();
  };
  
  /// Selectors:
  /// `@property (nonatomic,copy) NSArray * filters;`
  /// `-(void)setFilters:(NSArray *)arg1`
  ///
  func setCurrentFilters(_ effects: Array<NSObject>) throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.setCurrentFilters(effects);
  };
  
  /// Selectors:
  /// `@property (nonatomic,retain) UIView*<_UIVisualEffectViewParticipating> containedView;`
  /// `-(UIView*<_UIVisualEffectViewParticipating>)containedView;`
  ///
  func getViewContained() throws -> Bool {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    return try effectViewParticipatingWrapped.getViewContained();
  };
  
  /// Selectors:
  /// `@property (nonatomic,retain) UIView*<_UIVisualEffectViewParticipating> containedView;`
  /// `-(void)setContainedView:(id)arg1;`
  ///
  func setViewContained(_ effects: Array<NSObject>) throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.setViewContained(effects);
  };
  
  /// Selector:
  /// `-(void)applyRequestedFilterEffects;`
  ///
  func applyFilterEffectsRequested() throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.applyFilterEffectsRequested();
  };
  
  /// Selector:
  /// `-(void)applyIdentityFilterEffects;`
  ///
  func applyFilterEffectsIdentity() throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.applyFilterEffectsIdentity();
  };
  
  /// Selector:
  /// `-(void)applyIdentityViewEffects;`
  ///
  func applyViewEffectsIdentity() throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.applyViewEffectsIdentity();
  };
  
  /// Selector:
  /// `-(void)applyRequestedViewEffects;`
  ///
  func applyViewEffectsRequested() throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.applyViewEffectsRequested();
  };
};
