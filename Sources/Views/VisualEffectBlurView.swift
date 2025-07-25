//
//  VisualEffectBlurView.swift
//
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit
import DGSwiftUtilities


public class VisualEffectBlurView: VisualEffectView {

  // MARK: - Properties
  // ------------------

  private var initialBlurRadius: CGFloat?;
  
  public var blurEffectStyle: UIBlurEffect.Style? {
    willSet {
      self.clearAnimator();
      
      guard let newValue = newValue else {
        self.effect = nil;
        self.initialBlurRadius = nil;
        return;
      };
      
      self.effect = UIBlurEffect(style: newValue);
      self.initialBlurRadius = self.blurRadius;
    }
  };
  
  public override var shouldAutomaticallyReApplyEffects: Bool {
    get {
      self._shouldAutomaticallyReApplyEffects ?? true;
    }
    set {
      self._shouldAutomaticallyReApplyEffects = newValue;
    }
  };
  
  // MARK: Computed Properties
  // -------------------------
  
  private var _blurRadius: CGFloat?;
  public var blurRadius: CGFloat {
    set {
      self._blurRadius = newValue;
      
      guard #available(iOS 13, *) else {
        return;
      };
      
      try? self.setBlurRadius(newValue, shouldImmediatelyApply: true);
    }
    get {
      guard let bgLayerWrapper = self.backgroundLayerWrapped,
            let gaussianBlurFilterWrapper = bgLayerWrapper.gaussianBlurFilterWrapper,
            let inputRadius = gaussianBlurFilterWrapper.inputRadius
      else {
        #if DEBUG
        print(
          "BlurView.blurRadius - get",
          "- failed to get inputRadius"
        );
        #endif
        return self._blurRadius ?? self.defaultBlurRadius;
      };
      
      self._blurRadius = inputRadius;
      
      if let animatorWrapper = self.animatorWrapper {
        return inputRadius * animatorWrapper.animator.fractionComplete;
      };
      
      return inputRadius;
    }
  };

  // MARK: - Computed Properties
  // ---------------------------
  
  public var defaultBlurRadius: CGFloat {
    if let defaultBlurRadius = self.blurEffectStyle?.defaultBlurRadius {
      return defaultBlurRadius;
    };
    
    if let initialBlurRadius = self.initialBlurRadius {
      return initialBlurRadius;
    };
    
    return 30;
  };
  
  public var currentBlurRadius: CGFloat? {
    guard let bgLayerWrapper = self.backgroundLayerWrapped,
          let gaussianBlurFilterWrapper = bgLayerWrapper.gaussianBlurFilterWrapper,
          let inputRadius = gaussianBlurFilterWrapper.inputRadius
    else {
      return nil;
    };
    
    return inputRadius;
  };
  
  public var blurIntensity: CGFloat {
    set {
      let defaultBlurRadius = self.defaultBlurRadius;
      self.blurRadius = defaultBlurRadius * newValue;
    }
    get {
      let defaultBlurRadius = self.defaultBlurRadius;
      let currentBlurRadius = self.blurRadius;
      
      return currentBlurRadius / defaultBlurRadius;
    }
  };
  
  // MARK: - Init
  // ------------
  
  public init(blurEffectStyle: UIBlurEffect.Style?) throws {
    let blurEffect: UIBlurEffect? = {
      guard let blurEffectStyle = blurEffectStyle else {
        return nil;
      };
      
      return .init(style: blurEffectStyle);
    }();
    
    self.blurEffectStyle = blurEffectStyle;
    
    try super.init(withEffect: blurEffect);
    self.shouldAutomaticallyReApplyEffects = false;
  };
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  };
  
  // MARK: - Functions
  // -----------------
  
  @available(iOS 13, *)
  public func setBlurRadius(
    _ blurRadius: CGFloat,
    shouldImmediatelyApply: Bool = true
  ) throws {
  
    try self.updateMatchingBackgroundFilter(
      with: .gaussianBlur(
        radius: blurRadius,
        shouldNormalizeEdges: true
      ),
      shouldImmediatelyApply: shouldImmediatelyApply
    );
  };
};

