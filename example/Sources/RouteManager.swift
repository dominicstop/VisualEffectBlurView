//
//  RouteManager.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit

class RouteManager {
  static let sharedInstance = RouteManager();
  
  weak var window: UIWindow?;
  
  var shouldUseNavigationController = true;
  var navController: UINavigationController?;
  
  var routes: [Route] = [
    //.visualEffectViewExperiment01,
    .routeList,
  ];
  
  var routeCounter = 0;
  
  var currentRouteIndex: Int {
    self.routeCounter % self.routes.count;
  };
  
  var currentRoute: Route {
    self.routes[self.currentRouteIndex];
  };
  
  func applyCurrentRoute(){
    self.setRoute(self.currentRoute);
  };
  
  func setRoute(_ route: Route){
    guard let window = self.window else { return };
    
    let isUsingNavController =
      window.rootViewController is UINavigationController;
    
    let navVC: UINavigationController? = {
      guard self.shouldUseNavigationController else {
        return nil;
      };
      
      if let navController = self.navController {
        return navController;
      };
      
      let navVC = UINavigationController(
        rootViewController: self.currentRoute.viewController
      );
      
      self.navController = navVC;
      return navVC;
    }();
    
    if !isUsingNavController {
      window.rootViewController = navVC;
    };
    
    let nextVC = route.viewController;
    
    if self.shouldUseNavigationController,
       isUsingNavController {
      
      navVC?.pushViewController(nextVC, animated: true);
    
    } else if !self.shouldUseNavigationController {
      window.rootViewController = nextVC;
    };
  };
};


