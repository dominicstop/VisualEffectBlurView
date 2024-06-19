//
//  Routes.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 9/14/23.
//

import UIKit
import DGSwiftUtilities

enum Route: String, CaseIterable {
  
  case routeList;
  case visualEffectBlurTest;
  case blurViewBasicUsage01;
  case blurViewSwiftUIBasicUsage01;

  var viewController: UIViewController {
    switch self {
      case .routeList:
        return RouteListViewController();
      
      case .visualEffectBlurTest:
        return VisualEffectBlurTestViewController();
        
      case .blurViewBasicUsage01:
        return BasicUsage01();
        
      case .blurViewSwiftUIBasicUsage01:
        return SwiftUIBasicUsage01ViewController();
    };
  };
  
  var subtitle: String {
    switch self {
      case .routeList:
        return "Route List";
        
      case .visualEffectBlurTest:
        return "VisualEffectBlurView";
        
      case .blurViewBasicUsage01:
        return "VisualEffectBlurView basic usage";
        
      case .blurViewSwiftUIBasicUsage01:
        return "VisualEffectBlurView SwiftUI";
    };
  };
  
  var description: [AttributedStringConfig] {
    switch self {
      case .routeList:
        return [
          .init(text: "Shows a list of all the available routes."),
          .newLines(2),
          .init(
            text: "Route Names: ",
            fontConfig: .init(
              size: nil,
              isBold: true
            )
          ),
          .init(
            text: Self.allCases.enumerated().reduce(into: ""){
              $0 += " \($1.element.rawValue)";
              
              let isLast = $1.offset == Self.allCases.count;
              $0 += isLast ? "" : ",";
            },
            fontConfig: .init(
              size: nil,
              isItalic: true
            )
          ),
          .newLines(2),
          .init(
            text: "Total Routes: ",
            fontConfig: .init(
              size: nil,
              isBold: true
            )
          ),
          .init(text: "\(Self.allCases.count) items"),
        ];
        
      case .visualEffectBlurTest:
        return [
          .init(text: "`VisualEffectBlurView Test`"),
          .init(text: " - Change blurRadius + cycle through blur effect styles`"),
        ];
        
      case .blurViewBasicUsage01:
        return [
          .init(text: "Example - Basic usage for VisualEffectBlurView")
        ];
        
      case .blurViewSwiftUIBasicUsage01:
        return [
          .init(text: "Example - Basic usage for VisualEffectBlurView in SwiftUI")
        ];
    };
  };
};

