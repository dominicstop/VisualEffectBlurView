//
//  LayerFilterTypeName.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import Foundation
import DGSwiftUtilities

public enum LayerFilterTypeName: CaseIterable, HashedStringDecodable {
    case colorMultiply;
    case addColor;
    case subtractColor;
    case blackAndWhiteColor;
    case matrixRGBA;
    case shiftHueColor;
    case saturateColor;
    case brightness;
    case contrast;
    case invertColors;
    case luminanceCompression;
    case meteor;
    case alphaFromLuminance;
    case bias;
    case distanceField;
    case gaussianBlur;
    case luminosityMap;
    case luminosityCurveMap;
    case curves;
    case averagedColor;
    case lanczosResampling;
    case paperCurl;
    case darkVibrant;
    case lightVibrant;
    case vibrantMatrixRGBA;
    
    case alphaThreshold;
    case invertColorsSmart;
    case pairedOpacity;
    //case srl;
    case gainUsingEDR;
    case gainUsingEDRMultiply;
    case variadicBlur;
    case avgPixelLuminosityWithLimit;
    case lut;
    
    public var encodedString: String {
      switch self {
        case .colorMultiply:
          return "bXVsdGlwbHlDb2xvcg==";
          
        case .addColor:
          return "Y29sb3JBZGQ=";
          
        case .subtractColor:
          return "Y29sb3JTdWJ0cmFjdA==";
          
        case .blackAndWhiteColor:
          return "Y29sb3JNb25vY2hyb21l";
          
        case .matrixRGBA:
          return "Y29sb3JNYXRyaXg=";
          
        case .shiftHueColor:
          return "Y29sb3JIdWVSb3RhdGU=";
          
        case .saturateColor:
          return "Y29sb3JTYXR1cmF0ZQ==";
          
        case .brightness:
          return "Y29sb3JCcmlnaHRuZXNz";
          
        case .contrast:
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
          
        case .luminosityMap:
          return "bHVtaW5hbmNlTWFw";
          
        case .luminosityCurveMap:
          return "bHVtaW5hbmNlQ3VydmVNYXA=";
          
        case .curves:
          return "Y3VydmVz";
          
        case .averagedColor:
          return "YXZlcmFnZUNvbG9y";
          
        case .lanczosResampling:
          return "bGFuY3pvc1Jlc2l6ZQ==";
          
        case .paperCurl:
          return "cGFnZUN1cmw=";
          
        case .darkVibrant:
          return "dmlicmFudERhcms=";
          
        case .lightVibrant:
          return "dmlicmFudExpZ2h0";
          
        case .vibrantMatrixRGBA:
          return "dmlicmFudENvbG9yTWF0cml4";
          
        case .alphaThreshold:
          return "YWxwaGFUaHJlc2hvbGQ=";
          
        case .invertColorsSmart:
          return "Y29sb3JJbnZlcnREaXNwbGF5QXdhcmU=";
          
        case .pairedOpacity:
          return "b3BhY2l0eVBhaXI=";
          
        // case .srl:
        //  return "c3Js";
          
        case .gainUsingEDR:
          return "ZWRyR2Fpbg==";
          
        case .gainUsingEDRMultiply:
          return "ZWRyR2Fpbk11bHRpcGx5";
          
        case .variadicBlur:
          return "dmFyaWFibGVCbHVy";
          
        case .avgPixelLuminosityWithLimit:
          return "bGltaXRBdmVyYWdlUGl4ZWxMdW1pbmFuY2U=";
          
        case .lut:
          return "bHV0";
          
      };
  };
};
