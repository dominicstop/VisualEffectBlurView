//
//  ColorMatrixRGBAPreset.swift
//  
//
//  Created by Dominic Go on 6/25/24.
//

import UIKit

public enum ColorMatrixRGBAPreset: String, CaseIterable {
  case preset01;
  case preset02;
  case preset03;
  case preset04;
  case preset05;
  case preset06;
  case preset07;
  case preset08;
  case preset09;
  case preset10;
  case preset11;
  case preset12;
  case preset13;
  case preset14;
  case preset15;
  
  @available(iOS 13.0, *)
  public init?(
    forBlurEffectStyle blurEffectStyle: UIBlurEffect.Style,
    vibrancyEffectStyle: UIVibrancyEffectStyle
  ) {
    switch (blurEffectStyle, vibrancyEffectStyle){
      case(.systemUltraThinMaterial     , .secondaryLabel): fallthrough;
      case(.systemThinMaterial          , .secondaryLabel): fallthrough;
      case(.systemUltraThinMaterialLight, .secondaryLabel): fallthrough;
      case(.systemThinMaterialLight     , .secondaryLabel):
        self = .preset01;
        
      case(.systemUltraThinMaterial     , .tertiaryLabel): fallthrough;
      case(.systemThinMaterial          , .tertiaryLabel): fallthrough;
      case(.systemUltraThinMaterialLight, .tertiaryLabel): fallthrough;
      case(.systemThinMaterialLight     , .tertiaryLabel):
        self = .preset02;
      
      case(.systemThinMaterial          , .secondaryFill  ): fallthrough;
      case(.systemUltraThinMaterial     , .secondaryFill  ): fallthrough;
      case(.systemMaterial              , .secondaryFill  ): fallthrough;
      case(.systemThickMaterial         , .secondaryFill  ): fallthrough;
      case(.systemThickMaterialLight    , .secondaryFill  ): fallthrough;
      case(.systemUltraThinMaterialLight, .secondaryFill  ): fallthrough;
      case(.systemThinMaterialLight     , .secondaryFill  ): fallthrough;
      case(.systemMaterialLight         , .secondaryFill  ): fallthrough;
      case(.systemChromeMaterial        , .secondaryFill  ): fallthrough;
      case(.systemChromeMaterialLight   , .secondaryFill  ): fallthrough;
      case(.systemUltraThinMaterial     , .quaternaryLabel): fallthrough;
      case(.systemThinMaterial          , .quaternaryLabel): fallthrough;
      case(.systemMaterial              , .quaternaryLabel): fallthrough;
      case(.systemThickMaterial         , .quaternaryLabel): fallthrough;
      case(.systemChromeMaterial        , .quaternaryLabel): fallthrough;
      case(.systemUltraThinMaterialLight, .quaternaryLabel): fallthrough;
      case(.systemThinMaterialLight     , .quaternaryLabel): fallthrough;
      case(.systemMaterialLight         , .quaternaryLabel): fallthrough;
      case(.systemThickMaterialLight    , .quaternaryLabel): fallthrough;
      case(.systemChromeMaterialLight   , .quaternaryLabel):
        self = .preset03;
        
      
      case(.systemUltraThinMaterial     , .fill): fallthrough;
      case(.systemThinMaterial          , .fill): fallthrough;
      case(.systemMaterial              , .fill): fallthrough;
      case(.systemThickMaterial         , .fill): fallthrough;
      case(.systemUltraThinMaterialLight, .fill): fallthrough;
      case(.systemThinMaterialLight     , .fill): fallthrough;
      case(.systemMaterialLight         , .fill): fallthrough;
      case(.systemThickMaterialLight    , .fill):
        self = .preset04;
        
      case(.systemUltraThinMaterial     , .tertiaryFill): fallthrough;
      case(.systemThinMaterial          , .tertiaryFill): fallthrough;
      case(.systemMaterial              , .tertiaryFill): fallthrough;
      case(.systemThickMaterial         , .tertiaryFill): fallthrough;
      case(.systemChromeMaterial        , .tertiaryFill): fallthrough;
      case(.systemUltraThinMaterialLight, .tertiaryFill): fallthrough;
      case(.systemThinMaterialLight     , .tertiaryFill): fallthrough;
      case(.systemMaterialLight         , .tertiaryFill): fallthrough;
      case(.systemThickMaterialLight    , .tertiaryFill): fallthrough;
      case(.systemChromeMaterialLight   , .tertiaryFill):
        self = .preset05;
        
      case(.systemUltraThinMaterial     , .separator    ): fallthrough;
      case(.systemThinMaterial          , .separator    ): fallthrough;
      case(.systemMaterial              , .separator    ): fallthrough;
      case(.systemThickMaterial         , .separator    ): fallthrough;
      case(.systemChromeMaterial        , .separator    ): fallthrough;
      case(.systemUltraThinMaterialLight, .separator    ): fallthrough;
      case(.systemThinMaterialLight     , .separator    ): fallthrough;
      case(.systemMaterialLight         , .separator    ): fallthrough;
      case(.systemThickMaterialLight    , .separator    ): fallthrough;
      case(.systemChromeMaterialLight   , .separator    ): fallthrough;
      case(.systemMaterial              , .tertiaryLabel): fallthrough;
      case(.systemThickMaterial         , .tertiaryLabel): fallthrough;
      case(.systemChromeMaterial        , .tertiaryLabel): fallthrough;
      case(.systemMaterialLight         , .tertiaryLabel): fallthrough;
      case(.systemThickMaterialLight    , .tertiaryLabel): fallthrough;
      case(.systemChromeMaterialLight   , .tertiaryLabel):
        self = .preset06;
        
      case(.systemMaterial           , .secondaryLabel): fallthrough;
      case(.systemThickMaterial      , .secondaryLabel): fallthrough;
      case(.systemChromeMaterial     , .secondaryLabel): fallthrough;
      case(.systemMaterialLight      , .secondaryLabel): fallthrough;
      case(.systemThickMaterialLight , .secondaryLabel): fallthrough;
      case(.systemChromeMaterialLight, .secondaryLabel):
        self = .preset07;
        
      case(.systemChromeMaterial     , .fill): fallthrough;
      case(.systemChromeMaterialLight, .fill):
        self = .preset08;
        
      case(.systemUltraThinMaterialDark, .secondaryLabel): fallthrough;
      case(.systemThinMaterialDark     , .secondaryLabel):
        self = .preset09;
        
      case(.systemUltraThinMaterialDark, .fill): fallthrough;
      case(.systemThinMaterialDark     , .fill): fallthrough;
      case(.systemMaterialDark         , .fill): fallthrough;
      case(.systemThickMaterialDark    , .fill):
        self = .preset10;
        
      case(.systemUltraThinMaterialDark, .quaternaryLabel): fallthrough;
      case(.systemThinMaterialDark     , .quaternaryLabel): fallthrough;
      case(.systemMaterialDark         , .quaternaryLabel): fallthrough;
      case(.systemThickMaterialDark    , .quaternaryLabel): fallthrough;
      case(.systemChromeMaterialDark   , .quaternaryLabel): fallthrough;
      case(.systemUltraThinMaterialDark, .secondaryFill  ): fallthrough;
      case(.systemThinMaterialDark     , .secondaryFill  ): fallthrough;
      case(.systemMaterialDark         , .secondaryFill  ): fallthrough;
      case(.systemThickMaterialDark    , .secondaryFill  ): fallthrough;
      case(.systemChromeMaterialDark   , .secondaryFill  ):
        self = .preset11;
        
      case(.systemUltraThinMaterialDark, .tertiaryFill): fallthrough;
      case(.systemThinMaterialDark     , .tertiaryFill): fallthrough;
      case(.systemMaterialDark         , .tertiaryFill): fallthrough;
      case(.systemThickMaterialDark    , .tertiaryFill): fallthrough;
      case(.systemChromeMaterialDark   , .tertiaryFill):
        self = .preset12;
        
      case(.systemUltraThinMaterialDark, .separator    ): fallthrough;
      case(.systemThinMaterialDark     , .separator    ): fallthrough;
      case(.systemMaterialDark         , .separator    ): fallthrough;
      case(.systemThickMaterialDark    , .separator    ): fallthrough;
      case(.systemChromeMaterialDark   , .separator    ): fallthrough;
      case(.systemMaterialDark         , .tertiaryLabel): fallthrough;
      case(.systemThickMaterialDark    , .tertiaryLabel): fallthrough;
      case(.systemChromeMaterialDark   , .tertiaryLabel):
        self = .preset13;
        
      case(.systemMaterialDark      , .secondaryLabel): fallthrough;
      case(.systemThickMaterialDark , .secondaryLabel): fallthrough;
      case(.systemChromeMaterialDark, .secondaryLabel):
        self = .preset14;
        
      case(.systemChromeMaterialDark, .fill):
        self = .preset15;

      default:
        return nil;
    };
  };
  
