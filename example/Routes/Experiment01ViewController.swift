//
//  Experiment01ViewController.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 10/24/24.
//

import UIKit
import DGSwiftUtilities
import VisualEffectBlurView

class Experiment01ViewController: UIViewController {

  enum ElementKey: String, CaseIterable {
    case background;
    case overlay;
    
    case card01;
    case card02;
    case card03;
    case card04;
    case card05;
    case card06;
    case card07;
    
    static var allCards: [Self] = [
      .card01,
      .card02,
      .card03,
      .card04,
      .card05,
      .card06,
      .card07,
    ];
  };
  
  public struct FilterGroupEntry {
    static let backgroundFilterNames: [LayerFilterTypeName] = [
      .gaussianBlur,
      .colorBlackAndWhite,
      .contrastColors,
      .saturateColors,
      .variadicBlur,
      .brightenColors,
      .colorMatrix,
      .luminanceCompression,
      .luminosityCurveMap,
      .bias,
    ];

    static let foregroundFilterNames: [LayerFilterTypeName] = [
      .gaussianBlur,
      .colorBlackAndWhite,
      .contrastColors,
      .saturateColors,
      .variadicBlur,
      .brightenColors,
      .colorMatrix,
      .luminosityCurveMap,
      .bias,
    ];
  
    var elementKey: ElementKey;
    var backgroundFilters: [LayerFilterType];
    var foregroundFilters: [LayerFilterType];
    
    init(
      elementKey: ElementKey,
      backgroundFilterTypes: [LayerFilterType] = [],
      foregroundFilterTypes: [LayerFilterType] = []
    ) {
      self.elementKey = elementKey;
      self.backgroundFilters = backgroundFilterTypes;
      self.foregroundFilters = foregroundFilterTypes;
    }
    
    init(
      elementKey: ElementKey,
      backgroundFilters: [LayerFilterConfig] = [],
      foregroundFilters: [LayerFilterConfig] = []
    ) {
      self.elementKey = elementKey;
      self.backgroundFilters = backgroundFilters.associatedFilterType;
      self.foregroundFilters = foregroundFilters.associatedFilterType;
    };
    
    func updateFilters(
      toEffectView effectView: VisualEffectCustomFilterView
    ) throws {
      try effectView.updateBackgroundFiltersViaEffectDesc(
        withFilterTypes: self.backgroundFilters
      );

      try effectView.updateForegroundFiltersViaEffectDesc(
       withFilterTypes: self.foregroundFilters
      );
    };
    
    static func resetToIdentity(forElementID elementKey: ElementKey) -> Self {
      .init(
        elementKey: elementKey,
        backgroundFilterTypes:
          Self.backgroundFilterNames.asBackgroundIdentityFilterTypes,
          
        foregroundFilterTypes:
          Self.foregroundFilterNames.asForegroundIdentityFilterTypes
      );
    };
  };
  
  public struct FilterGroup {
    static let defaultDuration: CGFloat = 1.5;
    static let defaultDelay: CGFloat = 0.4;
  
    var duration: CGFloat;
    var delay: CGFloat;
    var filterGroups: [FilterGroupEntry];
    
    init(
      duration: Double = Self.defaultDuration,
      delay: Double = Self.defaultDelay,
      filterGroups: [FilterGroupEntry]
    ) {
      self.duration = duration;
      self.delay = delay;
      self.filterGroups = filterGroups;
    };
    
    init(
      forMatchingElementKeys elementKeys: [ElementKey],
      duration: Double = Self.defaultDuration,
      delay: Double = Self.defaultDelay,
      backgroundFilters: [LayerFilterConfig] = [],
      foregroundFilters: [LayerFilterConfig] = [],
      otherFilterGroups: [FilterGroupEntry] = []
    ) {
      
      self.duration = duration;
      self.delay = delay;
      
      self.filterGroups = elementKeys.map {
        .init(
          elementKey: $0,
          backgroundFilters: backgroundFilters,
          foregroundFilters: foregroundFilters
        );
      };
      
      self.filterGroups += otherFilterGroups;
    };

