//
//  VisualEffectView.swift
//  
//
//  Created by Dominic Go on 6/21/24.
//

import UIKit
import DGSwiftUtilities


public class VisualEffectView: UIVisualEffectView {
  
  public var wrapper: VisualEffectViewWrapper!;
  
  public var shouldOnlyShowBackdropLayer: Bool = false {
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
  
  var backgroundHostWrapper: VisualEffectHostWrapper? {
    self.wrapper.bgHostWrapped;
  };
  
  var contentViewWrapper: VisualEffectBackdropViewWrapper? {
    self.backgroundHostWrapper?.contentViewWrapper;
  };
  
  var bgLayerWrapper: BackdropLayerWrapper? {
    self.contentViewWrapper?.bgLayerWrapper
  };
  
  @available(iOS 13, *)
  var effectDescriptorForCurrentEffectWrapper: VisualEffectDescriptorWrapper? {
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
    
    guard let wrapper = VisualEffectViewWrapper(objectToWrap: self) else {
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
};
