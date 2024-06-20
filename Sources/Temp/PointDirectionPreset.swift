//
//  PointDirectionPreset.swift
//  
//
//  Created by Dominic Go on 6/20/24.
//

import UIKit

public enum PointDirectionPreset: String {

  // horizontal
  case leftToRight, rightToLeft;
  
  // vertical
  case topToBottom, bottomToTop;
  
  // diagonal
  case topLeftToBottomRight, topRightToBottomLeft;
  case bottomLeftToTopRight, bottomRightToTopLeft;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var point: (start: CGPoint, end: CGPoint) {
    switch self {
      case .leftToRight:
        return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 1.5));
        
      case .rightToLeft:
        return (CGPoint(x: 1.0, y: 0.5), CGPoint(x: 0.0, y: 0.5));
        
      case .topToBottom:
        return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0));
        
      case .bottomToTop:
        return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0));
        
      case .topLeftToBottomRight:
        return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0));
        
      case .topRightToBottomLeft:
        return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0));
        
      case .bottomLeftToTopRight:
        return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0));
        
      case .bottomRightToTopLeft:
        return (CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0));
    };
  };
};
