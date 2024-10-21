//
//  LayerFilterTypeName.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import Foundation
import DGSwiftUtilities

public enum LayerFilterTypeName: String, CaseIterable, HashedStringDecodable {

    case colorBlendingModeMultiply;
    case colorBlendingModeAdd;
    case colorBlendingModeSubtract;
    case colorBlackAndWhite;
    case colorMatrix;
    case colorHueAdjust;
    case saturateColors;
    case brightenColors;
    case contrastColors;
    case invertColors;
    case luminanceCompression;
    case meteor;
    case alphaFromLuminance;
    case bias;
    case distanceField;
    case gaussianBlur;
    case luminanceMap;
    case luminosityCurveMap;
    case averagedColor;
    case lanczosResampling;
    case pageCurl;
    case darkVibrant;
    case lightVibrant;
    case colorMatrixVibrant;
    case variadicBlur;
    
    case alphaThreshold;
    case invertColorsDisplayAware;
    case pairedOpacity;
    
    // case curves;
    // case srl;
    // case edrGain;
    // case edrGainMultiply;
    // case limitAveragePixelLuminance;
    // case lut;
    
    public var encodedString: String {
      switch self {
        case .colorBlendingModeMultiply:
          return "bXVsdGlwbHlDb2xvcg==";
          
        case .colorBlendingModeAdd:
          return "Y29sb3JBZGQ=";
          
        case .colorBlendingModeSubtract:
          return "Y29sb3JTdWJ0cmFjdA==";
          
        case .colorBlackAndWhite:
          return "Y29sb3JNb25vY2hyb21l";
          
        case .colorMatrix:
          return "Y29sb3JNYXRyaXg=";
          
        case .colorHueAdjust:
          return "Y29sb3JIdWVSb3RhdGU=";
          
        case .saturateColors:
          return "Y29sb3JTYXR1cmF0ZQ==";
          
        case .brightenColors:
          return "Y29sb3JCcmlnaHRuZXNz";
          
        case .contrastColors:
          return "Y29sb3JDb250cmFzdA==";
          
        case .invertColors:
          return "Y29sb3JJbnZlcnQ=";
          
        case .luminanceCompression:
          return "Y29tcHJlc3NMdW1pbmFuY2U=";
          
        case .meteor:
          return "bWV0ZW9y";
          
        case .alphaFromLuminance:
          return "bHVtaW5hbmNlVG9BbHBoYQ==";
          
        case .bias:
          return "Ymlhcw==";
          
        case .distanceField:
          return "ZGlzdGFuY2VGaWVsZA==";
          
        case .gaussianBlur:
          return "Z2F1c3NpYW5CbHVy";
          
        case .luminanceMap:
          return "bHVtaW5hbmNlTWFw";
          
        case .luminosityCurveMap:
          return "bHVtaW5hbmNlQ3VydmVNYXA=";
          
        // case .curves:
        //   return "Y3VydmVz";
          
        case .averagedColor:
          return "YXZlcmFnZUNvbG9y";
          
        case .lanczosResampling:
          return "bGFuY3pvc1Jlc2l6ZQ==";
          
        case .pageCurl:
          return "cGFnZUN1cmw=";
          
        case .darkVibrant:
          return "dmlicmFudERhcms=";
          
        case .lightVibrant:
          return "dmlicmFudExpZ2h0";
          
        case .colorMatrixVibrant:
          return "dmlicmFudENvbG9yTWF0cml4";
          
        case .alphaThreshold:
          return "YWxwaGFUaHJlc2hvbGQ=";
          
        case .invertColorsDisplayAware:
          return "Y29sb3JJbnZlcnREaXNwbGF5QXdhcmU=";
          
        case .pairedOpacity:
          return "b3BhY2l0eVBhaXI=";
          
        // case .srl:
        //   return "c3Js";
          
        // case .edrGain:
        //  return "ZWRyR2Fpbg==";
          
        // case .edrGainMultiply:
        //  return "ZWRyR2Fpbk11bHRpcGx5";
          
        case .variadicBlur:
          return "dmFyaWFibGVCbHVy";
          
        // case .limitAveragePixelLuminance:
        //  return "bGltaXRBdmVyYWdlUGl4ZWxMdW1pbmFuY2U=";
          
        // case .lut:
        //  return "bHV0";
      };
  };
};
