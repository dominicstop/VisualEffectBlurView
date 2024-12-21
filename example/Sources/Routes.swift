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
  case visualEffectBlurTest02;
  case visualEffectBlurTest03;
  
  case visualEffectAnimatableBlurTest01;
  
  case visualEffectViewExperiment01;
  case visualEffectViewExperiment02;
  
  case visualEffectCustomFilterViewTest01;
  
  case blurViewBasicUsage01;
  case blurViewSwiftUIBasicUsage01;
  
  case experiment01;
  case experiment02;
  case experiment03;

  var viewController: UIViewController {
    switch self {
      case .routeList:
        return RouteListViewController();
      
      case .visualEffectBlurTest:
        return VisualEffectBlurTestViewController();
        
      case .visualEffectBlurTest02:
        return VisualEffectBlurTest02ViewController();
        
      case .visualEffectBlurTest03:
        return VisualEffectBlurTest03ViewController();
        
      case .visualEffectAnimatableBlurTest01:
        return VisualEffectAnimatableBlurTest01Controller();
        
      case .visualEffectViewExperiment01:
        return VisualEffectViewExperiment01ViewController();
        
      case .visualEffectViewExperiment02:
        return VisualEffectViewExperiment02ViewController();
        
      case .visualEffectCustomFilterViewTest01:
        return VisualEffectCustomFilterViewTest01Controller();
        
      case .blurViewBasicUsage01:
        return BlurViewBasicUsage01ViewController();
        
      case .blurViewSwiftUIBasicUsage01:
        return BlurViewSwiftUIBasicUsage01ViewController();
        
      case .experiment01:
        return Experiment01ViewController();
        
      case .experiment02:
        return Experiment02ViewController();
        
      case .experiment03:
        return Experiment03ViewController();
    };
  };
  
  var subtitle: String {
    switch self {
      case .routeList:
        return "Route List";
        
      case .visualEffectBlurTest,
           .visualEffectBlurTest02,
           .visualEffectBlurTest03:
           
        return "VisualEffectBlurView";
        
      case .visualEffectAnimatableBlurTest01:
        return "VisualEffectAnimatableBlurView";
        
      case .visualEffectViewExperiment01:
        return "UIVisualEffectView experiment";
        
      case .visualEffectViewExperiment02:
        return "UIVisualEffectView + Blur Filters Data";
        
      case .blurViewBasicUsage01:
        return "VisualEffectBlurView basic usage";
        
      case .blurViewSwiftUIBasicUsage01:
        return "VisualEffectBlurView SwiftUI";
        
      case .experiment02:
        return "Background filter animation";
        
      default:
        return "N/A";
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
          .init(text: "`VisualEffectBlurView Blur Radius Test`"),
          .init(text: " - Change blurRadius + cycle through blur effect styles`"),
        ];
      
      case .visualEffectBlurTest02:
        return [
          .init(text: "VisualEffectBlurView Blur Effect Intensity Test"),
        ];
        
      case .visualEffectBlurTest03:
        return [
          .init(text: "VisualEffectBlurView Blur Effect Intensity + animation test"),
        ];
        
      case .visualEffectAnimatableBlurTest01:
        return [
          .init(text: "TBA"),
        ];
        
      case .visualEffectViewExperiment01:
        return [
          .init(text: "VisualEffectView + LayerFilterType preset test"),
          .init(text: "Cycle through `LayerFilterType` test presets"),
        ];
        
      case .visualEffectViewExperiment02:
        return [
          .init(text: "Cycle through the diff. blur effect styles and show filter info ")
        ];
        
      case .blurViewBasicUsage01:
        return [
          .init(text: "Example - Basic usage for VisualEffectBlurView")
        ];
        
      case .blurViewSwiftUIBasicUsage01:
        return [
          .init(text: "Example - Basic usage for VisualEffectBlurView in SwiftUI")
        ];
        
      case .experiment02:
        return [
          .init(text: "Test for animating the background filters"),
          .newLines(2),
          .init(text: "batches of filters get applied and animated in/out on a set duration"),
        ];
        
      default:
        return [];
    };
  };
};

