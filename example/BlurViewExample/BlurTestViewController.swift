//
//  BlurTestViewController.swift
//  BlurViewExample
//
//  Created by Dominic Go on 9/12/23.
//

import UIKit
import BlurView


class BlurTestViewController : UIViewController {
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  override func viewDidLoad() {
    let bgView = UILabel();
    bgView.text = "🖼️\n🌆\n🌄";
    bgView.font = .systemFont(ofSize: 100);
    
    bgView.numberOfLines = 0
    bgView.lineBreakMode = .byWordWrapping;
    bgView.sizeToFit();
    
    bgView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(bgView);
    
    NSLayoutConstraint.activate([
      bgView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
      bgView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
      
      bgView.centerXAnchor.constraint(
        equalTo: self.view.centerXAnchor
      ),
      
      bgView.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor
      ),
    ]);
    
    let boxView: UIView = {
      let containerView = UIView();
      
      let bgBlurView = BlurView(blurEffect: UIBlurEffect(style: .dark));
      bgBlurView.blurRadius = 0;
    
      
      bgBlurView.translatesAutoresizingMaskIntoConstraints = false;
      containerView.addSubview(bgBlurView);
      
      NSLayoutConstraint.activate([
        bgBlurView.heightAnchor.constraint(
          equalTo: containerView.heightAnchor
        ),
        bgBlurView.widthAnchor.constraint(
          equalTo: containerView.widthAnchor
        ),
        
        bgBlurView.centerXAnchor.constraint(
          equalTo: containerView.centerXAnchor
        ),
        
        bgBlurView.centerYAnchor.constraint(
          equalTo: containerView.centerYAnchor
        ),
      ]);
      
      return containerView;
    }();
 
    boxView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(boxView);
    
    let heightConstraint = boxView.heightAnchor.constraint(equalToConstant: 300);
    
    NSLayoutConstraint.activate([
      heightConstraint,
      boxView.widthAnchor.constraint(equalToConstant: 200),
      
      boxView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      boxView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ]);
    
    let transform3d = Transform3D(
      translateX: 0,
      translateY: 0,
      translateZ: 0,
      scaleX: 1,
      scaleY: 1,
      rotateX: .degrees(0),
      rotateY: .degrees(45),
      rotateZ: .degrees(0),
      perspective: 1/1000,
      skewX: 0,
      skewY: 0
    );
    
    let nextTransform3d = Transform3D(
      translateX: 100,
      translateY: 0,
      translateZ: 0,
      scaleX: 1,
      scaleY: 1,
      rotateX: .degrees(0),
      rotateY: .degrees(15),
      rotateZ: .degrees(0),
      perspective: 1/1000,
      skewX: 0,
      skewY: 0
    );
    
    boxView.layer.transform = transform3d.transform;
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      UIView.animate(withDuration: 3) {
        heightConstraint.constant = 500;
        boxView.layer.transform = nextTransform3d.transform;
        boxView.updateConstraints();
        boxView.layoutIfNeeded();
      };
    };
  };
};
