//
//  Transform3D.swift
//  BlurViewExample
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit

struct Transform3D: Equatable {

  public static let `default`: Self = .init(
    translateX: 0,
    translateY: 0,
    translateZ: 0,
    scaleX: 1,
    scaleY: 1,
    rotateX: .zero,
    rotateY: .zero,
    rotateZ: .zero,
    perspective: 0,
    skewX: 0,
    skewY: 0
  );
  
  // MARK: - Properties
  // ------------------
  
  private var _translateX: CGFloat?;
  private var _translateY: CGFloat?;
  private var _translateZ: CGFloat?;
  
  private var _scaleX: CGFloat?;
  private var _scaleY: CGFloat?;
  
  private var _rotateX: Angle<CGFloat>?;
  private var _rotateY: Angle<CGFloat>?;
  private var _rotateZ: Angle<CGFloat>?;
  
  private var _perspective: CGFloat?;
  
  private var _skewX: CGFloat?;
  private var _skewY: CGFloat?;
  
  // MARK: - Computed Properties - Setters/Getters
  // ---------------------------------------------

  public var translateX: CGFloat {
    get {
      self._translateX
        ?? Self.default.translateX;
    }
    set {
      self._translateX = newValue;
    }
  };
  
  public var translateY: CGFloat {
    get {
      self._translateY
        ?? Self.default.translateY;
    }
    set {
      self._translateY = newValue;
    }
  };
  
  public var translateZ: CGFloat {
    get {
      self._translateZ
        ?? Self.default.translateZ;
    }
    set {
      self._translateZ = newValue;
    }
  };
  
  public var scaleX: CGFloat {
    get {
      self._scaleX
        ?? Self.default.scaleX;
    }
    set {
      self._scaleX = newValue;
    }
  };
  
  public var scaleY: CGFloat {
    get {
      self._scaleY
        ?? Self.default.scaleY;
    }
    set {
      self._scaleY = newValue;
    }
  };
  
  public var rotateX: Angle<CGFloat> {
    get {
      self._rotateX ??
        Self.default.rotateX;
    }
    set {
      self._rotateX = newValue;
    }
  };
  
  public var rotateY: Angle<CGFloat> {
    get {
      self._rotateY ??
        Self.default.rotateY;
    }
    set {
      self._rotateY = newValue;
    }
  };
  
  public var rotateZ: Angle<CGFloat> {
    get {
      self._rotateZ ??
        Self.default.rotateZ;
    }
    set {
      self._rotateZ = newValue;
    }
  };
  
  public var perspective: CGFloat {
    get {
      self._perspective
        ?? Self.default.perspective;
    }
    set {
      self._perspective = newValue;
    }
  };
  
  public var skewX: CGFloat {
    get {
      self._skewX
        ?? Self.default.skewX;
    }
    set {
      self._skewX = newValue;
    }
  };
  
  public var skewY: CGFloat {
    get {
      self._skewY
        ?? Self.default.skewY;
    }
    set {
      self._skewY = newValue;
    }
  };
  
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var transform: CATransform3D {
    var transform = CATransform3DIdentity;
    
    transform.m34 = self.perspective;
    transform.m12 = self.skewY;
    transform.m21 = self.skewY;
    
    transform = CATransform3DTranslate(
      transform,
      self.translateX,
      self.translateY,
      self.translateZ
    );
    
    transform = CATransform3DScale(
      transform,
      self.scaleX,
      self.scaleY,
      1
    );
    
    transform = CATransform3DRotate(
      transform,
      self.rotateX.radians,
      1,
      0,
      0
    );
    
    transform = CATransform3DRotate(
      transform,
      self.rotateY.radians,
      0,
      1,
      0
    );
    
    transform = CATransform3DRotate(
      transform,
      self.rotateZ.radians,
      0,
      0,
      1
    );
    
    return transform;
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    translateX: CGFloat? = nil,
    translateY: CGFloat? = nil,
    translateZ: CGFloat? = nil,
    scaleX: CGFloat? = nil,
    scaleY: CGFloat? = nil,
    rotateX: Angle<CGFloat>? = nil,
    rotateY: Angle<CGFloat>? = nil,
    rotateZ: Angle<CGFloat>? = nil,
    perspective: CGFloat? = nil,
    skewX: CGFloat? = nil,
    skewY: CGFloat? = nil
  ) {
    
    self._translateX = translateX;
    self._translateY = translateY;
    self._translateZ = translateZ;
    
    self._scaleX = scaleX;
    self._scaleY = scaleY;
    
    self._rotateX = rotateX;
    self._rotateY = rotateY;
    self._rotateZ = rotateZ;
    
    self._perspective = perspective;
    self._skewX = skewX;
    self._skewY = skewY;
  };
  
  public init(
    translateX: CGFloat,
    translateY: CGFloat,
    translateZ: CGFloat,
    scaleX: CGFloat,
    scaleY: CGFloat,
    rotateX: Angle<CGFloat>,
    rotateY: Angle<CGFloat>,
    rotateZ: Angle<CGFloat>,
    perspective: CGFloat,
    skewX: CGFloat,
    skewY: CGFloat
  ) {
    
    self._translateX = translateX;
    self._translateY = translateY;
    self._translateZ = translateZ;
    
    self._scaleX = scaleX;
    self._scaleY = scaleY;
    
    self._rotateX = rotateX;
    self._rotateY = rotateY;
    self._rotateZ = rotateZ;
    
    self._perspective = perspective;
    self._skewX = skewX;
    self._skewY = skewY;
  };
};
