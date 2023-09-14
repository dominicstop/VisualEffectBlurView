//
//  Routes.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 9/14/23.
//

import UIKit

enum Route: CaseIterable {

  case visualEffectBlurTest;
  case basicUsage01;

  var viewController: UIViewController {
    switch self {
      case .visualEffectBlurTest:
        return VisualEffectBlurTestViewController();
        
      case .basicUsage01:
        return BasicUsage01();
    };
  };
};

class RouteManager {
  static let sharedInstance = RouteManager();
  
  weak var window: UIWindow?;
  
  var routes: [Route] = [
    .visualEffectBlurTest,
    .basicUsage01,
  ];
  
  var routeCounter = 0;
  
  var currentRouteIndex: Int {
    self.routeCounter % self.routes.count;
  };
  
  var currentRoute: Route {
    self.routes[self.currentRouteIndex];
  };
  
  func applyCurrentRoute(){
    guard let window = self.window else { return };
  
    let nextVC = self.currentRoute.viewController;
    window.rootViewController = nextVC;
  };
  
  func nextRoute(){
    self.routeCounter += 1;
    self.applyCurrentRoute();
  };
};
