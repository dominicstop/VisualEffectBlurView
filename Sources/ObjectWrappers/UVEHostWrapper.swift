//
//  UVEHostWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `_UIVisualEffectHost`
/// Old name: `VisualEffectHostWrapper`
///
/// Instance conforms to: `_UIVisualEffectViewSubviewMonitoring`
///
@available(iOS 12, *)
public class UVEHostWrapper: PrivateObjectWrapper<
  NSObject,
  UVEHostWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    /// `contentView`
    case methodGetViewContent;
    
    /// `setCurrentEffectDescriptor`
    case methodSetEffectDescriptor;
    
    /// `currentEffectDescriptor`
    case methodGetEffectDescriptorCurrent;
    
    /// `_applyEffectDescriptor`
    case methodApplyProvidedEffectDescriptor;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectHost
          return "X1VJVmlzdWFsRWZmZWN0SG9zdA==";
        
        case .methodGetViewContent:
          // contentView
          return "Y29udGVudFZpZXc=";
          
        case .methodSetEffectDescriptor:
          // setCurrentEffectDescriptor:
          return "c2V0Q3VycmVudEVmZmVjdERlc2NyaXB0b3I6";
          
        case .methodGetEffectDescriptorCurrent:
          // `currentEffectDescriptor`
          return "Y3VycmVudEVmZmVjdERlc2NyaXB0b3I=";
          
        case .methodApplyProvidedEffectDescriptor:
          // `_applyEffectDescriptor:`
          return "X2FwcGx5RWZmZWN0RGVzY3JpcHRvcjo=";
      };
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  /// `-(UIView *)contentView`
  /// 
  public var viewContent: UIView? {
    try? self.performSelector(
      usingEncodedString: .methodGetViewContent,
      type: UIView.self
    );
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  /// `-(UIView *)contentView`
  ///
  public var viewContentWrapped: UVEBackdropViewWrapper? {
    let result = try? self.performSelector(
      usingEncodedString: .methodGetViewContent,
      type: UIView.self
    );
    
    guard let result = result else {
      return nil;
    };
    
    return .init(objectToWrap: result);
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Selector:
  /// `-(void)setCurrentEffectDescriptor:(_UIVisualEffectDescriptor *)arg1`
  ///
  @available(iOS 13, *)
  public func setEffectDescriptor(
    _ effectDescriptorWrapper: UVEDescriptorWrapper
  ) throws {
    guard let effectDescriptor = effectDescriptorWrapper.wrappedObject else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not get `effectDescriptorWrapper`"
      );
    };
    
    try self.performSelector(
      usingEncodedString: .methodSetEffectDescriptor,
      withArg1: effectDescriptor
    );
  };
  
  /// Selector:
  /// `-(_UIVisualEffectDescriptor *)currentEffectDescriptor;`
  ///
  @available(iOS 13, *)
  public func getEffectDescriptorCurrent() throws -> UVEDescriptorWrapper? {
    let result = try self.performSelector(
      usingEncodedString: .methodGetEffectDescriptorCurrent,
      type: NSObject.self
    );
    
    guard let result = result else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Result of invoked selector is nil"
      );
    };
    
    return .init(objectToWrap: result);
  };
  
  /// Selector:
  /// `-(void)setCurrentEffectDescriptor:(_UIVisualEffectDescriptor *)arg1`
  ///
  @available(iOS 13, *)
  public func applyProvidedEffectDescriptor(
    _ effectDescriptorWrapper: UVEDescriptorWrapper
  ) throws {
    guard let effectDescriptor = effectDescriptorWrapper.wrappedObject else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Could not get `effectDescriptorWrapper`"
      );
    };
    
    try self.performSelector(
      usingEncodedString: .methodSetEffectDescriptor,
      withArg1: effectDescriptor
    );
  };
};
