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
      
      var effectView = try! VisualEffectCustomFilterView(withInitialFilters: [])
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
          withPercent: 1
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
          ColorMatrixRGBA.invertColors(
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
        var colorMatrix = ColorMatrixRGBA.invertColors(
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
      
      /// Remove an effect + animate, fail
      func test13(){
        let filterInitial: [LayerFilterType] = [
          .lightVibrant(
            isReversed: true,
            color0: UIColor.red.cgColor,
            color1: UIColor.blue.cgColor
          ),
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        
          try! effectView.setFiltersViaEffectDesc(
            withFilterTypes: [
              .saturateColors(amount: 1),
            ],
            shouldImmediatelyApplyFilter: false
          );
          // return;
          
          // try! effectView.removeFilters(matching: [.lightVibrant]);
          
          UIView.animate(withDuration: 2) {
            //try! effectView.applyRequestedFilterEffects();
          };
        };
      };
      
      /// extract CA animation from animation block, success
      func test14(){
        let dormantView = UIView();
        // dormantView.displayNow();
        
        UIView.animate(withDuration: 1) {
          dormantView.backgroundColor = .red;
          dormantView.bounds = .init(origin: .zero, size: .init(width: 100, height: 100));
          dormantView.alpha = 0.5;
          dormantView.isHidden = false;
          dormantView.backgroundColor = .red;
          dormantView.transform = .init(translationX: 1, y: 1);
        };
        
        let animations = dormantView.layer.recursivelyGetAllChildAnimations();
        print("animations:", animations);
      };
      
      /// extract CA animation from animation config, success
      func test15(){
        let dormantView = UIView();
        // dormantView.displayNow();
        
        let animationConfig: AnimationConfig = .presetCurve(duration: 1, curve: .easeIn);
        let animator = animationConfig.createAnimator(gestureInitialVelocity: .zero);
        
        animator.addAnimations {
          dormantView.backgroundColor = .red;
          dormantView.bounds = .init(origin: .zero, size: .init(width: 100, height: 100));
          dormantView.alpha = 0.5;
          dormantView.isHidden = false;
          dormantView.backgroundColor = .red;
          dormantView.transform = .init(translationX: 1, y: 1);
        };
        
        animator.startAnimation();
 
        let animations = dormantView.layer.recursivelyGetAllChildAnimations();
        print("animations:", animations);
      };
      
      func test16(){
        let filterInitial: [LayerFilterType] = [
          .lightVibrant(
            isReversed: true,
            color0: UIColor.red.cgColor,
            color1: UIColor.blue.cgColor
          ),
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          try! effectView.immediatelyRemoveFilters(matching: [.lightVibrant]);
        };
      };
      
      func test17(){
        let filterInitial: [LayerFilterType] = [
          .lightVibrant(
            isReversed: true,
            color0: UIColor.red.cgColor,
            color1: UIColor.blue.cgColor
          ),
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        let animationConfig: AnimationConfig = .presetCurve(
         duration: 1,
         curve: .easeIn
        );
          
        let basisAnimation = animationConfig.createBasicAnimation()!;
        
        print(
          "test17",
          // nil - "\n - effectView.layer.filters:", effectView.layer.filters,
          // nil - "\n - effectView.bgHostWrapper:", (effectView.bgHostWrapper?.wrappedObject as? UIView),
          // "\n - effectView.bgHostWrapper:", effectView.bgHostWrapper?.wrappedObject,
          "\n - effectView.bgHostWrapper:", effectView.bgHostWrapper?.viewContentWrapped?.wrappedObject,
          "\n - effectView.bgHostWrapper:", effectView.bgHostWrapper?.viewContentWrapped?.wrappedObject?.layer.filters,
          "\n"
        );
        
        let filterView =
          effectView.bgHostWrapper!.viewContentWrapped!.wrappedObject!;
        
        let targetFilter = filterView.layer.filters!.first!;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          // not working
          // UIView.animate(withDuration: 1) {
          //   effectView.layer.filters = nil;
          // };
          
          // not working
          // effectView.layer.filters = nil;
          
          // works
          // filterView.layer.filters = nil;
          
          // works, no animation
          // UIView.animate(withDuration: 1) {
          //  filterView.layer.filters = nil;
          // };
          
          // works, no animation
          // basisAnimation.keyPath = #keyPath(CALayer.filters)
          // basisAnimation.fromValue = targetFilter;
          // basisAnimation.toValue = nil;
          // filterView.layer.filters = [];
          // filterView.layer.add(basisAnimation, forKey: "filterAnimation")
          
        };
      };
        
      /// animate out filters, result failed
      /// log
      /// ```
      /// test18
      /// - animations [(animationKey: "filters.colorMonochrome.inputAmount", animation: <CABasicAnimation:0x600000838d40; delegate = <UIViewAnimationState: 0x141d0ea00>; fillMode = both; timingFunction = easeInEaseOut; duration = 1; highFrameRateReason = 1048609; preferredFrameRateRangePreferred = 120; preferredFrameRateRangeMaximum = 120; preferredFrameRateRangeMinimum = 30; fromValue = 1; keyPath = filters.colorMonochrome.inputAmount>)]
      /// ```
      func test18(){
        let filterInitial: [LayerFilterType] = [
          .colorBlackAndWhite(amount: 1)
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        let filterView =
          effectView.bgHostWrapper!.viewContentWrapped!.wrappedObject!;
        
        let targetFilter = filterView.layer.filters!.first!;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          try! effectView.updateCurrentFiltersViaEffectDesc(
            withFilterTypes: [
              .colorBlackAndWhite(amount: 0)
            ],
            shouldAddMissingFilterTypes: false
          );
          
          UIView.animate(withDuration: 1){
            try! effectView.applyRequestedFilterEffects();
          };
          
          print(
            "test18",
            "\n - animations", effectView.layer.recursivelyGetAllChildAnimations(),
            "\n"
          );
        };
      };
      
      // animate out filters, result failed
      func test19(){
        let filterInitial: [LayerFilterType] = [
          .colorBlackAndWhite(amount: 1)
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        let filterView =
          effectView.bgHostWrapper!.viewContentWrapped!.wrappedObject!;
        
        let targetFilter = filterView.layer.filters!.first! as! NSObject;
        let targetFilterWrapped = LayerFilterWrapper(objectToWrap: targetFilter);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          try! targetFilterWrapped!.setFilterIsEnabled(false);
          try! effectView.applyRequestedFilterEffects();
          filterView.layer.filters = [targetFilter];
          
          try! targetFilterWrapped!.setFilterIsEnabled(false);
          try! effectView.applyRequestedFilterEffects();
          filterView.layer.filters = [targetFilter];
          
          try! targetFilterWrapped!.setFilterIsEnabled(false);
          try! effectView.applyRequestedFilterEffects();
          filterView.layer.filters = [targetFilter];
          
          try! targetFilterWrapped!.setFilterIsEnabled(false);
          try! effectView.applyRequestedFilterEffects();
          filterView.layer.filters = [targetFilter];
          
          try! targetFilterWrapped!.setFilterIsEnabled(false);
          try! effectView.applyRequestedFilterEffects();
          filterView.layer.filters = [targetFilter];
          
          try! targetFilterWrapped!.setFilterIsEnabled(false);
          try! effectView.applyRequestedFilterEffects();
          filterView.layer.filters = [targetFilter];
          
          
          print(
            "test19",
            "\n - getFilterIsEnabled:", try! targetFilterWrapped!.getFilterIsEnabled(),
            "\n"
          );
          
          return;
          try! effectView.updateCurrentFiltersViaEffectDesc(
            withFilterTypes: [
              .colorBlackAndWhite(amount: 0)
            ],
            shouldAddMissingFilterTypes: false
          );
          
          UIView.animate(withDuration: 1){
            try! effectView.applyRequestedFilterEffects();
          };
          
          print(
            "test18",
            "\n - animations", effectView.layer.recursivelyGetAllChildAnimations(),
            "\n"
          );
        };
      };
      
      // disable filter via copy, success
      func test20(){
        let filterInitial: [LayerFilterType] = [
          .colorBlackAndWhite(amount: 1)
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        let filterView =
          effectView.bgHostWrapper!.viewContentWrapped!.wrappedObject!;
        
        let targetFilter = filterView.layer.filters!.first! as! NSObject;
        let targetFilterWrapped = LayerFilterWrapper(objectToWrap: targetFilter);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          let targetFilterCopy = targetFilter.copy() as AnyObject;
          let targetFilterCopyWrapped = LayerFilterWrapper(objectToWrap: targetFilterCopy);
          
          try! targetFilterCopyWrapped!.setFilterIsEnabled(false);
          try! effectView.applyRequestedFilterEffects();
          filterView.layer.filters = [targetFilterCopy];
          
          print(
            "test19",
            "\n - getFilterIsEnabled:", try! targetFilterWrapped!.getFilterIsEnabled(),
            "\n"
          );
        };
      };
      
      // disable filter, failed
      func test21(){
        let filterInitial: [LayerFilterType] = [
          .colorBlackAndWhite(amount: 1)
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        let filterView =
          effectView.bgHostWrapper!.viewContentWrapped!.wrappedObject!;
        
        let targetFilter = filterView.layer.filters!.first! as! NSObject;
        let targetFilterWrapped = LayerFilterWrapper(objectToWrap: targetFilter);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          try! targetFilterWrapped!.setFilterIsEnabled(false);
          try! effectView.applyRequestedFilterEffects();
          filterView.layer.filters = [targetFilter];
          
          print(
            "test21",
            "\n - getFilterIsEnabled:", try! targetFilterWrapped!.getFilterIsEnabled(),
            "\n"
          );
        };
      };
      
      /// animate out filters, result failed
      func test22(){
        let filterInitial: [LayerFilterType] = [
          .colorBlackAndWhite(amount: 1)
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        let animationConfig: AnimationConfig = .presetCurve(
         duration: 1,
         curve: .easeIn
        );
          
        let basisAnimation = animationConfig.createBasicAnimation()!;
        
        let filterView =
          effectView.bgHostWrapper!.viewContentWrapped!.wrappedObject!;
        
        let targetFilterPrev = filterView.layer.filters!.first! as! NSObject;
        
        let targetFilterNext = targetFilterPrev.copy() as! NSObject;
        
        let targetFilterNextWrapped =
          LayerFilterWrapper(objectToWrap: targetFilterNext)!;
          
        try! targetFilterNextWrapped.setFilterIsEnabled(false);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {

          basisAnimation.keyPath = "filters.colorMonochrome"
          basisAnimation.fromValue = targetFilterPrev;
          basisAnimation.toValue = targetFilterNext;
          filterView.layer.filters = [targetFilterNext];
          
          filterView.layer.add(basisAnimation, forKey: "filterAnimation")
          
        };
      };
      
      /// animate out filters, failed, doesnt animate
      func test23(){
        let filterInitial: [LayerFilterType] = [
          .colorBlackAndWhite(amount: 1)
        ];
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: filterInitial,
          shouldImmediatelyApplyFilter: true
        );
        
        let animationConfig: AnimationConfig = .presetCurve(
         duration: 1,
         curve: .easeIn
        );
          
        let basisAnimation = animationConfig.createBasicAnimation()!;
        
        let filterView =
          effectView.bgHostWrapper!.viewContentWrapped!.wrappedObject!;
        
        let targetFilter = filterView.layer.filters!.first! as! NSObject;
        
        let targetFilterWrapped =
          LayerFilterWrapper(objectToWrap: targetFilter)!;
          
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {

          basisAnimation.keyPath = "filters.colorMonochrome.enabled"
          basisAnimation.fromValue = true;
          basisAnimation.toValue = false;
          
          // try! targetFilterWrapped.setFilterIsEnabled(false);
          filterView.layer.add(basisAnimation, forKey: "filterAnimation")
          
        };
      };
            
      func test24(){
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .luminosityCurveMap(
              amount: 1,
              values: [1, 0, 0, 1])
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test25(){
        let filterType: LayerFilterType = .gaussianBlur(
          radius: 16,
          shouldNormalizeEdges: true
        );
        
        let filterWrapped = filterType.createFilterWrapper()!;
        print("shouldNormalizeEdges:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyNormalizeEdges));
        try! filterWrapped.setFilterValue(shouldNormalizeEdges: false);
        try! filterWrapped.setFilterValue(shouldUseHardEdges: false);
        try! filterWrapped.setFilterValue(shouldNormalizeEdgesToTransparent: false);
        
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        effectLayer.filters = [filterWrapped.wrappedObject!];
        
      };
      
      // test "curves", failed
      func test26(){
        let filterWrapped = LayerFilterWrapper(
          rawFilterType: LayerFilterTypeName.colorBlendingModeMultiply.decodedString!
        )!;
        try! filterWrapped.setDefaults();
        
        print(
          "test26",
          "\n - propertyFilterInputKeyAmount:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyAmount),
          "\n - propertyFilterInputKeyValues:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyValues),
          "\n - propertyFilterInputKeyColorMatrix:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyColorMatrix),
          "\n"
        );
        
        try! filterWrapped.setFilterValue(amount: 1);
        try! filterWrapped.setFilterValue(values: [1, 0, 0, 1]);
      

        print("shouldNormalizeEdges:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyNormalizeEdges));
        try! filterWrapped.setFilterValue(shouldNormalizeEdges: false);
        try! filterWrapped.setFilterValue(shouldUseHardEdges: false);
        try! filterWrapped.setFilterValue(shouldNormalizeEdgesToTransparent: false);
        
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        effectLayer.filters = [filterWrapped.wrappedObject!];
        
      };
      
      // test blending mode, failed
      func test27(){
        let filterWrapped = LayerFilterWrapper(
          rawFilterType: "colorBurnBlendMode"//LayerFilterTypeName.luminosityCurveMap.decodedString!
        )!;
        try! filterWrapped.setDefaults();
        
        print(
          "test26",
          "\n - filterWrapped:", filterWrapped.wrappedObject!,
          "\n - propertyFilterInputKeyAmount:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyAmount),
          "\n - propertyFilterInputKeyValues:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyValues),
          "\n - propertyFilterInputKeyColorMatrix:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyColorMatrix),
          "\n"
        );
        
        try! filterWrapped.setFilterValue(amount: 1);
        try! filterWrapped.setFilterValue(values: [1, 0, 0, 1]);
        
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        effectLayer.perform("setCompositingFilter:", with: [filterWrapped.wrappedObject!]);
        effectLayer.filters = [filterWrapped.wrappedObject!];
        
      };
      
      /// filters are applied to content view?
      func test28(){
        effectView.effect = UIVibrancyEffect(
          blurEffect: UIBlurEffect(style: .prominent),
          style: .fill
        );
        
        let bgHostWrapper = effectView.bgHostWrapper!;
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        
        
        

        print(
          "test28",
          "\n - effectView:", effectView,
          "\n - effectLayer:", effectLayer,
          "\n - filters:", effectLayer.filters,
          "\n - compositingFilter:", effectLayer.compositingFilter,
          "\n - bgHostWrapper:", bgHostWrapper.wrappedObject!,
          "\n - viewContentWrapper:", effectView.viewContentWrapper!.wrappedObject,
          // "\n - viewContentWrapper.superview:", effectView.viewContentWrapper!.wrappedObject!.superview,
          "\n - viewContentWrapper.recursivelyGetAllSubviews:", effectView.recursivelyGetAllSubviews.map({ ($0, $0.layer) }),
          "\n - effectView.contentView:", effectView.contentView,
          "\n"
        );
        
      };
      
      // try to apply to filter to content only, failed
      func test29(){
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .luminosityCurveMap(
              amount: 1,
              values: [1, 0, 0, 1])
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      // works
      func test30(){
        // try! effectView.setFiltersViaEffectDesc(
        //   withFilterTypes: [
        //     .colorBlackAndWhite(amount: 1)
        //   ],
        //   shouldImmediatelyApplyFilter: true
        // );
      
        let filterType: LayerFilterType = .darkVibrant(
          isReversed: true,
          color0: UIColor.red.cgColor,
          color1: UIColor.blue.cgColor
        );
        
        let filterWrapped = filterType.createFilterWrapper()!;
        effectView.contentView.layer.filters = [filterWrapped.wrappedObject!];
        
        // crashed
        // effectView.contentView.perform(
        //   NSSelectorFromString("setFilters:"),
        //   with: [filterWrapped.wrappedObject!]
        // );
      };
      
      // works
      func test31(){
        effectView.effect = UIVibrancyEffect(
          blurEffect: UIBlurEffect(style: .prominent),
          style: .fill
        );
        
        let filterType: LayerFilterType = .lightVibrant(
          isReversed: false,
          color0: UIColor.red.cgColor,
          color1: UIColor.blue.cgColor
        );
        
        let filterWrapped = filterType.createFilterWrapper()!;
        effectView.contentView.layer.filters = [filterWrapped.wrappedObject!];
        
        let bgHostWrapper = effectView.bgHostWrapper!;
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        
        
        

        print(
          "test31",
          "\n - effectView:", effectView,
          "\n - effectLayer:", effectLayer,
          "\n - filters:", effectLayer.filters,
          "\n - compositingFilter:", effectLayer.compositingFilter,
          "\n - bgHostWrapper:", bgHostWrapper.wrappedObject!,
          "\n - viewContentWrapper:", effectView.viewContentWrapper!.wrappedObject,
          // "\n - viewContentWrapper.superview:", effectView.viewContentWrapper!.wrappedObject!.superview,
          "\n - viewContentWrapper.recursivelyGetAllSubviews:", effectView.recursivelyGetAllSubviews.map({ ($0, $0.layer) }),
          "\n - effectView.contentView:", effectView.contentView,
          "\n"
        );
        
      };
      
      // not working correctly
      func test32(){
        // effectView.effect = UIVibrancyEffect(
        //   blurEffect: UIBlurEffect(style: .prominent),
        //   style: .fill
        // );
        
         try! effectView.setFiltersViaEffectDesc(
           withFilterTypes: [
             .colorBlackAndWhite(amount: 1)
           ],
           shouldImmediatelyApplyFilter: true
         );
        
        let filterType: LayerFilterType = .lightVibrant(
          isReversed: true,
          color0: UIColor.red.cgColor,
          color1: UIColor.blue.cgColor
        );
        
        let filterWrapped = filterType.createFilterWrapper()!;
        effectView.contentView.layer.filters = [filterWrapped.wrappedObject!];
        
        let bgHostWrapper = effectView.bgHostWrapper!;
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        
        
        

        print(
          "test31",
          "\n - effectView:", effectView,
          "\n - effectLayer:", effectLayer,
          "\n - filters:", effectLayer.filters,
          "\n - compositingFilter:", effectLayer.compositingFilter,
          "\n - bgHostWrapper:", bgHostWrapper.wrappedObject!,
          "\n - viewContentWrapper:", effectView.viewContentWrapper!.wrappedObject,
          // "\n - viewContentWrapper.superview:", effectView.viewContentWrapper!.wrappedObject!.superview,
          "\n - viewContentWrapper.recursivelyGetAllSubviews:", effectView.recursivelyGetAllSubviews.map({ ($0, $0.layer) }),
          "\n - effectView.contentView:", effectView.contentView,
          "\n"
        );
        
      };
      
      func test33(){
        var vibEffect: UIVisualEffect = UIVibrancyEffect(
          blurEffect: UIBlurEffect(style: .prominent),
          style: .fill
        );
        
        //vibEffect = UIBlurEffect(style: .regular)
        effectView.effect = vibEffect;
        
        print(
          "effectView.contentView",
          "\n - disableGroupFiltering:", effectView.contentView.perform("disableGroupFiltering"),
          "\n - viewEffects:", effectView.contentView.perform("viewEffects"),
          "\n - filters:", effectView.contentView.perform("filters"),
          "\n"
        );
        
        print(
          "vibEffect",
          "\n - vibEffect:", vibEffect,
          "\n - _allEffects:", vibEffect.perform(NSSelectorFromString("_allEffects")),
          "\n - effectConfig:", vibEffect.perform(NSSelectorFromString("effectConfig")),
          "\n - effectSettings:", vibEffect.perform(NSSelectorFromString("effectSettings")),
          "\n"
        );

        let bgHostWrapper = effectView.bgHostWrapper!;
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        
        
        
        print(
          "\n - backgroundEffects", effectView.value(forKey: "backgroundEffects"),
          "\n - contentEffects", effectView.value(forKey: "contentEffects"),
          "\n - _allowsGroupFiltering", effectView.value(forKey: "_allowsGroupFiltering"),
          "\n - _backdropViewBackgroundColorAlpha", effectView.value(forKey: "_backdropViewBackgroundColorAlpha"),
          
          "\n - effectView.getCurrentEffectDescriptor:", {
            let effectDesc = try! effectView.getCurrentEffectDescriptor();
            
            return [
              ("_UIVisualEffectDescriptor", effectDesc.wrappedObject!),
              ("viewEffects", effectDesc.wrappedObject!.value(forKey: "viewEffects")),
              ("_identityContainerView", effectDesc.wrappedObject!.value(forKey: "_identityContainerView")),
              ("alphaTransition", effectDesc.wrappedObject!.value(forKey: "alphaTransition")),
              ("filterEntries", effectDesc.wrappedObject!.value(forKey: "filterEntries")),
              ("containerView", effectDesc.wrappedObject!.value(forKey: "containerView")),
              ("underlays", effectDesc.wrappedObject!.value(forKey: "underlays")),
              ("overlays", effectDesc.wrappedObject!.value(forKey: "overlays")),
              ("textShouldRenderWithTintColor", effectDesc.wrappedObject!.value(forKey: "textShouldRenderWithTintColor")),
              ("allowsVibrancyInContent", effectDesc.wrappedObject!.value(forKey: "allowsVibrancyInContent")),
              ("disableInPlaceFiltering", effectDesc.wrappedObject!.value(forKey: "disableInPlaceFiltering")),
              ("requestAlphaTransition", effectDesc.wrappedObject!.value(forKey: "requestAlphaTransition")),
              
              
              //("uniqueFilterNames", effectDesc.wrappedObject!.perform(NSSelectorFromString("uniqueFilterNames"))),
              ("_requestedContainerView", effectDesc.wrappedObject!.perform(NSSelectorFromString("_requestedContainerView"))),
              
              //("effectConfig", effectDesc.wrappedObject!.value(forKey: "effectConfig")),
              //("description", effectDesc.wrappedObject!.value(forKey: "description")),
              
              (
                "_vibrantShadowEffect",
                (NSClassFromString("UIVibrancyEffect")! as AnyObject).perform(NSSelectorFromString("_vibrantShadowEffect"))
              ),
              (
                "vibrantMediumShadowEffect",
                (NSClassFromString("UIVibrancyEffect")! as AnyObject).perform(NSSelectorFromString("vibrantMediumShadowEffect"))
              ),
              (
                "vibrantHeavyShadowEffect",
                (NSClassFromString("UIVibrancyEffect")! as AnyObject).perform(NSSelectorFromString("vibrantHeavyShadowEffect"))
              ),
              (
                "vibrantChromeShadowEffect",
                (NSClassFromString("UIVibrancyEffect")! as AnyObject).perform(NSSelectorFromString("vibrantChromeShadowEffect"))
              ),
              
            ].reduce(into: "") {
              $0 += "\n - \($1)";
            };
          }(),
          "\n"
        );
        
        print(
          "effectLayer, UICABackdropLayer:", effectLayer,
          "\n - effectLayer.filters:", effectLayer.filters,
          "\n - mt_colorMatrixDrivenOpacity:", effectLayer.value(forKey: "mt_colorMatrixDrivenOpacity"),
          
          "\n - groupName:", effectLayer.value(forKey: "groupName"),
          "\n - usesGlobalGroupNamespace:", effectLayer.value(forKey: "usesGlobalGroupNamespace"),
          "\n - scale:", effectLayer.value(forKey: "scale"),
          "\n - backdropRect:", effectLayer.value(forKey: "backdropRect"),
          "\n - marginWidth:", effectLayer.value(forKey: "marginWidth"),
          "\n - disablesOccludedBackdropBlurs:", effectLayer.value(forKey: "disablesOccludedBackdropBlurs"),
          "\n - captureOnly:", effectLayer.value(forKey: "captureOnly"),
          "\n - allowsInPlaceFiltering:", effectLayer.value(forKey: "allowsInPlaceFiltering"),
          "\n - reducesCaptureBitDepth:", effectLayer.value(forKey: "reducesCaptureBitDepth"),
          "\n - ignoresScreenClip:", effectLayer.value(forKey: "ignoresScreenClip"),
          "\n - zoom:", effectLayer.value(forKey: "zoom"),
          "\n - tracksLuma:", effectLayer.value(forKey: "tracksLuma"),
          
          
          
          
          //"\n - ", effectLayer.perform(NSSelectorFromString("")),
          "\n"
        );
        
        print(
          "effectView.contentView, _UIVisualEffectContentView",
          "\n - effectView.contentView:", effectView.contentView,
          "\n - effectView.contentView.layer:", effectView.contentView.layer,
          "\n - effectView.contentView.layer.filters:", effectView.contentView.layer.filters,
          "\n - effectView.contentView.layer.filters:", {
            let filter = effectView.contentView.layer.filters!.first! as AnyObject;
            let filterWrapped = LayerFilterWrapper(objectToWrap: filter)!;
            
            return [
              ("InputKeyAmount:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyAmount)),
              ("InputKeyAngle:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyAngle)),
              ("InputKeyValues:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyValues)),
              ("InputKeyRadius:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyRadius)),
              ("InputKeyColorMatrix:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyColorMatrix)),
              ("InputKeyReversed:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyReversed)),
              ("InputKeyColor0:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyColor0)),
              ("InputKeyColor1:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyColor1)),
              ("InputKeyNormalizeEdges:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyNormalizeEdges)),
              ("InputKeyShouldNormalizeEdgesToTransparent:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyShouldNormalizeEdgesToTransparent)),
              ("InputKeyShouldUseHardEdges:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyShouldUseHardEdges)),
              ("InputKeyMaskImage:", try! filterWrapped.getValue(forHashedString: .propertyFilterInputKeyMaskImage)),
              
            
            ].reduce(into: "") {
              $0 += "\n - \($1)";
            };
          }(),
          "\n"
        );
        
        print(
          "test33",
          "\n - effectView:", effectView,
          "\n - bgHostWrapper:", bgHostWrapper.wrappedObject!,
          "\n - viewContentWrapper:", effectView.viewContentWrapper!.wrappedObject,
          // "\n - viewContentWrapper.superview:", effectView.viewContentWrapper!.wrappedObject!.superview,
      
          "\n"
        );
        
        effectView.recursivelyGetAllSubviews.enumerated().forEach {
          print(
            "\($0.offset) - view:", $0.element.debugDescription,
            "\n - layer:", $0.element.layer.debugDescription,
            "\n - layer.filters:", $0.element.layer.filters.debugDescription,
            "\n"
          );
        };
        
      };
      
      func test34(){
        var vibEffect: UIVisualEffect = UIVibrancyEffect(
          blurEffect: UIBlurEffect(style: .prominent),
          style: .fill
        );
        
        effectView.effect = vibEffect;
        
        
       try! effectView.setFiltersViaEffectDesc(
         withFilterTypes: [
           .colorBlackAndWhite(amount: 1)
         ],
         shouldImmediatelyApplyFilter: true
       );
       
        
        let filterType: LayerFilterType = .lightVibrant(
          isReversed: false,
          color0: UIColor(white: 0.25, alpha: 1).cgColor,
          color1: UIColor.init(red: 0, green: 0, blue: 0.313725, alpha: 0.05).cgColor
        );
        
        let filterWrapped = filterType.createFilterWrapper()!;
        effectView.contentView.layer.filters = [filterWrapped.wrappedObject!];
        
        let bgHostWrapper = effectView.bgHostWrapper!;
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        
        effectLayer.setValue(1, forKey: "allowsInPlaceFiltering")
        
        let effectDesc = try! bgHostWrapper.getEffectDescriptorCurrent()!.wrappedObject!;
        effectDesc.setValue(0, forKey: "disableInPlaceFiltering");
        effectDesc.setValue(0, forKey: "allowsVibrancyInContent");
        effectDesc.setValue(0, forKey: "requestAlphaTransition");
        
        let effectDescWrapped = UVEDescriptorWrapper(objectToWrap: effectDesc)!;

        // effectView.effect = nil;
        // effectView.effect = vibEffect;
        
        effectLayer.setValue(1, forKey: "allowsInPlaceFiltering")
        
        
        try! bgHostWrapper.setEffectDescriptor(effectDescWrapped);
        // try! bgHostWrapper.applyProvidedEffectDescriptor(effectDescWrapped);
        try! effectView.applyRequestedFilterEffects();
        
        effectView.displayNow();

        print(
          "test31",
          
          "\n"
        );
        
      };
      
      // test bias
      func test35(){
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .bias(amount: 0.5)
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test37(){
        let filterWrapped = LayerFilterWrapper(
          rawFilterType:
            // LayerFilterTypeName.invertColors.decodedString!
            // LayerFilterTypeName.invertColorsDisplayAware.decodedString! // nope
            // LayerFilterTypeName.pairedOpacity.decodedString! // nope
            // LayerFilterTypeName.lanczosResampling.decodedString! // nope
            // LayerFilterTypeName.lanczosResampling.decodedString! // nope
            // LayerFilterTypeName.lanczosResampling.decodedString! // nope
            // LayerFilterTypeName.luminanceMap.decodedString! // nope
            // LayerFilterTypeName.colorHueAdjust.decodedString! // yes
            // LayerFilterTypeName.colorBlendingModeMultiply.decodedString! // mope
            // LayerFilterTypeName.distanceField.decodedString! // yes
            // LayerFilterTypeName.meteor.decodedString! // nopw
            LayerFilterTypeName.alphaFromLuminance.decodedString!
        )!;
        
        try! filterWrapped.setDefaults();
        try! filterWrapped.setFilterValue(amount: 1);
        try! filterWrapped.setFilterValue(values: [1, 0, 0, 1]);
        try! filterWrapped.setFilterValue(color0: .red);
        try! filterWrapped.setFilterValue(color1: .blue);
        try! filterWrapped.setFilterValue(angle: Angle.degrees(90.0).radians);
        try! filterWrapped.setFilterValue(angle: Angle.degrees(90.0).radians);
        try! filterWrapped.setFilterValue(isReversed: false);
        try! filterWrapped.setFilterValue(radius: 32);

        
        let effectLayer = effectView.bgLayerWrapper!.wrappedObject!;
        effectLayer.filters = [filterWrapped.wrappedObject!];
      };
      
      func test38(){
        let colorTransform: ColorTransform =
          .init()
          .withInvert(1)
          .withSaturation(-1)
          //.withHueRotate(.degrees(90));
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorTransform.colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      
      // remove filters, failed
      func test39(){
        let colorTransform: ColorTransform =
          .init()
          .withInvert(1)
          .withSaturation(-1)
          //.withHueRotate(.degrees(90));
        
        let effectDescWrapped = try! effectView.getCurrentEffectDescriptor();
        let effectDesc = effectDescWrapped.wrappedObject!;
        
        effectDesc.setValue([], forKey: "filterEntries");
        effectDesc.setValue([], forKey: "viewEffects");
        effectDesc.setValue([], forKey: "underlays");
        effectDesc.setValue([], forKey: "overlays");
        
        let bgHostWrapper = effectView.bgHostWrapper!;
        try! bgHostWrapper.setEffectDescriptor(effectDescWrapped);
        try! bgHostWrapper.applyProvidedEffectDescriptor(effectDescWrapped);
        try! effectView.applyRequestedFilterEffects();
      };
      
      func test40(){
        let effectDescWrapped = try! effectView.getCurrentEffectDescriptor();
        let effectDesc = effectDescWrapped.wrappedObject!;
        
        effectDesc.setValue([], forKey: "filterEntries");
        effectDesc.setValue([], forKey: "viewEffects");
        effectDesc.setValue([], forKey: "underlays");
        effectDesc.setValue([], forKey: "overlays");
        
        let bgHostWrapper = effectView.bgHostWrapper!;
        try! bgHostWrapper.setEffectDescriptor(effectDescWrapped);
        try! bgHostWrapper.applyProvidedEffectDescriptor(effectDescWrapped);
        try! effectView.applyRequestedFilterEffects();
        
        effectView.bgLayerWrapper?.wrappedObject?.filters = [];
        
        let colorTransform: ColorTransform =
          .init()
          .withInvert(1)
          .withSaturation(-1)
          //.withHueRotate(.degrees(90));
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorTransform.colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test41(){
        
        try! effectView.immediatelyRemoveAllFilters();
        print(
          "currentFilters:", effectView.bgLayerWrapper?.currentFilters
        );
        
        return;
        let colorTransform: ColorTransform =
          .init()
          .withInvert(1)
          .withSaturation(-1)
          //.withHueRotate(.degrees(90));
        
        try! effectView.setFiltersViaEffectDesc(
          withFilterTypes: [
            .colorMatrix(colorTransform.colorMatrix),
          ],
          shouldImmediatelyApplyFilter: true
        );
      };
      
      func test42(){
        effectView = try! .init(withInitialFilters: [
          .colorBlackAndWhite(amount: 1)
        ]);
        
        var waitTime: TimeInterval = 0;
        
        waitTime += 1;
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
          let colorTransform: ColorTransform =
            .init()
            .withInvert(1)
            .withSaturation(-1)
            //.withHueRotate(.degrees(90));
          
          try! effectView.immediatelyApplyFilters([
            .colorMatrix(colorTransform.colorMatrix),
          ]);
        };
        
        waitTime += 1;
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
          try! effectView.immediatelyApplyFilters([]);
        };
        
        waitTime += 1;
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
          try! effectView.immediatelyApplyFilters([
             .colorBlackAndWhite(amount: 1)
          ]);
        };
      };
      
      test42();
      

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
    
    // self.setupEffectContents();
  };
  
  func setupBackgroundView(){
    let bgView: UIView = {
      let label = UILabel();
      // label.text = "🖼️❤️🌸\n🌆🧡🌹\n🌄💚🌷\n🏞️💛🌼\n🌉💙💐";
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
  
  func setupEffectContents(){
    guard let visualEffectView = self.visualEffectView else {
      return;
    };
    
    let contentView: UIView = {
      let label = UILabel();
      
      let dummyString: [AttributedStringConfig]  = (0..<15).map {
        .init(
          text: "\n \($0 + 1)-hello world, hello",
          fontConfig: .init(
            size: 40,
            weight: [.light, .medium, .regular, .bold, .heavy][cyclicIndex: $0],
            symbolicTraits: nil
          ),
          color: [.black, .init(white: 0.5, alpha: 1)][cyclicIndex: $0]
        )
      };

      label.attributedText = dummyString.makeAttributedString();
      
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping;
      label.sizeToFit();
      
      return label;
    }();
  
    contentView.translatesAutoresizingMaskIntoConstraints = false;
    visualEffectView.contentView.addSubview(contentView)
    return;
    
    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
      contentView.heightAnchor.constraint(
        equalTo: self.view.heightAnchor
      ),
      
      contentView.centerXAnchor.constraint(
        equalTo: self.view.centerXAnchor
      ),
      
      contentView.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor
      ),
    ]);
  };

  @objc func onPressButtonNextEffect(_ sender: UIButton){
  };
};
