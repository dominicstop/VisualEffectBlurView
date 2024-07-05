//
//  VisualEffectView.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import UIKit
import DGSwiftUtilities


public class VisualEffectView: UIVisualEffectView {
  
  public var wrapper: UVEViewWrapper!;
  
  /// Old name: `shouldOnlyShowBackdropLayer`
  public var shouldOnlyShowBgLayer: Bool = false {
    willSet {
      guard let bgLayerWrapper = self.bgLayerWrapper,
            let backdropLayer = bgLayerWrapper.wrappedObject
      else {
        return;
      };
      
      self.subviews.forEach {
        guard $0.layer !== backdropLayer else {
          return;
        };
        
        $0.isHidden = newValue;
      };
    }
  };
  
  /// Old name: `backgroundHostWrapper`
  var bgHostWrapper: UVEHostWrapper? {
    self.wrapper.bgHostWrapped;
  };
  
  /// Old name: `contentViewWrapper`
  var viewContentWrapper: UVEBackdropViewWrapper? {
    self.bgHostWrapper?.viewContentWrapped;
  };
  
  /// Old name: `backdropLayerWrapper`
  var bgLayerWrapper: BackgroundLayerWrapper? {
    self.viewContentWrapper?.bgLayerWrapper
  };
  
  /// Old name: `effectDescriptorForCurrentEffectWrapper`
  @available(iOS 13, *)
  var currentEffectMetadata: UVEDescriptorWrapper? {
    guard let effect = self.effect,
          let wrapper = self.wrapper
    else {
      return nil;
    };
    
    return try? wrapper.getEffectMetadata(
      forEffects: [effect],
      usage: true
    );
  };
  
  public init?(rawFilterType: String? = nil){
    super.init(effect: UIBlurEffect(style: .regular));
    
    guard let wrapper = UVEViewWrapper(objectToWrap: self) else {
      return nil;
    };
    
    self.wrapper = wrapper;
    
    guard let bgLayerWrapper = self.bgLayerWrapper,
          let backdropLayer = bgLayerWrapper.wrappedObject
    else {
      return nil;
    };
    
    backdropLayer.filters = [];
    
    guard let rawFilterType = rawFilterType else {
      return;
    };
    
    guard let filterWrapper = LayerFilterWrapper(rawFilterType: rawFilterType),
          let filter = filterWrapper.wrappedObject
    else {
      return;
    };
    
    backdropLayer.filters = [filter];
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  }
  public func setFiltersViaLayers(_ filterTypes: [LayerFilterType]) throws {
    guard let bgHostWrapper = self.bgHostWrapper else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgHostWrapper`"
      );
    };
    
    guard let contentViewWrapper = bgHostWrapper.viewContentWrapped else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `UVEHostWrapper.viewContentWrapped`"
      );
    };
    
    guard let bgLayerWrapper = contentViewWrapper.bgLayerWrapper,
          let bgLayer = bgLayerWrapper.wrappedObject
    else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `self.bgLayerWrapper`"
      );
    };
    
    let filterWrappers = filterTypes.compactMap {
      $0.createFilterWrapper();
    };
    
    let filters = filterWrappers.compactMap {
      $0.wrappedObject;
    };
    
    bgLayer.filters = filters;
    try contentViewWrapper.applyRequestedFilterEffects();
  };
};
