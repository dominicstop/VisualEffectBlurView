//
//  UVEContentView.swift
//  
//
//  Created by Dominic Go on 12/19/24.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `_UIVisualEffectContentView`
///
/// Subclass of: `_UIVisualEffectSubview`
/// * Wrapper: `UVESubviewWrapper`.
///
/// Inherits conformance to: `_UIVisualEffectViewParticipating`
/// * Wrapper: `UVEViewParticipatingWrappable`
///
public class UVEContentViewWrapper:
  PrivateObjectWrapper<UIView, UVEContentViewWrapper.EncodedString>,
  UVEViewParticipatingWrappable
{
  
  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectContentView
          return "X1VJVmlzdWFsRWZmZWN0Q29udGVudFZpZXc=";
      };
    };
  };
  
  public lazy var asEffectViewParticipatingWrapped: UVEViewParticipatingWrapper? = {
    guard let wrappedObject = self.wrappedObject else {
      return nil;
    };
    
    return .init(objectToWrap: wrappedObject);
  }();
};
