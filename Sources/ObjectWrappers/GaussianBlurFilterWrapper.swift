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
  
  public enum EncodedString: String, HashedStringDecodable {
    case inputRadius;
    
    public var encodedString: String {
      switch self {
        case .inputRadius:
          // inputRadius
          return "aW5wdXRSYWRpdXM=";
      };
    };
  };
  
  public var inputRadius: CGFloat? {
    get {
      let encodedString: EncodedString = .inputRadius;
      guard let decodedString = encodedString.decodedString else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.inputRadius - get",
          "- failed to get decodedString",
          "- encodedString.rawValue:", encodedString.rawValue,
          "- encodedString.encodedString:", encodedString.encodedString
        );
        #endif
        return nil;
      };
    
      guard let wrappedObject = self.wrappedObject,
            let inputRadiusRaw = wrappedObject.value(forKey: decodedString),
            let inputRadius = inputRadiusRaw as? CGFloat
      else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.inputRadius - get",
          "- failed to get inputRadius"
        );
        #endif
        return nil;
      };
      
      return inputRadius;
    }
    set {
      let encodedString: EncodedString = .inputRadius;
      guard let decodedString = encodedString.decodedString else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.inputRadius - set",
          "- failed to get decodedString",
          "- encodedString.rawValue:", encodedString.rawValue,
          "- encodedString.encodedString:", encodedString.encodedString
        );
        #endif
        return;
      };
      
      guard let wrappedObject = self.wrappedObject else {
        #if DEBUG
        print(
          "GaussianBlurFilterWrapper.inputRadius - set",
          "- failed to get wrappedObject"
        );
        #endif
        return;
      };
      
      wrappedObject.setValue(newValue, forKey: decodedString);
    }
  };
};

