//
//  RouteManager.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/19/24.
//

import UIKit

var RouteManagerShared = RouteManager.sharedInstance;

class RouteManager {
  static let sharedInstance = RouteManager();
  
  weak var window: UIWindow?;
  
  var shouldUseNavigationController = true;
  var navController: UINavigationController?;
  
  var routeCounter = 0;
  var routes: [Route] = .Element.allCases;
  
  var rootRoute: Route = Route.routeList;
  var initialRoute: Route? = nil//.experiment03
  
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
        fatalError();
      };
      
      if let navController = self.navController {
        return navController;
      };
      
      var routes = [self.rootRoute];
      if let initialRoute = self.initialRoute {
        routes.append(initialRoute);
      };
      
      let routeViewControllers = routes.map {
        $0.viewController;
      };
      
      let navVC = UINavigationController();
      navVC.setViewControllers(routeViewControllers, animated: false);
      
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


