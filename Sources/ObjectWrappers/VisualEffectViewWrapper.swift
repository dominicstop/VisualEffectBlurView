//
//  VisualEffectViewWrapper.swift
//  
//
//  Created by Dominic Go on 6/18/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `UIVisualEffectView`
public class VisualEffectViewWrapper: ObjectWrapper<
  UIVisualEffectView,
  VisualEffectViewWrapper.EncodedString
> {
  
  public enum EncodedString: String, HashedStringDecodable {
    case backgroundHost;
    case setCurrentEffectDescriptor;
    case effectDescriptorForEffects;
    
    public var encodedString: String {
      switch self {
        case .backgroundHost:
          // _backgroundHost
          return "X2JhY2tncm91bmRIb3N0";
          
        case .setCurrentEffectDescriptor:
          // setCurrentEffectDescriptor:
          return "c2V0Q3VycmVudEVmZmVjdERlc2NyaXB0b3I6";
          
        case .effectDescriptorForEffects:
          // _effectDescriptorForEffects:usage:
          return "X2VmZmVjdERlc2NyaXB0b3JGb3JFZmZlY3RzOnVzYWdlOg==";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  /// Selector:
  /// `-(id)_backgroundHost`
  @available(iOS 12, *)
  public var backgroundHostWrapper: VisualEffectHostWrapper? {
    let result = try? self.performSelector(
      usingEncodedString: .backgroundHost,
      type: NSObject.self
    );
    
    guard let result = result else {
      return nil;
    };
    
    return .init(objectToWrap: result);
  };

  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Selector:
  /// `_effectDescriptorForEffects:(id)arg1 usage:(long long)arg2`
  ///
  @available(iOS 13, *)
  public func effectDescriptor(
    forEffects effects: [UIVisualEffect],
    usage: Bool
  ) throws -> VisualEffectDescriptorWrapper? {
  
    let result = try self.performSelector(
      usingEncodedString: .effectDescriptorForEffects,
      withArg1: effects,
      withArg2: usage ? 1 : 0,
      type: AnyObject.self
    );
    
    return .init(
      objectToWrap: result as AnyObject
    );
  };
};
