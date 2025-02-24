//
//  LayerFilterConfig.swift
//  
//
//  Created by Dominic Go on 12/13/24.
//

import UIKit
import DGSwiftUtilities


public enum LayerFilterConfig: Equatable {

  // MARK: - Embedded Types
  // ----------------------
  
  public typealias GradientConfigImagePair = (
    gradientConfig: ImageConfigGradient,
    gradientImage: CGImage
  );

  public typealias ImageGradientCache =
    Dictionary<ImageConfigGradient, GradientConfigImagePair>;

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
    shouldNormalizeEdgesToTransparent: Bool? = nil,
    shouldUseHardEdges: Bool? = nil
  );
  
  case colorMatrixVibrant(_ colorMatrix: ColorMatrixRGBA);
  
  case colorMatrix(_ colorMatrix: ColorMatrixRGBA);
  
  case colorTransformVibrant(_ colorTransform: ColorTransform);
  
  case colorTransform(_ colorTransform: ColorTransform);
  
  case variadicBlur(
    radius: CGFloat,
    imageGradientConfig: ImageConfigGradient,
    shouldNormalizeEdges: Bool = true,
    shouldNormalizeEdgesToTransparent: Bool? = nil,
    shouldUseHardEdges: Bool? = nil
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
        
      case let .colorTransformVibrant(colorTransform):
        return .colorMatrixVibrant(colorTransform.colorMatrix);
        
      case let .colorTransform(colorTransform):
        return .colorMatrix(colorTransform.colorMatrix);
      
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
  
  public func createAssociatedFilterType(
    gradientCache: inout ImageGradientCache
  ) -> LayerFilterType {
    
    switch self {
      case let .variadicBlur(
        radius,
        imageGradientConfig,
        shouldNormalizeEdges,
        shouldNormalizeEdgesToTransparent,
        shouldUseHardEdges
      ):
        
        let maskImage: CGImage? = {
          if let cachedEntry = gradientCache[imageGradientConfig] {
            return cachedEntry.gradientImage;
          };
          
        
          if let image = imageGradientConfig.cachedImage,
             let cgImage = image.cgImage
          {
            gradientCache[imageGradientConfig] = (imageGradientConfig, cgImage);
            return cgImage;
          };
          
          guard let image = try? imageGradientConfig.makeImage(),
                let cgImage = image.cgImage
          else {
            return nil;
          };
          
          gradientCache[imageGradientConfig] = (imageGradientConfig, cgImage);
          return cgImage;
        }();
        
        return .variadicBlur(
          radius: radius,
          maskImage: maskImage,
          shouldNormalizeEdges: shouldNormalizeEdges,
          shouldNormalizeEdgesToTransparent: shouldNormalizeEdgesToTransparent,
          shouldUseHardEdges: shouldUseHardEdges
        );
    
      default:
        return self.associatedFilterType;
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

// MARK: - `Array+LayerFilterConfig`
// ---------------------------------

public extension Array where Element == LayerFilterConfig {
  
  var associatedFilterType: [LayerFilterType] {
    self.map {
      $0.associatedFilterType;
    };
  };
  
  func replaceMatchingElements(
    withOther otherFilterTypes: [LayerFilterConfig]
  ) -> Self {

    self.map { currentFilter in
      switch currentFilter {
        case let .variadicBlur(_, currentMaskConfig, _, _, _):
          let otherFilterType = otherFilterTypes.first {
            switch $0 {
              case let .variadicBlur(_, otherMaskConfig, _, _, _):
                return currentMaskConfig.hashValue == otherMaskConfig.hashValue;
              
              default:
                return false;
            };
          };
          
          guard let otherFilterType = otherFilterType else {
            return currentFilter;
          };

          return otherFilterType;
      
        default:
          let otherFilter = otherFilterTypes.first {
            currentFilter.decodedFilterName == $0.decodedFilterName;
          };
          
          return otherFilter ?? currentFilter;
      };
    };
  };
  
  func updateAndMergeElements(
    withOther otherFilterTypes: [LayerFilterConfig]
  ) -> (
    updatedItems: Self,
    orphanedItems: Self,
    mergedItems: Self
  ) {
    var otherFilterTypes = otherFilterTypes;
    var updatedItems: Self = [];
    
    for currentFilter in self {
      switch currentFilter {
        case let .variadicBlur(_, currentMaskConfig, _, _, _):
          let match = otherFilterTypes.enumerated().first {
            switch $0.element {
              case let .variadicBlur(_, otherMaskConfig, _, _, _):
                return currentMaskConfig.hashValue == otherMaskConfig.hashValue;
              
              default:
                return false;
            };
          };
          
          guard let (indexOfOtherFilterType, otherFilterType) = match else {
            updatedItems.append(currentFilter);
            continue;
          };
          
          otherFilterTypes.remove(at: indexOfOtherFilterType);
          updatedItems.append(otherFilterType);
      
        default:
          let match = otherFilterTypes.enumerated().first {
            currentFilter.decodedFilterName == $0.element.decodedFilterName;
          };
          
          guard let (indexOfOtherFilterType, otherFilterType) = match else {
            updatedItems.append(currentFilter);
            continue;
          };
          
          otherFilterTypes.remove(at: indexOfOtherFilterType);
          updatedItems.append(otherFilterType);
      };
    };
    
    return (
      updatedItems: updatedItems,
      orphanedItems: otherFilterTypes,
      mergedItems: updatedItems + otherFilterTypes
    );
  };
};


// MARK: - `ImageConfigGradient+Hashable`
// --------------------------------------

extension ImageConfigGradient: Hashable {

  public func hash(into hasher: inout Hasher) {
    let maxFractionDigits = 6;
    
    self.colors.hash(into: &hasher);
    self.locations?.hash(into: &hasher);
    
    hasher.combine(
      self.startPoint.x.cutOffDecimalsAfter(maxFractionDigits)
    );
    
    hasher.combine(
      self.startPoint.y.cutOffDecimalsAfter(maxFractionDigits)
    );
    
    hasher.combine(
      self.endPoint.x.cutOffDecimalsAfter(maxFractionDigits)
    );
    
    hasher.combine(
      self.endPoint.y.cutOffDecimalsAfter(maxFractionDigits)
    );
    
    hasher.combine(
      self.size.width.cutOffDecimalsAfter(maxFractionDigits)
    );
    
    hasher.combine(
      self.size.height.cutOffDecimalsAfter(maxFractionDigits)
    );
    
    hasher.combine(self.cornerRadius);
  };
};
