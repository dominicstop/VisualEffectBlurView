//
//  RouteListViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit
import DGSwiftUtilities


class RouteListViewController: UIViewController {
  
  var cardThemeConfig: ColorThemeConfig = .presetPurple;
  var modalDebugDisplayVStack: UIStackView?;
  
  var _didSetupGestureRecognizer = false;
  
  override func viewDidLoad() {
    self.view.backgroundColor = .white;
    
    let stackView: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      stack.spacing = 15;
                
      return stack;
    }();
    
    let cardColorThemeConfig = ColorThemeConfig.presetPurple;
    var cardConfig: [CardConfig] = [];
    
    cardConfig += Route.allCases.enumerated().map { route in
      .init(
        title: route.element.rawValue,
        subtitle: route.element.subtitle,
        desc: route.element.description,
        index: cardConfig.count + route.offset + 1,
        content: [
          .filledButton(
            title: [.init(text: "Push")],
            handler: { _, _ in
              RouteManager.sharedInstance.setRoute(route.element);
            }
          ),
        ]
      );
    };

    cardConfig.forEach {
      var cardConfig = $0;
      cardConfig.colorThemeConfig = cardColorThemeConfig;
      
      let cardView = cardConfig.createCardView();
      stackView.addArrangedSubview(cardView.rootVStack);
      stackView.setCustomSpacing(15, after: cardView.rootVStack);
    };
    
    let childCardItems: [UIViewController] = [];
    childCardItems.forEach {
      self.addChild($0);
      
      stackView.addArrangedSubview($0.view);
      stackView.setCustomSpacing(15, after: $0.view);
      
      $0.didMove(toParent: self);
    };
    
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView();
      
      scrollView.showsHorizontalScrollIndicator = false;
      scrollView.showsVerticalScrollIndicator = true;
      scrollView.alwaysBounceVertical = true;
      return scrollView
    }();
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.addSubview(stackView);
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalTo: scrollView.topAnchor,
        constant: 40
      ),
      
      stackView.bottomAnchor.constraint(
        equalTo: scrollView.bottomAnchor,
        constant: -100
      ),
      
      stackView.centerXAnchor.constraint(
        equalTo: scrollView.centerXAnchor
      ),
      
      stackView.widthAnchor.constraint(
        equalTo: scrollView.widthAnchor,
        constant: -24
      ),
    ]);
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(scrollView);
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor
      ),
      scrollView.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
      ),
      scrollView.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
      ),
      scrollView.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
      ),
    ]);
  };
};
