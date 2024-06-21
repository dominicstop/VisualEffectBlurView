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
      guard let backdropLayerWrapper = self.backdropLayerWrapper,
            let backdropLayer = backdropLayerWrapper.wrappedObject
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
    self.wrapper.backgroundHostWrapper;
  };
  
  var contentViewWrapper: VisualEffectBackdropViewWrapper? {
    self.backgroundHostWrapper?.contentViewWrapper;
  };
  
  var backdropLayerWrapper: BackdropLayerWrapper? {
    self.contentViewWrapper?.backdropLayerWrapper
  };
  
  public init?(rawFilterType: String? = nil){
    super.init(effect: UIBlurEffect(style: .regular));
    
    guard let wrapper = VisualEffectViewWrapper(objectToWrap: self) else {
      return nil;
    };
    
    self.wrapper = wrapper;
    
    guard let backdropLayerWrapper = self.backdropLayerWrapper,
          let backdropLayer = backdropLayerWrapper.wrappedObject
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
