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
};
