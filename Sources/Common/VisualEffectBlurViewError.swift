//
//  VisualEffectBlurViewError.swift
//  
//
//  Created by Dominic Go on 7/5/24.
//

import Foundation
import DGSwiftUtilities


public struct VisualEffectBlurViewErrorMetadata: ErrorMetadata {
  public static var domain: String? = "VisualEffectBlurView";
  public static var parentType: String? = nil;
};

public typealias VisualEffectBlurViewError =
  VerboseError<VisualEffectBlurViewErrorMetadata, GenericErrorCode>;
