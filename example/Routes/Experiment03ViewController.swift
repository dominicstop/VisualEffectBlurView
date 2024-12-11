//
//  Experiment03ViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 12/9/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView

class Experiment03ViewController: UIViewController {

  weak var visualEffectView: VisualEffectView?;
  
  weak var blurRadiusLabel: UILabel?;
  weak var intensityLabel: UILabel?;
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;

    self.view = view;
  };
  
  override func viewDidLoad() {
  
    self.setupBackgroundView();
    
    let blurContainerView: UIView = {
      let containerView = UIView();
      
      let effectView = try! VisualEffectView(withEffect: CustomEffect());
      self.visualEffectView = effectView;
      
      func test01(){
        let angle: Angle<CGFloat> = .degrees(90 + 45);
        let filterType: LayerFilterType = .colorHueAdjust(angle: angle);
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            filterType,
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test02(){
        let angle: Angle<CGFloat> = .degrees(90 + 45);
        let filterType: LayerFilterType = .colorHueAdjust(angle: angle);
        let filterWrapped = filterType.createFilterWrapper()!;
        let filter = filterWrapped.wrappedObject!;
        
        filter.perform(
          NSSelectorFromString("setName:"),
          with: NSString(string: "colorHueRotate")
        );

        print(
          "\n - filterTypes:", LayerFilterWrapper.filterTypes,
          "\n - filter:", filter,
          "\n"
        );
        
        filter.setValue(angle.radians, forKey: "inputAngle")
        filter.setValue(Float(angle.radians), forKey: "inputAngle")
        effectView.layer.filters = [filter];
      };
      
      func test03(){
        let angle: Angle<Float> = .degrees(90 + 45);
        
        let colorMatrix: ColorMatrixRGBA = .identity
         // .concat(with: .contrast(withFactor: 1.5))
         // .concat(with: .brightness(withAmount: -4))
         // .concat(with: .hueRotate(withAngle: .degrees(120)))
        
        //colorMatrix.setBrightness(withAmount: -0.5);
        //colorMatrix.setContrast(withAmount: 0.5);
        //colorMatrix.setSaturation(withFactor: 0.5);
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test04(){
        let resultMatrix1 = ColorMatrixRGBA.identity.matrix4x5;
        
        func extendMatrixTo5x5(forMatrix matrixToExtend: [[Float]]) -> [[Float]] {
          var newMatrix: [[Float]] = .init(
            repeating: .init(repeating: 0, count: 5),
            count: 5
          );
          
          for (rowIndex, rows) in newMatrix.enumerated() {
            for (columnIndex, _) in rows.enumerated() {
              
              let fallbackElement: Float = rowIndex == columnIndex ? 1 : 0;
              
              let currentElement =
                matrixToExtend[safeIndex: rowIndex]?[safeIndex: columnIndex];
                
              let newElement = currentElement ?? fallbackElement;
              newMatrix[rowIndex][columnIndex] = newElement;
            };
          };
          
          return newMatrix;
        };
        
        func combineColorMatrices(
          matrix1: [[Float]],
          matrix2: [[Float]]
        ) -> [[Float]] {
          var resultMatrix: [[Float]] = [];
          resultMatrix = extendMatrixTo5x5(forMatrix: resultMatrix);
          
          for i in 0..<5 {
            for j in 0..<5 {
              for k in 0..<5 {
                resultMatrix[i][j] += matrix1[i][k] * matrix2[k][j];
              };
            };
          };
          
          return resultMatrix;
        };
        
        let contrastColorMatrix = extendMatrixTo5x5(
          forMatrix: ColorMatrixRGBA.createContrastColorMatrix5x4(amount: 0)
        );
        
        let grayScaleMatrix = extendMatrixTo5x5(
          forMatrix: ColorMatrixRGBA.createGrayscaleColorMatrix3x3(amount: 0)
        );
        
        let hueRotateMatrix = extendMatrixTo5x5(
          forMatrix: ColorMatrixRGBA.createHueRotateMatrix3x3(angle: .degrees(90))
        );
        
        var resultMatrix = contrastColorMatrix;
        resultMatrix = combineColorMatrices(matrix1: resultMatrix, matrix2: grayScaleMatrix);
        
        let colorMatrix = ColorMatrixRGBA.init(fromColorMatrix5x4: resultMatrix);
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test05(){
        let colorMatrix: ColorMatrixRGBA = .identity
         //.concat(with: .contrast(withFactor: 0))
         //.concat(with: .brightness(withAmount: 0.5))
         //.concat(with: .hueRotate(withAngle: .degrees(120)))
        

        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test06(){
        let colorTransform: ColorTransform =
          .init()
          .withContrast(0.1)
          .withBrightness(-0.3)
          .withSaturation(0.3)
          .withHueRotate(.degrees(90));
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorTransform.colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test07(){
        let colorMatrix = ColorMatrixRGBA.colorChannel(
          r: 0,
          g: 0,
          b: 0
        );
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test08(){
        var colorMatrix = ColorMatrixRGBA.colorShift(
          r: -1,
          g: 0,
          b: 0
        );
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test09(){
        let colorTransform: ColorTransform =
          .init()
          .withSaturation(-1)

        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorTransform.colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test10(){
        var colorMatrix = ColorMatrixRGBA.invert(
          withPercent: 1,
          shouldSaturate: false
        );
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test11(){
        var colorMatrix =
          ColorMatrixRGBA.invert(
            withPercent: 0.1,
            shouldSaturate: false
          )
          .concatByAddingLastColumn(
            with: .saturation(withFactor: 1)
          );
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test12(){
        var colorMatrix = ColorMatrixRGBA.invert(
          withPercent: 0.5,
          shouldSaturate: true
        );
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      test12();
      

      effectView.layer.shadowRadius = 0;
      
      effectView.translatesAutoresizingMaskIntoConstraints = false;
      containerView.addSubview(effectView);
      
      NSLayoutConstraint.activate([
        effectView.heightAnchor.constraint(
          equalTo: containerView.heightAnchor
        ),
        effectView.widthAnchor.constraint(
          equalTo: containerView.widthAnchor
        ),
        
        effectView.centerXAnchor.constraint(
          equalTo: containerView.centerXAnchor
        ),
        
        effectView.centerYAnchor.constraint(
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
    
    let nextBlurEffectButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Next Effect", for: .normal);
      
      if #available(iOS 15.0, *) {
        button.configuration = .filled();
        
      } else {
        button.backgroundColor = .blue;
      };
      
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
  };
  
  func setupBackgroundView(){
    let bgView: UIView = {
      let label = UILabel();
      label.text = "🖼️❤️\n🌆🧡\n🌄💚\n🏞️💛\n🌉💙";
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
  };

  @objc func onPressButtonNextEffect(_ sender: UIButton){
  };
};
