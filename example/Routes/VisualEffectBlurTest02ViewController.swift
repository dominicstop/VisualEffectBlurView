//
//  VisualEffectBlurTest02ViewController.swift
//  
//
//  Created by Dominic Go on 8/14/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView


class VisualEffectBlurTest02ViewController: UIViewController {

  weak var visualEffectBlurView: VisualEffectBlurView?;
  weak var effectIntensitySlider: UISlider?;
  
  weak var blurRadiusLabel: UILabel?;
  weak var intensityLabel: UILabel?;
  
  var blurEffectStyleCounter = 0;
  
  var currentBlurEffectStyle: UIBlurEffect.Style {
    let index = blurEffectStyleCounter % UIBlurEffect.Style.allCases.count;
    return UIBlurEffect.Style.allCases[index];
  };
  
  var isBlurViewTransformed = false;

  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  override func viewDidLoad() {
  
    let bgView: UIView = {
      let label = UILabel();
      label.text = "🖼️\n🌆\n🌄";
      label.font = .systemFont(ofSize: 128);
      
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping;
      label.sizeToFit();
      
      return label;
    }();
  
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
    
    let blurContainerView: UIView = {
      let containerView = UIView();
      
      let bgBlurView = try! VisualEffectBlurView(blurEffectStyle: .dark);
      self.visualEffectBlurView = bgBlurView;
      
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
 
    blurContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(blurContainerView);
    
    NSLayoutConstraint.activate([
      blurContainerView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      blurContainerView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
      blurContainerView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      blurContainerView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
    ]);
    
    let effectIntensitySlider: UISlider = {
      let slider = UISlider();
      self.effectIntensitySlider = slider;
      
      slider.minimumValue = 0;
      slider.maximumValue = 1;
      slider.value = 1;
      slider.isContinuous = true;
      
      slider.addTarget(
        self,
        action: #selector(self.onIntensitySliderValueChanged(_:)),
        for: .valueChanged
      );
      
      return slider;
    }();
    
    let nextBlurEffectButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Next Effect", for: .normal);
      button.configuration = .filled();
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonNextEffect(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    let controlStack: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .fill;
      stack.spacing = 20;
      
      stack.addArrangedSubview(effectIntensitySlider);
      stack.addArrangedSubview(nextBlurEffectButton);
    
      return stack;
    }();
    
    controlStack.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(controlStack);
    
    NSLayoutConstraint.activate([
      controlStack.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
        constant: -20
      ),
      controlStack.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      controlStack.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
        constant: -20
      ),
    ]);
    
    let blurRadiusLabel: UIView = {
      let initialBlurRadius = self.visualEffectBlurView?.blurRadius ?? 0;
    
      let label = UILabel();
      self.blurRadiusLabel = label;
      
      label.text = "\(initialBlurRadius)";
      label.font = .boldSystemFont(ofSize: 32);
      
      label.textColor = UIColor(
        red: 255/255,
        green: 255/255,
        blue: 255/255,
        alpha: 0.8
      );
      
      return label;
    }();
    
    let intensityLabel: UIView = {
      let initialBlurRadius = self.visualEffectBlurView?.blurRadius ?? 0;
    
      let label = UILabel();
      self.intensityLabel = label;
      
      label.text = "\(initialBlurRadius)";
      label.font = .boldSystemFont(ofSize: 32);
      
      label.textColor = UIColor(
        red: 255/255,
        green: 255/255,
        blue: 255/255,
        alpha: 0.8
      );
      
      return label;
    }();
    
    let overlayStack: UIStackView = {
      let stack = UIStackView();
      
      stack.backgroundColor = UIColor(
        red: 0/255,
        green: 0/255,
        blue: 0/255,
        alpha: 0.4
      );
      
      stack.axis = .vertical;
      stack.distribution = .fillEqually;
      stack.alignment = .center;
      stack.spacing = 10;
      
      stack.layer.cornerRadius = 15;
      
      stack.addArrangedSubview(blurRadiusLabel);
      stack.addArrangedSubview(intensityLabel);
      
      return stack;
    }();
    
    overlayStack.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(overlayStack);
    
    NSLayoutConstraint.activate([
      overlayStack.heightAnchor.constraint(
        equalToConstant: 200
      ),
      overlayStack.widthAnchor.constraint(
        equalToConstant: 150
      ),
      overlayStack.centerXAnchor.constraint(
        equalTo: self.view.centerXAnchor
      ),
      
      overlayStack.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor
      ),
    ]);
  };
    
  @objc func onPressBlurRadiusLabel(_ sender: UILabel!){
    guard let visualEffectBlurView = self.visualEffectBlurView else { return };
    
    self.isBlurViewTransformed.toggle();
    
    let nextTransform: Transform3D = {
      if isBlurViewTransformed {
        return .default;
      };
      
      return Transform3D(
        translateX: 0,
        translateY: 0,
        translateZ: 0,
        scaleX: 0.75,
        scaleY: 0.75,
        rotateX: .degrees(15),
        rotateY: .degrees(30),
        rotateZ: .degrees(7),
        perspective: 1/1000,
        skewX: 0,
        skewY: 0
      );
    }();
    
    UIView.animate(withDuration: 3) {
      visualEffectBlurView.layer.transform = nextTransform.transform;
    };
  };
  
  @objc func onIntensitySliderValueChanged(_ sender: UISlider!){
    guard let visualEffectBlurView = self.visualEffectBlurView,
          let intensityLabel = self.intensityLabel,
          let blurRadiusLabel = self.blurRadiusLabel
    else { return };
    
    let sliderValue = CGFloat(sender.value);
    
    intensityLabel.text = String(format: "%.3f", sender.value) + "%";
    blurRadiusLabel.text = String(format: "%.3f", visualEffectBlurView.blurRadius);
    
    visualEffectBlurView.setEffectIntensity(sliderValue);
  };
  
  @objc func onPressButtonNextEffect(_ sender: UIButton){
    self.blurEffectStyleCounter += 1;
    
    guard let visualEffectBlurView = self.visualEffectBlurView,
          let blurRadiusLabel = self.blurRadiusLabel,
          let intensityLabel = self.intensityLabel,
          let effectIntensitySlider = self.effectIntensitySlider
    else { return };
    
    visualEffectBlurView.blurEffectStyle = self.currentBlurEffectStyle;    visualEffectBlurView.clearAnimator();
    
    let effectIntensity =
      visualEffectBlurView.animatorWrapper?.animator.fractionComplete ?? 1;
    
    let currentBlurRadius = floor(visualEffectBlurView.blurRadius);
    blurRadiusLabel.text = "\(currentBlurRadius)";
    intensityLabel.text = String(format: "%.3f", effectIntensity) + "%";
    
    effectIntensitySlider.value = 1;
  };
};
