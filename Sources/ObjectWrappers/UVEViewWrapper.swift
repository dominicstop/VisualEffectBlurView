//
//  UVEViewWrapper.swift
//  
//
//  Created by Dominic Go on 6/18/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `UIVisualEffectView`
/// Old name: `VisualEffectViewWrapper`
///
public class UVEViewWrapper: ObjectWrapper<
  UIVisualEffectView,
  UVEViewWrapper.EncodedString
> {
  
  public enum EncodedString: String, HashedStringDecodable {
    /// `backgroundEffects`
    case propertyEffectsForBg;
    
    /// `contentEffects`
    case getterEffectsForContent;
    
    /// `_backgroundHost`
    case getterHostForBg;
    
    /// `_contentHost`
    case getterHostForContent;
    
    case methodSetCurrentEffectMetadata;
    case methodGetEffectMetadata;
    
    /// `_setBackdropViewBackgroundColorAlpha:`
    case methodSetBGColorAlphaForBDView;
    
    /// `_setTintOpacity:`
    case methodSetOpacityForTint;
    
    #if DEBUG
    /// `_debug`
    case methodDebug;
    
    /// `_whatsWrongWithThisEffect`
    case methodWhatsWrongWithThisEffect;
    #endif
    
    public var encodedString: String {
      switch self {
        case .propertyEffectsForBg:
          // backgroundEffects
          return "YmFja2dyb3VuZEVmZmVjdHM=";
          
        case .getterEffectsForContent:
          // contentEffects
          return "Y29udGVudEVmZmVjdHM=";
      
        case .getterHostForBg:
          // _backgroundHost
          return "X2JhY2tncm91bmRIb3N0";
          
        case .getterHostForContent:
          // _contentHost
          return "X2NvbnRlbnRIb3N0";
          
        case .methodSetCurrentEffectMetadata:
          // setCurrentEffectDescriptor:
          return "c2V0Q3VycmVudEVmZmVjdERlc2NyaXB0b3I6";
          
        case .methodGetEffectMetadata:
          // _effectDescriptorForEffects:usage:
          return "X2VmZmVjdERlc2NyaXB0b3JGb3JFZmZlY3RzOnVzYWdlOg==";
          
        case .methodSetBGColorAlphaForBDView:
          // _setBackdropViewBackgroundColorAlpha:
          return "X3NldEJhY2tkcm9wVmlld0JhY2tncm91bmRDb2xvckFscGhhOg==";
          
        case .methodSetOpacityForTint:
          // _setTintOpacity:
          return "X3NldFRpbnRPcGFjaXR5Og==";
          
        #if DEBUG
        case .methodDebug:
          // _debug
          return "X2RlYnVn";
          
        case .methodWhatsWrongWithThisEffect:
          // _whatsWrongWithThisEffect
          return "X3doYXRzV3JvbmdXaXRoVGhpc0VmZmVjdA==";
        #endif
      };
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  /// Selector:
  /// `-(id)_contentHost`
  ///
  @available(iOS 12, *)
  public var hostForContent: NSObject? {
    return try? self.performSelector(
      usingEncodedString: .getterHostForContent,
      type: NSObject.self
    );
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  /// Selector:
  /// `-(id)_backgroundHost`
  ///
  /// Type: `_UIVisualEffectHost`
  /// Property: `UIVisualEffectView._backgroundHost`
  ///
  @available(iOS 12, *)
  public var hostForBgWrapped: UVEHostWrapper? {
    let result = try? self.performSelector(
      usingEncodedString: .getterHostForBg,
      type: NSObject.self
    );
    
    guard let result = result else {
      return nil;
    };
    
    return .init(objectToWrap: result);
  };
  
  
  /// Selector:
  /// `-(id)_contentHost`
  ///
  /// Type: `_UIVisualEffectHost`
  /// Property: `UIVisualEffectView._contentHost`
  ///
  /// * Contains a ref to: `_UIVisualEffectContentView` (i.e.
  ///  `UIVisualEffectView.contentView`)
  ///
  public var hostForContentWrapped: UVEHostWrapper? {
    guard let instance = self.hostForContent else {
      return nil;
    };
    
    return .init(objectToWrap: instance);
  };
  
  /// Selector:
  /// `@property (nonatomic,copy) NSArray * backgroundEffects`
  ///
  public var effectsForBg: NSArray? {
    return try? self.performSelector(
      usingEncodedString: .propertyEffectsForBg,
      type: NSArray.self
    );
  };
  
  /// Selector:
  /// `@property (nonatomic,copy) NSArray * contentEffects`
  ///
  public var effectsForContent: NSArray? {
    return try? self.performSelector(
      usingEncodedString: .getterEffectsForContent,
      type: NSArray.self
    );
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Selector:
  /// `_effectDescriptorForEffects:(id)arg1 usage:(long long)arg2`
  ///
  @available(iOS 13, *)
  public func getEffectMetadata(
    forEffects effects: [UIVisualEffect],
    usage: Bool
  ) throws -> UVEDescriptorWrapper? {
  
    let result = try self.performSelector(
      usingEncodedString: .methodGetEffectMetadata,
      withArg1: effects,
      withArg2: usage ? 1 : 0,
      type: AnyObject.self
    );
    
    return .init(
      objectToWrap: result as AnyObject
    );
  };
  
  /// Selector:
  /// `-(void)_setBackdropViewBackgroundColorAlpha:(double)arg1`
  ///
  @available(iOS 13, *)
  public func setBGColorAlphaForBDView(_ colorAlpha: CGFloat) throws {
    try self.performSelector(
      usingEncodedString: .methodSetBGColorAlphaForBDView,
      withArg1: colorAlpha
    );
  };
  
  public func setOpacityForTint(_ opacity: CGFloat) throws {
    try self.performSelector(
      usingEncodedString: .methodSetOpacityForTint,
      withArg1: opacity
    );
  };
  
  #if DEBUG
  /// Selector:
  /// `-(id)_debug`
  ///
  public func debug() throws -> String {
    let result = try self.performSelector(
      usingEncodedString: .methodDebug,
      type: NSString.self
    );
    
    guard let result = result else {
      throw GenericError(
        errorCode: .unexpectedNilValue
      );
    };
    
    return result as String;
  };
  
  /// Selector:
  /// `-(id)_whatsWrongWithThisEffect`
  ///
  public func whatsWrongWithThisEffect() throws -> String {
    let result = try self.performSelector(
      usingEncodedString: .methodWhatsWrongWithThisEffect,
      type: NSString.self
    );
    
    guard let result = result else {
      throw GenericError(
        errorCode: .unexpectedNilValue
      );
    };
    
    return result as String;
  };
  #endif
  
    
  // MARK: - Helper/Utility Properties
  // ---------------------------------
  
  
  /// Type: `_UIVisualEffectContentView` (superclass: `_UIVisualEffectSubview`)
  /// Property: `UIVisualEffectView.contentView`
  /// Also in: `UIVisualEffectView.subviews`
  ///
  public var viewContentWrapped: UVEContentViewWrapper? {
    guard let instance = self.wrappedObject else {
      return nil;
    };
    
    return .init(objectToWrap: instance);
  };
  
  /// Type: `_UIVisualEffectBackdropView` (superclass: `_UIVisualEffectSubview`)
  /// Full Path: `UIVisualEffectView._backgroundHost.contentView`
  /// Also in: `UIVisualEffectView.subviews`
  ///
  /// The view instance that contains the `CALayer` + `CAFilter` items
  ///
  public var backdropViewWrapped: UVEBackdropViewWrapper? {
    guard let bgHostContent = self.hostForBgWrapped?.viewContent else {
      return nil;
    };
    
    return .init(objectToWrap: bgHostContent);
  };
  
  
  /// Property: `UIVisualEffectView.subviews`
  ///
  /// * Subview Types: `_UIVisualEffectContentView`,
  ///   `_UIVisualEffectBackdropView`, `_UIVisualEffectSubview`
  ///
  ///   * These subviews are a subclass of: `_UIVisualEffectSubview`
  ///
  ///   * Observation: for a `UIBlurEffect` w/ `.regular`, all three subviews
  ///     will be available, but sometimes only 1 or 2 subviews are present.
  ///
  ///   * Observation: When using a `UIVibrancyEffect`, there will only be 1
  ///     subview present: `_UIVisualEffectContentView`
  ///
  ///     * The other views still exist, but they can only be accessed via
  ///       their host objects (`_UIVisualEffectHost.contentView`),
  ///       e.g. `UIVisualEffectView._contentHost`, and
  ///       `UIVisualEffectView._backgroundHost`.
  ///
  ///
  /// * `_UIVisualEffectContentView`:
  ///   * When no effect is active, the only subview will be:
  ///     `_UIVisualEffectContentView`.
  ///
  ///   * The `_UIVisualEffectContentView` is the same as:
  ///     `UIVisualEffectView.contentView`.
  ///
  ///   * this view is always at the front since it contains the content
  ///
  ///
  /// * `_UIVisualEffectBackdropView`:
  ///   * Usually the first subview, since it's the "backdrop" that contains
  ///     the effect snapshot + filters
  ///
  ///   * The `_UIVisualEffectBackdropView.layer` type is: `UICABackdropLayer`,
  ///     and the same as: `UIVisualEffectView._backgroundHost.contentView.layer`
  ///
  ///
  /// * `_UIVisualEffectSubview`:
  ///   * Just the plain base class, not specialized; sometimes not added (e.g.
  ///     when using `.systemUltraThinMaterial`, `.systemThickMaterial`, etc).
  ///
  ///   * It's usually in the middle, because it seems to act as a tinting
  ///     layer; it has a background color, and `layer.compositingFilter)` is
  ///     set to: `sourceOver`
  ///
  ///     * the value is not an object, it's just a plain string.
  ///
  ///
  public var effectSubviewsWrapped: [UVESubviewWrapper]? {
    guard let instance = self.wrappedObject else {
      return nil;
    };
    
    return instance.subviews.compactMap {
      .init(objectToWrap: $0);
    };
  };
};