  public var colorMatrix: ColorMatrixRGBA {
    switch self {
      case .preset01:
        return .init(
          m11:  0.9362975, m12: -0.3218643, m13: -0.0619332 , m14: 0.0, m15: 0.04874998,
          m21: -0.1635529, m22:  0.7786505, m23: -0.06259762, m24: 0.0, m25: 0.04874998,
          m31: -0.1642173, m32: -0.3208677, m33:  1.037585  , m34: 0.0, m35: 0.04875004,
          m41:  0.0      , m42:  0.0      , m43:  0.0       , m44: 1.0, m45: 0.0
        );
      
      case .preset02:
        return .init(
          m11:  0.922559  , m12: -0.152471, m13: -0.029088  , m14: 0.0, m15: 0.01950002,
          m21: -0.07730501, m22:  0.847997, m23: -0.02969201, m24: 0.0, m25: 0.0195,
          m31: -0.07790902, m32: -0.151565, m33:  0.9704739 , m34: 0.0, m35: 0.01950002,
          m41:  0.0       , m42:  0.0     , m43:  0.0       , m44: 1.0, m45: 0.0
        );
        
      case .preset03:
        return .init(
           m11:  1.23555  , m12: -0.3234631, m13: -0.06208679, m14: 0.0, m15: 0.0,
           m21: -0.1642596, m22:  1.077192 , m23: -0.06293241, m24: 0.0, m25: 0.0,
           m31: -0.1651052, m32: -0.3221948, m33:  1.3373    , m34: 0.0, m35: 0.0,
           m41:  0.0      , m42:  0.0      , m43:  0.0       , m44: 1.0, m45: 0.0
        );
        
      case .preset04:
        return .init(
           m11:  1.514125, m12: -0.954751, m13: -0.184374, m14: 0.0, m15: 0.0625    ,
           m21: -0.485603, m22:  1.046185, m23: -0.185582, m24: 0.0, m25: 0.06249997,
           m31: -0.486811, m32: -0.952939, m33:  1.81475 , m34: 0.0, m35: 0.0625    ,
           m41:  0.0     , m42:  0.0     , m43:  0.0     , m44: 1.0, m45: 0.0
        );
      
      case .preset05:
        return .init(
          m11:  1.177642  , m12: -0.1426014, m13: -0.02704049, m14: 0.0, m15: -0.08399999,
          m21: -0.07218799, m22:  1.107983 , m23: -0.0277955 , m24: 0.0, m25: -0.08399999,
          m31: -0.07294299, m32: -0.141469 , m33:  1.222412  , m34: 0.0, m35: -0.08399999,
          m41:  0.0       , m42:  0.0      , m43:  0.0       , m44: 1.0, m45:  0.0
        );
        
      case .preset06:
        return .init(
           m11:  1.407578 , m12: -0.5748306, m13: -0.1107474, m14: 0.0, m15: 0.01900005,
           m21: -0.2921908, m22:  1.125965 , m23: -0.1117742, m24: 0.0, m25: 0.01899996,
           m31: -0.2932176, m32: -0.5732903, m33:  1.588508 , m34: 0.0, m35: 0.01900005,
           m41:  0.0      , m42:  0.0      , m43:  0.0      , m44: 1.0, m45: 0.0
        );
      
      case .preset07:
        return .init(
           m11:  1.201   , m12: -0.587657, m13: -0.113343, m14: 0.0, m15: 0.1,
           m21: -0.298796, m22:  0.913045, m23: -0.114249, m24: 0.0, m25: 0.1,
           m31: -0.299702, m32: -0.586298, m33:  1.386   , m34: 0.0, m35: 0.1,
           m41:  0.0     , m42:  0.0     , m43:  0.0     , m44: 1.0, m45: 0.0
        );
        
      case .preset08:
        return .init(
           m11:  1.201   , m12: -0.587657, m13: -0.113343, m14: 0.0, m15: 0.1,
           m21: -0.298796, m22: 0.913045 , m23: -0.114249, m24: 0.0, m25: 0.1,
           m31: -0.299702, m32: -0.586298, m33:  1.386   , m34: 0.0, m35: 0.1,
           m41:  0.0     , m42: 0.0      , m43:  0.0     , m44: 1.0, m45: 0.0
        );
        
      case .preset09:
        return .init(
           m11:  1.177642  , m12: -0.1426014, m13: -0.02704049, m14: 0.0, m15: -0.08399999,
           m21: -0.07218799, m22:  1.107983 , m23: -0.0277955 , m24: 0.0, m25: -0.08399999,
           m31: -0.07294299, m32: -0.141469 , m33:  1.222412  , m34: 0.0, m35: -0.08399999,
           m41:  0.0       , m42:  0.0      , m43:  0.0       , m44: 1.0, m45:  0.0
        );
        
      case .preset10:
        return .init(
          m11:  1.37625 , m12: -0.7345164, m13: -0.1417335, m14: 0.0, m15: 0.4999999,
          m21: -0.373512, m22:  1.016302 , m23: -0.1427905, m24: 0.0, m25: 0.5      ,
          m31: -0.374569, m32: -0.732931 , m33:  1.6075   , m34: 0.0, m35: 0.4999999,
          m41:  0.0     , m42:  0.0      , m43:  0.0      , m44: 1.0, m45: 0.0
        );
        
      case .preset11:
        return .init(
          m11:  1.22658  , m12: -0.3410732, m13: -0.06550679, m14: 0.0, m15: 0.1799999,
          m21: -0.1732296, m22:  1.059582 , m23: -0.06635241, m24: 0.0, m25: 0.18     ,
          m31: -0.1740752, m32: -0.3398048, m33:  1.33388   , m34: 0.0, m35: 0.1799999,
          m41:  0.0      , m42:  0.0      , m43:  0.0       , m44: 1.0, m45: 0.0
        );
        
      case .preset12:
        return .init(
          m11:  1.060532  , m12: -0.07796578, m13: -0.0145662 , m14: 0.0, m15: 0.12,
          m21: -0.03931839, m22:  1.022549  , m23: -0.01523062, m24: 0.0, m25: 0.12,
          m31: -0.03998281, m32: -0.07696921, m33:  1.084952  , m34: 0.0, m35: 0.1200001,
          m41:  0.0       , m42:  0.0       , m43:  0.0       , m44: 1.0, m45: 0.0
        );
        
      case .preset13:
        return .init(
          m11:  1.396216 , m12: -0.5971366, m13: -0.1150794, m14: 0.0, m15: 0.298    ,
          m21: -0.3035528, m22:  1.103659 , m23: -0.1161062, m24: 0.0, m25: 0.2979999,
          m31: -0.3045796, m32: -0.5955964, m33:  1.584176 , m34: 0.0, m35: 0.298    ,
          m41:  0.0      , m42:  0.0      , m43:  0.0      , m44: 1.0, m45: 0.0
        );
        
      case .preset14:
        return .init(
          m11:  1.173492, m12: -0.641661, m13: -0.123831, m14: 0.0, m15: 0.556    ,
          m21: -0.326304, m22:  0.859041, m23: -0.124737, m24: 0.0, m25: 0.5560001,
          m31: -0.32721 , m32: -0.640302, m33:  1.375512, m34: 0.0, m35: 0.556    ,
          m41:  0.0     , m42:  0.0     , m43:  0.0     , m44: 1.0, m45: 0.0
        );
        
      case .preset15:
        return .init(
          m11:  0.6603  , m12: -0.1764285, m13: -0.0338715 , m14: 0.0, m15: 0.46,
          m21: -0.089598, m22:  0.5739225, m23: -0.03432451, m24: 0.0, m25: 0.46,
          m31: -0.090051, m32: -0.175749 , m33:  0.7158    , m34: 0.0, m35: 0.46,
          m41:  0.0     , m42:  0.0      , m43:  0.0       , m44: 1.0, m45: 0.0
        );
    };
  };
};
