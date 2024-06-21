//
//  GaussianBlurFilterWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities


public class GaussianBlurFilterWrapper: ObjectWrapper<
  NSObject,
  GaussianBlurFilterWrapper.EncodedString
> {
  
  public enum EncodedString: HashedStringDecodable {
    case propertyInputRadius;
    
    public var encodedString: String {
      switch self {
        case .propertyInputRadius:
          // inputRadius
          return "aW5wdXRSYWRpdXM=";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  public var inputRadius: CGFloat? {
    get {
      return try? self.getValue(
        forHashedString: .propertyInputRadius,
        type: CGFloat.self
      );
    }
    set {
      try? self.setValue(
        forHashedString: .propertyInputRadius,
        value: newValue
      );
    }
  };
};

