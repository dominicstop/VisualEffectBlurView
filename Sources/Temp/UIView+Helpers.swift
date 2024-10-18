//
//  UIView+Helpers.swift
//
//
//  Created by Dominic Go on 10/18/24.
//

import UIKit

public extension UIView {
  
  func displayNow(){
    self.setNeedsLayout();
    self.layer.setNeedsDisplay();
    
    self.layer.displayIfNeeded();
    self.layoutIfNeeded();
  };
};