    static func resetToIdentity(
      forMatchingElementKeys elementKeys: [ElementKey],
      duration: Double = Self.defaultDuration,
      delay: Double = Self.defaultDelay
    ) -> Self {
      
      .init(
        duration: duration,
        delay: delay,
        filterGroups: elementKeys.map {
          .resetToIdentity(forElementID: $0);
        }
      );
    };
  };
  
  static var keyframes: [FilterGroup] = [
  

    // blur cards with radius 6...12
    .init(
      filterGroups: ElementKey.allCards.enumerated().map {
        .init(
          elementKey: $0.element,
          foregroundFilterTypes: [
            .gaussianBlur(
              radius: .lerp(
                valueStart: 3,
                valueEnd: 8,
                percent: .percent(
                  index: $0.offset,
                  count: ElementKey.allCards.count
                )
              ),
              shouldNormalizeEdges: false
            ),
          ]
        );
      }
    ),
    
    // unblur cards, and blur bg
    .init(
      forMatchingElementKeys: ElementKey.allCards,
      foregroundFilters: [
        .gaussianBlur(
          radius: 0,
          shouldNormalizeEdges: false
        ),
      ],
      otherFilterGroups: [
        .init(
          elementKey: .background,
          backgroundFilters: [
            .gaussianBlur(
              radius: 16,
              shouldNormalizeEdges: true
            ),
          ]
        )
      ]
    ),
    
    // unblur bg
    .init(
      filterGroups: [
        .init(
          elementKey: .background,
          backgroundFilters: [
            .gaussianBlur(
              radius: 0,
              shouldNormalizeEdges: true
            ),
          ]
        )
      ]
    ),
    
    // invert cards, blur card bg, desaturate + darken bg
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              .gaussianBlur(
                radius: .lerp(
                  valueStart: 4,
                  valueEnd: 16,
                  percent: .percent(
                    index: $0.offset,
                    count: ElementKey.allCards.count
                  )
                ),
                shouldNormalizeEdges: false
              ),
              .saturateColors(
                amount: .lerp(
                  valueStart: 0,
                  valueEnd: 2,
                  percent: .percent(
                    index: $0.offset,
                    count: ElementKey.allCards.count
                  )
                )
              ),
            ],
            foregroundFilters: [
              .colorTransform(
                .default
                .withInvert(0.8)
                .withSaturation(-1)
                .withHueRotate(.degrees(-15))
              ),
              .saturateColors(amount: 2)
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              .brightenColors(amount: -0.2),
              .saturateColors(amount: 0.4)
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    // vblur bg rtl, desaturate + darken card bg lerp
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              .gaussianBlur(
                radius: 0,
                shouldNormalizeEdges: false
              ),
              .saturateColors(
                amount: .lerp(
                  valueStart: 0,
                  valueEnd: 0.5,
                  percent: .percent(
                    index: $0.offset,
                    count: ElementKey.allCards.count
                  )
                )
              ),
              .brightenColors(
                amount: .lerp(
                  valueStart: 0.25,
                  valueEnd: -0.3,
                  percent: .percent(
                    index: $0.offset,
                    count: ElementKey.allCards.count
                  )
                )
              )
            ],
            foregroundFilters: [
              .colorTransform(.default),
              .saturateColors(amount: 1)
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              .brightenColors(amount: 0),
              .saturateColors(amount: 1),
              .variadicBlur(
                radius: 16,
                imageGradientConfig: .leftToRightGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.2),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    // blur card fg even, brighten card bg odd, shift colors
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              .saturateColors(amount: 1),
              .brightenColors(amount: ($0.offset % 2 == 0) ? 0.25 : 0),
            ],
            foregroundFilters: [
              .gaussianBlur(
                radius: ($0.offset % 2 == 0) ? 0 : 6,
                shouldNormalizeEdges: false
              ),
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .leftToRightGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.2),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
              .colorTransform(
                .init()
                .withHueRotate(.degrees(-30))
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
      
    // radial blur bg center clear, hue rotate bg
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              .brightenColors(amount: 0), // reset
            ],
            foregroundFilters: [
              .gaussianBlur(
                radius: 0, //reset
                shouldNormalizeEdges: false
              ),
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              .colorTransform(
                .init()
                .withHueRotate(.degrees(15))
              ),
              .variadicBlur(
                radius: 12,
                imageGradientConfig: .centerToOuterEdgeGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.15),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    // brigten card bg, darken hearts, blur card content
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              .brightenColors(amount: 0.15),
              .variadicBlur(
                radius: 8,
                imageGradientConfig: .rightToLeftGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.25),
                    .init(white: 0, alpha: 1),
                  ],
                  size: .init(width: 400, height: 100)
                ),
                shouldNormalizeEdges: true
              ),
            ],
            foregroundFilters: [
              .colorBlackAndWhite(amount: 0.3),
              .brightenColors(amount: -0.4),
              .gaussianBlur(radius: 6, shouldNormalizeEdges: false),
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              .colorTransform(
                .init()
                .withHueRotate(.degrees(-45))
              ),
              // reset
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .centerToOuterEdgeGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.15),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    // blur bg radial outer to in, shift card content colors
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              // reset
              .brightenColors(amount: 0),
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .rightToLeftGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.3),
                    .init(white: 0, alpha: 1),
                  ],
                  size: .init(width: 400, height: 100)
                ),
                shouldNormalizeEdges: true
              ),
              
              // new values
              .saturateColors(amount: 2),
            ],
            foregroundFilters: [
              // reset
              .colorBlackAndWhite(amount: 0),
              .brightenColors(amount: 0),
              .gaussianBlur(
                radius: 0,
                shouldNormalizeEdges: false
              ),
              
              // new values
              .colorTransform(
                .init()
                .withHueRotate(.degrees(-30))
              ),
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              .colorTransform(.init()),
              .variadicBlur(
                radius: 12,
                imageGradientConfig: .centerToOuterEdgeGradient(
                  colors: [
                    .init(white: 0, alpha: 1),
                    .init(white: 0, alpha: 0.8),
                    .init(white: 0, alpha: 0),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: false
              ),
              .contrastColors(amount: 0.75),
            ],
            foregroundFilters: [
              
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              // reset
              .saturateColors(amount: 1),
              
              // new values
              .contrastColors(amount: 0.8),
              .brightenColors(amount: 0.1)
            ],
            foregroundFilters: [
              // reset
              .colorTransform(
                .init()
                .withHueRotate(.degrees(0))
              ),
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              // reset
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .centerToOuterEdgeGradient(
                  colors: [
                    .init(white: 0, alpha: 1),
                    .init(white: 0, alpha: 0.8),
                    .init(white: 0, alpha: 0),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: false
              ),
              .contrastColors(amount: 1),
            ],
            foregroundFilters: [
              
            ]
          )
        );
        
        filterGroups.append(
          .init(
            elementKey: .overlay,
            backgroundFilters: [
              .variadicBlur(
                radius: 12,
                imageGradientConfig: .topDownGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.2),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    // red fg, vblurred bg top to bottom
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              // reset
              .contrastColors(amount: 1),
              
              // new values
              .brightenColors(amount: -0.2)
            ],
            foregroundFilters: [
              .brightenColors(amount: 0.4),
              .colorTransform(
                .default
                .withChannelIntensity(r: 1, g: 0, b: 0)
              )
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              .variadicBlur(
                radius: 8,
                imageGradientConfig: .topDownGradient(
                  colors: [
                    .init(white: 0, alpha: 1),
                    .init(white: 0, alpha: 0.1),
                    .init(white: 0, alpha: 0),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ],
            foregroundFilters: [
              
            ]
          )
        );
        
        filterGroups.append(
          .init(
            elementKey: .overlay,
            backgroundFilters: [
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .topDownGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.2),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              // reset
              .brightenColors(amount: -0.3)
            ],
            foregroundFilters: [
              // reset
              .brightenColors(amount: 0.3),
              .colorTransform(
                .init()
                .withInvert(1)
                .withSaturation(2)
              )
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              // reset
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .topDownGradient(
                  colors: [
                    .init(white: 0, alpha: 1),
                    .init(white: 0, alpha: 0.1),
                    .init(white: 0, alpha: 0),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
              
              // new values
              .colorTransform(
                .init()
                .withChannelShift(r: 0.5, g: 0, b: 0)
                .withIntensityRed(0.5)
              ),
            ]
          )
        );
        
        filterGroups.append(
          .init(
            elementKey: .overlay,
            backgroundFilters: [
              .variadicBlur(
                radius: 10,
                imageGradientConfig: .leftToRightGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.3),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              // reset
              .brightenColors(amount: 0),
              
              // new values
              .saturateColors(
                amount: .lerp(
                  valueStart: 0,
                  valueEnd: 2,
                  percent: .percent(
                    index: $0.offset,
                    count: ElementKey.allCards.count
                  )
                )
              ),
              .brightenColors(
                amount: .lerp(
                  valueStart: 0.5,
                  valueEnd: -0.5,
                  percent: .percent(
                    index: $0.offset,
                    count: ElementKey.allCards.count
                  )
                )
              ),
            ],
            foregroundFilters: [
              // reset
              .colorTransform(.default),
              
              // new values
              .brightenColors(
                amount: .lerp(
                  valueStart: -0.5,
                  valueEnd: 0.5,
                  percent: .percent(
                    index: $0.offset,
                    count: ElementKey.allCards.count
                  )
                )
              ),
              .saturateColors(
                amount: .lerp(
                  valueStart: 1,
                  valueEnd: 0,
                  percent: .percent(
                    index: $0.offset,
                    count: ElementKey.allCards.count
                  )
                )
              ),
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              // reset
              .colorTransform(.default),
              
              .variadicBlur(
                radius: 8,
                imageGradientConfig: .leftToRightGradient(
                  colors: [
                    .init(white: 0, alpha: 1),
                    .init(white: 0, alpha: 0.25),
                    .init(white: 0, alpha: 0),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
              
              
            ]
          )
        );
        
        filterGroups.append(
          .init(
            elementKey: .overlay,
            backgroundFilters: [
              // reset
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .leftToRightGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.3),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    .init(
      filterGroups: {
        var filterGroups: [FilterGroupEntry] = [];
        
        filterGroups += ElementKey.allCards.enumerated().map {
          .init(
            elementKey: $0.element,
            backgroundFilters: [
              // reset
              .saturateColors(amount: 0),
              .brightenColors(amount: 0),
              .colorTransform(
                .default
                .withInvert(1)
              )
            ],
            foregroundFilters: [
              // reset
              .brightenColors(amount: 0),
              .saturateColors(amount: 0.5),
            ]
          );
        };
        
        filterGroups.append(
          .init(
            elementKey: .background,
            backgroundFilters: [
              // reset
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .leftToRightGradient(
                  colors: [
                    .init(white: 0, alpha: 1),
                    .init(white: 0, alpha: 0.25),
                    .init(white: 0, alpha: 0),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
              .colorTransform(
                .default
                .withHueRotate(.degrees(90))
              )
              
            ]
          )
        );
        
        filterGroups.append(
          .init(
            elementKey: .overlay,
            backgroundFilters: [
              // reset
              .variadicBlur(
                radius: 0,
                imageGradientConfig: .leftToRightGradient(
                  colors: [
                    .init(white: 0, alpha: 0),
                    .init(white: 0, alpha: 0.3),
                    .init(white: 0, alpha: 1),
                  ],
                  size: UIScreen.main.bounds.size
                ),
                shouldNormalizeEdges: true
              ),
            ]
          )
        );
        
        return filterGroups;
      }()
    ),
    
    .resetToIdentity(forMatchingElementKeys: ElementKey.allCases),
  ];
  
  // retains values
  var effectViewRegistry: Dictionary<ElementKey, EffectViewRegistryEntry> = [:];

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
    self.setupBackgroundEffectView();
  
    self.setupEffectContents();
    self.setupOverlayEffectView();
    
    self.startAnimation();
  };
  
  func setupBackgroundView() {
    let backgroundImageView = UIImageView(frame: self.view.bounds);
  
    backgroundImageView.image = UIImage(named: "BackgroundImage01");
    backgroundImageView.contentMode = .scaleAspectFill;
    
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.insertSubview(backgroundImageView, at: 0);
    
    NSLayoutConstraint.activate([
      backgroundImageView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      backgroundImageView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
      backgroundImageView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      backgroundImageView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      )
    ]);
    
    let extraOffsetX: CGFloat = 10;
    
    let transformStart = Transform3D(
      translateX: -extraOffsetX,
      translateY: 0,
      scaleX: 1.15,
      scaleY: 1.15
    );
    
    let transformEnd = Transform3D(
      translateX: extraOffsetX,
      translateY: 0,
      scaleX: 1.15,
      scaleY: 1.15
    );
    
    backgroundImageView.layer.transform = transformStart.transform3D;
    
    UIView.animateKeyframes(
      withDuration: 5,
      delay: 0.0,
      options: [.autoreverse, .repeat],
      animations: {
        backgroundImageView.layer.transform = transformEnd.transform3D;
      },
      completion: nil
    );
  };
  
  func setupBackgroundEffectView(){
    let blurEffect = UIBlurEffect(style: .regular);
    let effectView: VisualEffectCustomFilterView = try! .init(withEffect: blurEffect);
    
    self.visualEffectView = effectView;
    self.effectViewRegistry[.background] = effectView;
 
    effectView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(effectView);
    
    NSLayoutConstraint.activate([
      effectView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      effectView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
      effectView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      effectView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
    ]);
  };
  
  func setupEffectContents(){
    guard let visualEffectView = self.visualEffectView else {
      return;
    };
    
    let contentStackView: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .fill;
      stack.spacing = 20;
    
      return stack;
    }();
    
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    visualEffectView.contentView.addSubview(contentStackView);
    
    let marginHorizontal: CGFloat = 20;
    NSLayoutConstraint.activate([
      contentStackView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor,
        constant: marginHorizontal
      ),
      contentStackView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor,
        constant: -marginHorizontal
      ),
      
      contentStackView.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor
      ),
      
      contentStackView.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
      ),
    ]);
    
    ElementKey.allCards.enumerated().forEach {
      let cardEffectView = CardEffectView();
      cardEffectView.setIndex($0.offset);
      
      self.effectViewRegistry[$0.element] = cardEffectView;
      
      cardEffectView.translatesAutoresizingMaskIntoConstraints = false
      contentStackView.addArrangedSubview(cardEffectView);
      
      NSLayoutConstraint.activate([
        cardEffectView.heightAnchor.constraint(
          equalToConstant: 70
        ),
        cardEffectView.widthAnchor.constraint(
          equalTo: contentStackView.widthAnchor
        ),
      ]);
      
      cardEffectView.layer.cornerRadius = 16
      cardEffectView.layer.masksToBounds = true
      cardEffectView.layer.shadowColor = UIColor.black.cgColor
      cardEffectView.layer.shadowOpacity = 0.3
      cardEffectView.layer.shadowOffset = CGSize(width: 0, height: 4)
      cardEffectView.layer.shadowRadius = 6;
    };
  };
  
  func setupOverlayEffectView(){
    let blurEffect = UIBlurEffect(style: .regular);
    let effectView: VisualEffectCustomFilterView = try! .init(withEffect: blurEffect);
    
    self.effectViewRegistry[.overlay] = effectView;
 
    effectView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(effectView);
    self.view.bringSubviewToFront(effectView);
    
    NSLayoutConstraint.activate([
      effectView.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      effectView.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
      effectView.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      effectView.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
    ]);
  };
  
  func startAnimation(){
    var queueForKeyframes = Self.keyframes;
    
    let currentIndex = Self.keyframes.count - queueForKeyframes.count;
    self.navigationController?.navigationItem.title = "\(currentIndex)/\(Self.keyframes.count - 1)";
    
    let effectViewsPaired = self.effectViewRegistry.keys.map {
      let registryEntry = self.effectViewRegistry[$0]!;
      return (key: $0, effectView: registryEntry.associatedEffectView);
    };
    
    effectViewsPaired.forEach {
      print(
        "Setting to identity:", $0.key
      );
    
      try! $0.effectView.setBackgroundFiltersViaEffectDesc(
        withFilterTypes:
          FilterGroupEntry.backgroundFilterNames.asBackgroundIdentityFilterTypes,
        shouldImmediatelyApplyFilter: true
      );

      try! $0.effectView.setForegroundFiltersViaEffectDesc(
        withFilterTypes:
          FilterGroupEntry.foregroundFilterNames.asForegroundIdentityFilterTypes,
        shouldImmediatelyApplyFilter: true
      );
      
      // $0.effectView.backgroundLayerSamplingSizeScale = 1.5;
    };

    func recursivelyDequeue(){
      guard queueForKeyframes.count > 0 else {
        return;
      };
      
      let queueCount = queueForKeyframes.count;
      let currentKeyframe = queueForKeyframes.removeFirst();
      
      let animationEasing: UIView.AnimationCurve = (queueCount % 2 == 0)
        ? .easeIn
        : .easeOut;
        
      var effectViews: [VisualEffectCustomFilterView] = [];
        
      currentKeyframe.filterGroups.forEach {
        let registryEntry = self.effectViewRegistry[$0.elementKey]!;
        let effectView = registryEntry.associatedEffectView;
        effectViews.append(effectView);
        
        try! effectView.updateBackgroundFiltersViaEffectDesc(
          withFilterTypes: $0.backgroundFilters
        );
        
        try! effectView.updateForegroundFiltersViaEffectDesc(
          withFilterTypes: $0.foregroundFilters
        );
        
        print(
          "Setting filters",
          "\n - elementKey:", $0.elementKey,
          "\n - backgroundFilters:", $0.backgroundFilters,
          "\n - foregroundFilters:", $0.foregroundFilters,
          "\n - effectView instance:", effectView,
          "\n - effectView.currentBackgroundFilterTypes:", effectView.currentBackgroundFilterTypes,
          "\n - effectView.currentForegroundFilterTypes:", effectView.currentForegroundFilterTypes,
          "\n"
        );
      };
      
      let performAnimation = {
        UIView.animateKeyframes(
          withDuration: currentKeyframe.duration,
          delay: 0,
          options: []
        ) {
        
          effectViews.enumerated().forEach { (index, effectView) in
            let startTime: CGFloat = .lerp(
              valueStart: 0,
              valueEnd: 0.5,
              percent: .percent(
                index: index,
                count: effectViews.count
              )
            );
            
            UIView.addKeyframe(
              withRelativeStartTime: startTime,
              relativeDuration: 1
            ) {
              try! effectView.applyRequestedBackgroundFilterEffects();
              try! effectView.applyRequestedForegroundFilterEffects();
            };
            
          };
        } completion: { _ in
          recursivelyDequeue();
        };
      };
      
      if currentKeyframe.delay > 0 {
        DispatchQueue.main.asyncAfter(
          deadline: .now() + currentKeyframe.delay
        ) {
          performAnimation();
        };
        
      } else {
        performAnimation();
      };
    };

    recursivelyDequeue();
  };
};

class CardEffectView: UIView, EffectViewRegistryEntry {
  
  var effectView: VisualEffectCustomFilterView!;
  
  var labelLeft: UILabel!;
  var labelRight: UILabel!;
  
  var associatedEffectView: VisualEffectCustomFilterView {
    self.effectView!;
  };

  // Custom initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit();
  };
    
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.commonInit();
  };
    
  private func commonInit() {
    let blurEffect = UIBlurEffect(style: .regular);
    let effectView: VisualEffectCustomFilterView = try! .init(withEffect: blurEffect);
  
    self.effectView = effectView;
  
    effectView.frame = self.bounds;
    effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
    self.addSubview(effectView);
    
    let contentView = effectView.contentView;
    
    let labelRight: UILabel = {
      let label = UILabel();
      // Setup the label
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textAlignment = .center
      label.textColor = .black;
      
      label.font = FontConfig(
        size: 32 + 6,
        weight: .heavy,
        symbolicTraits: []
      ).makeFont();
      
      label.text = "Foreground";
      return label;
    }();
    
    self.labelRight = labelRight;
    
    labelRight.translatesAutoresizingMaskIntoConstraints = false;
    contentView.addSubview(labelRight);
    
    let marginHorizontal: CGFloat = 16;
    NSLayoutConstraint.activate([
      labelRight.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      labelRight.trailingAnchor.constraint(
        equalTo: self.trailingAnchor,
        constant: -marginHorizontal
      ),
    ]);
    
    let labelLeft: UILabel = {
      let label = UILabel();
      // Setup the label
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textAlignment = .center
      label.textColor = .black;
      
      label.font = FontConfig(
        size: 32 + 16,
        weight: .heavy,
        symbolicTraits: []
      ).makeFont();
      
      label.text = "♥️";
      return label;
    }();
    
    self.labelLeft = labelLeft;
    
    labelLeft.translatesAutoresizingMaskIntoConstraints = false;
    contentView.addSubview(labelLeft);
    
    NSLayoutConstraint.activate([
      labelLeft.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      labelLeft.leadingAnchor.constraint(
        equalTo: self.leadingAnchor,
        constant: marginHorizontal
      ),
    ]);
  };
  
  func setIndex(_ index: Int){
    let emojiList: [String] = [
      "❤️",
      "🧡",
      "💛",
      "💚",
      "💙",
      "💜",
      "💖",
    ];
  
    self.labelLeft.text = emojiList[cyclicIndex: index];
    self.labelRight.text = "Foreground 0\(index)";
    
    let opacity = 0.3;
    let pastelColorListRGBA: [String] = [
      "rgba(255, 182, 193, \(opacity)",  // Pastel Red
      "rgba(255, 179, 71 , \(opacity)",  // Pastel Orange
      "rgba(255, 255, 153, \(opacity)",  // Pastel Yellow
      "rgba(144, 238, 144, \(opacity)",  // Pastel Green
      "rgba(173, 216, 230, \(opacity)",  // Pastel Blue
      "rgba(216, 191, 216, \(opacity)"   // Pastel Violet
    ];
    
    
    let pastelColorList: [UIColor] = pastelColorListRGBA.compactMap {
      .parseColor(value: $0);
    };
    
    self.backgroundColor = pastelColorList[cyclicIndex: index];
  };
}

protocol EffectViewRegistryEntry: AnyObject {
  var associatedEffectView: VisualEffectCustomFilterView { get }
};

extension VisualEffectCustomFilterView: EffectViewRegistryEntry {
  
  var associatedEffectView: VisualEffectCustomFilterView {
    self;
  };
};



extension ImageConfigGradient {
  
  static func centerToOuterEdgeGradient(
    colors: [UIColor],
    locations: [NSNumber]? = nil,
    cornerRadius: CGFloat = 0,
    size: CGSize
  ) -> Self {
    .init(
      type: .radial,
      colors: colors.map { $0.cgColor },
      locations: locations,
      startPoint: CGPoint(x: 0.5, y: 0.5),
      endPoint: CGPoint(x: 1.0, y: 1.0),
      size: size,
      cornerRadius: cornerRadius
    );
  };
};
