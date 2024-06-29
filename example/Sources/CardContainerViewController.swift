//
//  CardContainerViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/30/24.
//

import UIKit
import DGSwiftUtilities


public class CardContainerViewController: UIViewController {
  public var cardConfig: CardConfig;
  public var cardView: UIView?;
  
  public init(cardConfig: CardConfig){
    self.cardConfig = cardConfig;
    super.init(nibName: nil, bundle: nil);
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  public override func viewDidLoad() {
    self.applyCardConfig();
  };
  
  public func applyCardConfig(){
    if let cardView = self.cardView {
      cardView.removeFromSuperview();
      self.cardView = nil;
    };
    
    let cardView = self.cardConfig.createCardView();
    let cardRootView = cardView.rootVStack;
    self.cardView = cardRootView;
    
    self.view.addSubview(cardRootView);
    cardRootView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      cardRootView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      cardRootView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
      cardRootView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      cardRootView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
    ]);
  };
};
