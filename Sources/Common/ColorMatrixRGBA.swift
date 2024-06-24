//
//  ColorMatrixRGBA.swift
//  
//
//  Created by Dominic Go on 6/23/24.
//

import Foundation


public struct ColorMatrixRGBA {

  // MARK: - Static Alias
  // ------------------

  public static var zero: Self {
    .init(
      m11: 0, m12: 0, m13: 0, m14: 0, m15: 0,
      m21: 0, m22: 0, m23: 0, m24: 0, m25: 0,
      m31: 0, m32: 0, m33: 0, m34: 0, m35: 0,
      m41: 0, m42: 0, m43: 0, m44: 0, m45: 0
    );
  };
  
  public static var identity: Self {
    .init(
      m11: 1, m12: 0, m13: 0, m14: 0, m15: 0,
      m21: 0, m22: 1, m23: 0, m24: 0, m25: 0,
      m31: 0, m32: 0, m33: 1, m34: 0, m35: 0,
      m41: 0, m42: 0, m43: 0, m44: 1, m45: 0
    );
  };
  
  // MARK: - Static Variables
  // ------------------------
  
  public static let kayPathsMatrix: [[WritableKeyPath<Self, Float>]] = [
    [\.m11, \.m12, \.m13, \.m14, \.m15],
    [\.m21, \.m22, \.m23, \.m24, \.m25],
    [\.m31, \.m32, \.m33, \.m34, \.m35],
    [\.m41, \.m42, \.m43, \.m44, \.m45],
  ];

  public static var kayPathsAll: [WritableKeyPath<Self, Float>] {
    Self.kayPathsMatrix.reduce(into: []){
      $0 += $1;
    };
  };
  
  // MARK: - Properties
  // ------------------

  public var m11, m12, m13, m14, m15: Float;
  public var m21, m22, m23, m24, m25: Float;
  public var m31, m32, m33, m34, m35: Float;
  public var m41, m42, m43, m44, m45: Float;
  
  // MARK: - Init
  // ------------
  
  public init(
    m11: Float, m12: Float, m13: Float, m14: Float, m15: Float,
    m21: Float, m22: Float, m23: Float, m24: Float, m25: Float,
    m31: Float, m32: Float, m33: Float, m34: Float, m35: Float,
    m41: Float, m42: Float, m43: Float, m44: Float, m45: Float
  ) {
    self.m11 = m11;
    self.m12 = m12;
    self.m13 = m13;
    self.m14 = m14;
    self.m15 = m15;
    self.m21 = m21;
    self.m22 = m22;
    self.m23 = m23;
    self.m24 = m24;
    self.m25 = m25;
    self.m31 = m31;
    self.m32 = m32;
    self.m33 = m33;
    self.m34 = m34;
    self.m35 = m35;
    self.m41 = m41;
    self.m42 = m42;
    self.m43 = m43;
    self.m44 = m44;
    self.m45 = m45;
  };
  
  public init(fromValue value: NSValue){
    let floatMembersInStructCount = 20;
    let floatSizeBytes = MemoryLayout<UInt32>.size;
    let structTotalSizeBytes = floatSizeBytes * floatMembersInStructCount;

    var bufferArray = [UInt32](repeating: 0, count: floatMembersInStructCount);
    value.getValue(&bufferArray, size: structTotalSizeBytes);
    
    let floats = bufferArray.map {
      Float(bitPattern: $0);
    };
    
    let kayPathsAll = Self.kayPathsAll;
    var newMatrix: Self = .zero;
    
    floats.enumerated().forEach {
      let kayPath = kayPathsAll[$0.offset];
      newMatrix[keyPath: kayPath] = $0.element;
    };
    
    self = newMatrix;
  };
};
