//
//  UVESubviewWrapper.swift
//  
//
//  Created by Dominic Go on 12/18/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `_UIVisualEffectSubview`
///
/// Conforms to: `_UIVisualEffectViewParticipating` (wrapper:
/// `UVEViewParticipatingWrapper`)
///
public class UVESubviewWrapper: PrivateObjectWrapper<
  UIView,
  UVESubviewWrapper.EncodedString
> {
  
  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectSubview
          return "X1VJVmlzdWFsRWZmZWN0U3Vidmlldw==";
      };
    };
  };
  
  /// MARK: - `_UIVisualEffectSubview+_UIVisualEffectViewParticipating`
  /// ----------------------------------------------------------------
  
  public lazy var asEffectViewParticipatingWrapped: UVEViewParticipatingWrapper? = {
    .init(objectToWrap: self);
  }();
  
  /// Selectors:
  /// `@property (assign,nonatomic) BOOL disableGroupFiltering;`
  /// `-(BOOL)disableGroupFiltering;`
  ///
  public func getShouldDisableFilteringTheGroup() throws -> Bool {
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
  public func setFilterIsEnabled(_ isDisabled: Bool) throws {
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
  public func getEffectsForView() throws -> Bool {
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
  public func setEffectsForView(_ effects: Array<NSObject>) throws {
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
  public func getCurrentFilters() throws -> Bool {
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
  public func setCurrentFilters(_ effects: Array<NSObject>) throws {
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
  public func getViewContained() throws -> Bool {
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
  public func setViewContained(_ effects: Array<NSObject>) throws {
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
  public func applyFilterEffectsRequested() throws {
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
  public func applyFilterEffectsIdentity() throws {
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
  public func applyViewEffectsIdentity() throws {
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
  public func applyViewEffectsRequested() throws {
    guard let effectViewParticipatingWrapped = self.asEffectViewParticipatingWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not wrap instance in `UVEViewParticipatingWrapper`"
      );
    };
    
    try effectViewParticipatingWrapped.applyViewEffectsRequested();
  };
};
