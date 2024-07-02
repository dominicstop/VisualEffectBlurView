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
@available(iOS 12, *)
public class UVEHostWrapper: PrivateObjectWrapper<
  NSObject,
  UVEHostWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    /// `contentView`
    case getterViewContent;
    
    /// `setCurrentEffectDescriptor`
    case methodSetCurrentEffectMetadata;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectHost
          return "X1VJVmlzdWFsRWZmZWN0SG9zdA==";
        
        case .getterViewContent:
          // contentView
          return "Y29udGVudFZpZXc=";
          
        case .methodSetCurrentEffectMetadata:
          // setCurrentEffectDescriptor:
          return "c2V0Q3VycmVudEVmZmVjdERlc2NyaXB0b3I6";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
    /// `-(UIView *)contentView`
  public var viewContentWrapped: UVEBackdropViewWrapper? {
    let result = try? self.performSelector(
      usingEncodedString: .getterViewContent,
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
  public func setCurrentEffectMetadata(
    _ effectDescriptorWrapper: UVEDescriptorWrapper
  ) throws {
    guard let effectDescriptor = effectDescriptorWrapper.wrappedObject else {
      #if DEBUG
      print(
        "VisualEffectBackgroundHostViewWrapper.setCurrentEffectMetadata",
        "- failed to get getEffectMetadata"
      );
      #endif
      return;
    };
    
    try self.performSelector(
      usingEncodedString: .methodSetCurrentEffectMetadata,
      withArg1: effectDescriptor
    );
  };
};
