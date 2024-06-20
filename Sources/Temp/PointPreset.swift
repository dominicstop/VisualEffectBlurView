//
//  PointPreset.swift
//  
//
//  Created by Dominic Go on 6/20/24.
//

import UIKit

public enum PointPreset: String {
  case top, bottom, left, right;
  
  case topLeft, topRight;
  case bottomLeft, bottomRight;
  
  // MARK: - Computed Properties
  // ---------------------------
    
  public var point: CGPoint {
    switch self {
      case .top:
        return CGPoint(x: 0.5, y: 0.0);
        
      case .bottom:
        return CGPoint(x: 0.5, y: 1.0);
        
      case .left:
        return CGPoint(x: 0.0, y: 0.5);
        
      case .right:
        return CGPoint(x: 1.0, y: 0.5);
        
      case .bottomLeft:
        return CGPoint(x: 0.0, y: 1.0);
        
      case .bottomRight:
        return CGPoint(x: 1.0, y: 1.0);

      case .topLeft:
        return CGPoint(x: 0.0, y: 0.0);
        
      case .topRight:
        return CGPoint(x: 1.0, y: 0.0);
    };
  };
};
