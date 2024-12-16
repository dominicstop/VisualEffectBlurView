//
//  LayerFilterConfig.swift
//  
//
//  Created by Dominic Go on 12/13/24.
//

import UIKit
import DGSwiftUtilities


public enum LayerFilterConfig: Equatable {

  // MARK: - Enum Members: Animatable Filters
  // ----------------------------------------
  
  case luminosityCurveMap(
    amount: CGFloat,
    point1: CGFloat,
    point2: CGFloat,
    point3: CGFloat,
    point4: CGFloat
  );

  case colorBlackAndWhite(amount: CGFloat);
  
  case saturateColors(amount: CGFloat);
  
  case brightenColors(amount: CGFloat);
  
  case contrastColors(amount: CGFloat);
  
  case luminanceCompression(amount: CGFloat)
  
  case bias(amount: CGFloat);
  
  case colorHueAdjust(angle: Angle<CGFloat>);
  
  case gaussianBlur(
    radius: CGFloat,
    shouldNormalizeEdges: Bool = true,
    shouldNormalizeEdgesToTransparent: Bool = false,
    shouldUseHardEdges: Bool = false
  );
  
  case colorMatrixVibrant(_ colorMatrix: ColorMatrixRGBA);
  
  case colorMatrix(_ colorMatrix: ColorMatrixRGBA);
  
  case variadicBlur(
    radius: CGFloat,
    imageGradientConfig: ImageConfigGradient,
    shouldNormalizeEdges: Bool = true,
    shouldNormalizeEdgesToTransparent: Bool = false,
    shouldUseHardEdges: Bool = false
  );
  
  // MARK: - Enum Members: Partially Animatable Filters
  // --------------------------------------------------
  
  case darkVibrant(
    isReversed: Bool,
    color0: UIColor,
    color1: UIColor
  );
  
  case lightVibrant(
    isReversed: Bool,
    color0: UIColor,
    color1: UIColor
  );
  
  // MARK: - Enum Members: Not Animatable
  // ------------------------------------
  
  case alphaFromLuminance;
  
  case averagedColor;
  
  case invertColors;
  
  case distanceField;
  
  // MARK: - Properties
  // ------------------
  
  public var associatedFilterType: LayerFilterType {
    switch self {
      case .alphaFromLuminance:
        return .alphaFromLuminance;
  
      case .averagedColor:
        return .averagedColor;
      
      case let .luminosityCurveMap(amount, point1, point2, point3, point4):
        return .luminosityCurveMap(
          amount: amount,
          values: [point1, point2, point3, point4]
        );

      case let .colorBlackAndWhite(amount):
        return .colorBlackAndWhite(amount: amount);
      
      case let .saturateColors(amount):
        return .saturateColors(amount: amount);
      
      case let .brightenColors(amount):
        return .brightenColors(amount: amount);
      
      case let .contrastColors(amount):
        return .contrastColors(amount: amount);
      
      case let .luminanceCompression(amount):
        return .luminanceCompression(amount: amount);
      
      case let .bias(amount):
        return .bias(amount: amount);
      
      case let .colorHueAdjust(angle):
        return .colorHueAdjust(angle: angle);
      
      case let .gaussianBlur(
        radius,
        shouldNormalizeEdges,
        shouldNormalizeEdgesToTransparent,
        shouldUseHardEdges
      ):
        return .gaussianBlur(
          radius: radius,
          shouldNormalizeEdges: shouldNormalizeEdges,
          shouldNormalizeEdgesToTransparent: shouldNormalizeEdgesToTransparent,
          shouldUseHardEdges: shouldUseHardEdges
        );
      
      case let .colorMatrixVibrant(colorMatrix):
        return .colorMatrixVibrant(colorMatrix);
      
      case let .colorMatrix(colorMatrix):
        return .colorMatrix(colorMatrix);
      
      case let .variadicBlur(
        radius,
        imageGradientConfig,
        shouldNormalizeEdges,
        shouldNormalizeEdgesToTransparent,
        shouldUseHardEdges
      ):
        let maskImage: UIImage? = {
          if let cachedImage = imageGradientConfig.cachedImage {
            return cachedImage;
          };
          
          return try? imageGradientConfig.makeImage();
        }();
          
        return .variadicBlur(
          radius: radius,
          maskImage: maskImage?.cgImage,
          shouldNormalizeEdges: shouldNormalizeEdges,
          shouldNormalizeEdgesToTransparent: shouldNormalizeEdgesToTransparent,
          shouldUseHardEdges: shouldUseHardEdges
        );
        
      case let .darkVibrant(isReversed, color0, color1):
        return .darkVibrant(
          isReversed: isReversed,
          color0: color0.cgColor,
          color1: color1.cgColor
        );
      
      case let .lightVibrant(isReversed, color0, color1):
        return .lightVibrant(
          isReversed: isReversed,
          color0: color0.cgColor,
          color1: color1.cgColor
        );
        
      
      case .invertColors:
        return .invertColors;
        
      case .distanceField:
        return .distanceField;
    };
  };
  
  public var associatedFilterTypeName: LayerFilterTypeName {
    self.associatedFilterType.associatedFilterTypeName;
  };
  
  public var encodedFilterName: String {
    self.associatedFilterTypeName.encodedString;
  };
  
  public var decodedFilterName: String? {
    self.associatedFilterTypeName.decodedString;
  };
  
  public func preloadIfNeeded(
    shouldAlwaysInvokeCompletion: Bool = false,
    completion completionBlock: @escaping (Self) -> Void
  ){
    func invokeCompletionIfNeeded(didLoad: Bool = false){
      guard shouldAlwaysInvokeCompletion || didLoad else {
        return;
      };
    };
  
    switch self {
      case let .variadicBlur(
        radius,
        imageGradientConfig,
        shouldNormalizeEdges,
        shouldNormalizeEdgesToTransparent,
        shouldUseHardEdges
      ):
        guard imageGradientConfig.cachedImage == nil else {
          invokeCompletionIfNeeded();
          return;
        };
      
        let imageLoader = ImageConfigLoader(imageConfig: imageGradientConfig);
        
        imageLoader.loadImageIfNeeded(
          shouldAlwaysInvokeCompletion: shouldAlwaysInvokeCompletion
        ) {
          guard let loadedImage = $0.cachedImage,
                $0.cachedImage != nil
          else {
            invokeCompletionIfNeeded();
            return;
          };
          
          var imageGradientConfig = imageGradientConfig;
          imageGradientConfig.cachedImage = loadedImage;
          
          completionBlock(
            .variadicBlur(
              radius: radius,
              imageGradientConfig: imageGradientConfig,
              shouldNormalizeEdges: shouldNormalizeEdges,
              shouldNormalizeEdgesToTransparent: shouldNormalizeEdgesToTransparent,
              shouldUseHardEdges: shouldUseHardEdges
            )
          );
        };
      
      default:
        invokeCompletionIfNeeded();
    };
  };
};

// MARK: - `LayerFilterConfig+EnumCaseStringRepresentable`
// -------------------------------------------------------

extension LayerFilterConfig: EnumCaseStringRepresentable {

  public var caseString: String {
    self.associatedFilterTypeName.rawValue;
  };
};
