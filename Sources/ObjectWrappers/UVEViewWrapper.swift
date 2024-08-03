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
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  /// Selector:
  /// `-(id)_backgroundHost`
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
  @available(iOS 12, *)
  public var hostForContent: NSObject? {
    return try? self.performSelector(
      usingEncodedString: .getterHostForContent,
      type: NSObject.self
    );
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
};
