//
//  LayerFilterTypeName.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import Foundation
import DGSwiftUtilities

public enum LayerFilterTypeName: CaseIterable, HashedStringDecodable {
    case multiplyColor;
    case colorAdd;
    case colorSubtract;
    case colorMonochrome;
    case colorMatrix;
    case colorHueRotate;
    case colorSaturate;
    case colorBrightness;
    case colorContrast;
    case colorInvert;
    case compressLuminance;
    case meteor;
    case luminanceToAlpha;
    case bias;
    case distanceField;
    case gaussianBlur;
    case luminanceMap;
    case luminanceCurveMap;
    case curves;
    case averageColor;
    case lanczosResize;
    case pageCurl;
    case vibrantDark;
    case vibrantLight;
    case vibrantColorMatrix;
    
    public var encodedString: String {
      switch self {
        case .multiplyColor:
          return "bXVsdGlwbHlDb2xvcg==";
          
        case .colorAdd:
          return "Y29sb3JBZGQ=";
          
        case .colorSubtract:
          return "Y29sb3JTdWJ0cmFjdA==";
          
        case .colorMonochrome:
          return "Y29sb3JNb25vY2hyb21l";
          
        case .colorMatrix:
          return "Y29sb3JNYXRyaXg=";
          
        case .colorHueRotate:
          return "Y29sb3JIdWVSb3RhdGU=";
          
        case .colorSaturate:
          return "Y29sb3JTYXR1cmF0ZQ==";
          
        case .colorBrightness:
          return "Y29sb3JCcmlnaHRuZXNz";
          
        case .colorContrast:
          return "Y29sb3JDb250cmFzdA==";
          
        case .colorInvert:
          return "Y29sb3JJbnZlcnQ=";
          
        case .compressLuminance:
          return "Y29tcHJlc3NMdW1pbmFuY2U=";
          
        case .meteor:
          return "bWV0ZW9y";
          
        case .luminanceToAlpha:
          return "bHVtaW5hbmNlVG9BbHBoYQ==";
          
        case .bias:
          return "Ymlhcw==";
          
        case .distanceField:
          return "ZGlzdGFuY2VGaWVsZA==";
          
        case .gaussianBlur:
          return "Z2F1c3NpYW5CbHVy";
          
        case .luminanceMap:
          return "bHVtaW5hbmNlTWFw";
          
        case .luminanceCurveMap:
          return "bHVtaW5hbmNlQ3VydmVNYXA=";
          
        case .curves:
          return "Y3VydmVz";
          
        case .averageColor:
          return "YXZlcmFnZUNvbG9y";
          
        case .lanczosResize:
          return "bGFuY3pvc1Jlc2l6ZQ==";
          
        case .pageCurl:
          return "cGFnZUN1cmw=";
          
        case .vibrantDark:
          return "dmlicmFudERhcms=";
          
        case .vibrantLight:
          return "dmlicmFudExpZ2h0";
          
        case .vibrantColorMatrix:
          return "dmlicmFudENvbG9yTWF0cml4";
      };
    };
  };
