//
//  VisualEffectHostWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `_UIVisualEffectHost`
/// 
@available(iOS 12, *)
public class VisualEffectHostWrapper: PrivateObjectWrapper<
  NSObject,
  VisualEffectHostWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    case getterContentView;
    case methodGetCurrentEffectDescriptor;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectHost
          return "X1VJVmlzdWFsRWZmZWN0SG9zdA==";
          
                  
        case .getterContentView:
          // contentView
          return "Y29udGVudFZpZXc=";
          
        case .methodGetCurrentEffectDescriptor:
          // setCurrentEffectDescriptor:
          return "c2V0Q3VycmVudEVmZmVjdERlc2NyaXB0b3I6";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
    /// `-(UIView *)contentView`
  public var contentViewWrapper: VisualEffectBackdropViewWrapper? {
    let result = try? self.performSelector(
      usingEncodedString: .getterContentView,
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
  public func setCurrentEffectDescriptor(
    _ effectDescriptorWrapper: VisualEffectDescriptorWrapper
  ) throws {
    guard let effectDescriptor = effectDescriptorWrapper.wrappedObject else {
      #if DEBUG
      print(
        "VisualEffectBackgroundHostViewWrapper.setCurrentEffectDescriptor",
        "- failed to get getEffectMetadata"
      );
      #endif
      return;
    };
    
    try self.performSelector(
      usingEncodedString: .methodGetCurrentEffectDescriptor,
      withArg1: effectDescriptor
    );
  };
};
