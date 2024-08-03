



## Spelunking - `UIVisualEffectView`

* Link: [Header list](https://developer.limneos.net/?ios=13.1.3&framework=UIKitCore.framework&header=UIVisualEffectView.h)
* View Hierarchy - `(UIVisualEffectView *)0x107049780)`
  * `(_UIVisualEffectBackdropView *)0x107054c10)_`
  * `(_UIVisualEffectSubview *)0x107054dd0)`



* `@property (nonatomic,copy) NSArray * backgroundEffects`
  * **Setter**: `-(void)setBackgroundEffects:(NSArray *)arg`
  * **Type**: `Array<UIVisualEffect>` (e.g. `UIBlurEffect`)
  * **Status**: Implemented
  * **Observation**: The current effect.



* `@property (nonatomic,copy) NSArray * contentEffects`

  * **Setter**: `-(void)setContentEffects:(NSArray *)arg1`
  * **Status**: Implemented

  

* `-(void)_generateWorkaroundKeyframeAnimationsForEffects:(id)arg1`
  * `[UIVisualEffectView _generateWorkaroundKeyframeAnimationsForEffects:]`
  * **Note**: No longer available on iOS 14+.



* `-(void)_generateDeferredAnimations:(id)arg1`
  * `[UIVisualEffectView _generateDeferredAnimations:]`
  * **Observations**: 
    * Gets invoked whenever `UIView.animate` is called (e.g. `VisualEffectViewExperiment02ViewController`).
    * Does not get invoked for custom effects (e.g. `VisualEffectViewExperiment02ViewController`).
    * Can be called multiple times for each "property" being animated/

```
// Callstack
Thread 1 Queue : com.apple.main-thread (serial)
#0	0x00000001042453f8 in -[UIVisualEffectView _generateDeferredAnimations:] ()
#1	0x000000010517fce0 in -[UIViewAnimationState _finalizeDeferredAnimations] ()
#2	0x000000010517fd8c in -[UIViewAnimationState pop] ()
#3	0x000000010517de78 in +[UIViewAnimationState popAnimationState] ()
#4	0x00000001051a9188 in +[UIView _setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:] ()
#5	0x000000010268d198 in VisualEffectViewExperiment02ViewController.updateBlurEffect() at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/Routes/VisualEffectViewExperiment02ViewController.swift:380
#6	0x000000010268c468 in closure #1 in closure #4 in VisualEffectViewExperiment02ViewController.viewDidLoad() at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/Routes/VisualEffectViewExperiment02ViewController.swift:252
#7	0x00000001026e8074 in ClosureInjector.invoke() at /Users/dominicgo/Library/Developer/Xcode/DerivedData/VisualEffectBlurViewExample-fnwcamkgjdtfdjglnemnpctwikua/SourcePackages/checkouts/DGSwiftUtilities/Sources/Common/ClosureInjector/ClosureInjector.swift:28
#8	0x00000001026e80b0 in @objc ClosureInjector.invoke() ()
#9	0x0000000104ca4e90 in -[UIApplication sendAction:to:from:forEvent:] ()
#10	0x00000001045ca9d4 in -[UIControl sendAction:to:forEvent:] ()
#11	0x00000001045cad18 in -[UIControl _sendActionsForEvents:withEvent:] ()
#12	0x00000001045c7858 in -[UIButton _sendActionsForEvents:withEvent:] ()
#13	0x00000001045cad54 in -[UIControl _sendActionsForEvents:withEvent:] ()
#14	0x00000001045c7858 in -[UIButton _sendActionsForEvents:withEvent:] ()
#15	0x00000001045c9a54 in -[UIControl touchesEnded:withEvent:] ()
#16	0x0000000104cd852c in -[UIWindow _sendTouchesForEvent:] ()
#17	0x0000000104cd9a10 in -[UIWindow sendEvent:] ()
#18	0x0000000104cb968c in -[UIApplication sendEvent:] ()
#19	0x0000000104d39014 in __dispatchPreprocessedEventFromEventQueue ()
#20	0x0000000104d3bec4 in __processEventQueue ()
#21	0x0000000104d34f58 in __eventFetcherSourceCallback ()
#22	0x00000001803c669c in __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ ()
#23	0x00000001803c65e4 in __CFRunLoopDoSource0 ()
#24	0x00000001803c5d54 in __CFRunLoopDoSources0 ()
#25	0x00000001803c043c in __CFRunLoopRun ()
#26	0x00000001803bfd28 in CFRunLoopRunSpecific ()
#27	0x000000018986ebc0 in GSEventRunModal ()
#28	0x0000000104c9ffdc in -[UIApplication _run] ()
#29	0x0000000104ca3c54 in UIApplicationMain ()
#30	0x0000000104165ab8 in UIApplicationMain(_:_:_:_:) ()
#31	0x0000000102684334 in static UIApplicationDelegate.main() ()
#32	0x00000001026842ac in static AppDelegate.$main() ()
#33	0x00000001026843b0 in main at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/VisualEffectBlurViewExample/AppDelegate.swift:11
#34	0x0000000102ad9558 in start_sim ()
#35	0x0000000102c460e0 in start ()


(lldb) register read
General Purpose Registers:
        x0 = 0x000000010c024450
        x1 = 0x00000001056649b7  "_generateDeferredAnimations:"
        x2 = 0x0000600000228c20
        x3 = 0x000000016d782e1f
        x4 = 0x0000000000000010
        x5 = 0x0000000000000000
        x6 = 0x0000000000000000
        x7 = 0x0000600000c606f0
        x8 = 0xf14625c76cff00d3
        x9 = 0x000000000659d788
       x10 = 0x000000010e88c768
       x11 = 0x00000000000000b6
       x12 = 0x000000010e88c760
       x13 = 0x0000000000000000
       x14 = 0x0000000000000000
       x15 = 0xffffffffffffffff
       x16 = 0x00000001027d8472  (void *)0x5d9000000001027d
       x17 = 0x00000001042453f8  UIKitCore`-[UIVisualEffectView _generateDeferredAnimations:]
       x18 = 0x0000000000000000
       x19 = 0x000000010c204d20
       x20 = 0x0000000105a7d510  UIKitCore`__block_literal_global
       x21 = 0x0000600002c10d80
       x22 = 0x0000000000000001
       x23 = 0x000000010c024450
       x24 = 0x0000600000228c20
       x25 = 0x0000000000000001
       x26 = 0x0000000000000000
       x27 = 0x0000000000000000
       x28 = 0x0000000000000000
        fp = 0x000000016d782fd0
        lr = 0x000000010517fce0  UIKitCore`-[UIViewAnimationState _finalizeDeferredAnimations] + 216
        sp = 0x000000016d782eb0
        pc = 0x00000001042453f8  UIKitCore`-[UIVisualEffectView _generateDeferredAnimations:]
      cpsr = 0x40001000
      

(lldb) p $arg1
(unsigned long) 4496442448

(lldb) po $arg1
<VisualEffectBlurView.VisualEffectView: 0x10c024450; baseClass = UIVisualEffectView; frame = (0 0; 414 896); layer = <CALayer: 0x600000286740>> effect=<UIBlurEffect: 0x600000014080> style=UIBlurEffectStyleRegular

(lldb) po $arg2
4385556919

(lldb) p $arg2
(unsigned long) 4385556919

(lldb) p (char *)$arg2
(char *) 0x00000001056649b7 "_generateDeferredAnimations:"

(lldb) p $arg3
(unsigned long) 105553118530592
(lldb) po $arg3
{
    effect = "<_UIViewDeferredBasicAnimation: 0x60000174c180> key=effect duration=0.300000 initialValue=<UIBlurEffect: 0x600000009470> style=UIBlurEffectStyleRegular animationFrames=(\n    \"<_UIViewAnimationFrame: 0x600000228d40> value=<UIBlurEffect: 0x600000014080> style=UIBlurEffectStyleRegular startTime=0.000000 duration=0.300000\"\n)";
}

// Action: Next effect

(lldb) po (_UIViewDeferredBasicAnimation *)$arg3
{
    effect = "<_UIViewDeferredBasicAnimation: 0x600001750740> key=effect duration=0.300000 initialValue=<UIBlurEffect: 0x6000000248b0> style=UIBlurEffectStyleProminent animationFrames=(\n    \"<_UIViewAnimationFrame: 0x600000234620> value=<UIBlurEffect: 0x60000001c0d0> style=UIBlurEffectStyleExtraLight startTime=0.000000 duration=0.300000\"\n)";
}

// Action: Stepthrough

(lldb) po (_UIViewDeferredBasicAnimation *)$arg3
{
    backgroundEffects = "<_UIViewDeferredBasicAnimation: 0x600001755b40> key=backgroundEffects duration=0.300000 initialValue=(\n    \"<UIBlurEffect: 0x6000000248b0> style=UIBlurEffectStyleProminent\"\n) animationFrames=(\n    \"<_UIViewAnimationFrame: 0x60000028b080> value=(\\n    \\\"<UIBlurEffect: 0x60000001c0d0> style=UIBlurEffectStyleExtraLight\\\"\\n) startTime=0.000000 duration=0.300000\"\n)";
}
```



* `-(void)_generateEffectAnimations:(id)arg1`
  * `[UIVisualEffectView _generateEffectAnimations:]`
  * **Observations**:
    * Does not get invoked when using custom animations.
    * Callstack similar to: `_generateDeferredAnimations`, but only gets invoked once.

```
// Callstack
Thread 1 Queue : com.apple.main-thread (serial)
#0	0x00000001049a0d30 in -[UIVisualEffectView _generateEffectAnimations:] ()
#1	0x00000001049a1510 in -[UIVisualEffectView _generateDeferredAnimations:] ()
#2	0x00000001058dbce0 in -[UIViewAnimationState _finalizeDeferredAnimations] ()
#3	0x00000001058dbd8c in -[UIViewAnimationState pop] ()
#4	0x00000001058d9e78 in +[UIViewAnimationState popAnimationState] ()
#5	0x0000000105905188 in +[UIView _setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:] ()
#6	0x0000000102ea1198 in VisualEffectViewExperiment02ViewController.updateBlurEffect() at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/Routes/VisualEffectViewExperiment02ViewController.swift:380
#7	0x0000000102ea0468 in closure #1 in closure #4 in VisualEffectViewExperiment02ViewController.viewDidLoad() at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/Routes/VisualEffectViewExperiment02ViewController.swift:252
#8	0x0000000102efc074 in ClosureInjector.invoke() at /Users/dominicgo/Library/Developer/Xcode/DerivedData/VisualEffectBlurViewExample-fnwcamkgjdtfdjglnemnpctwikua/SourcePackages/checkouts/DGSwiftUtilities/Sources/Common/ClosureInjector/ClosureInjector.swift:28
#9	0x0000000102efc0b0 in @objc ClosureInjector.invoke() ()
#10	0x0000000105400e90 in -[UIApplication sendAction:to:from:forEvent:] ()
#11	0x0000000104d269d4 in -[UIControl sendAction:to:forEvent:] ()
#12	0x0000000104d26d18 in -[UIControl _sendActionsForEvents:withEvent:] ()
#13	0x0000000104d23858 in -[UIButton _sendActionsForEvents:withEvent:] ()
#14	0x0000000104d26d54 in -[UIControl _sendActionsForEvents:withEvent:] ()
#15	0x0000000104d23858 in -[UIButton _sendActionsForEvents:withEvent:] ()
#16	0x0000000104d25a54 in -[UIControl touchesEnded:withEvent:] ()
#17	0x000000010543452c in -[UIWindow _sendTouchesForEvent:] ()
#18	0x0000000105435a10 in -[UIWindow sendEvent:] ()
#19	0x000000010541568c in -[UIApplication sendEvent:] ()
#20	0x0000000105495014 in __dispatchPreprocessedEventFromEventQueue ()
#21	0x0000000105497ec4 in __processEventQueue ()
#22	0x0000000105490f58 in __eventFetcherSourceCallback ()
#23	0x00000001803c669c in __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ ()
#24	0x00000001803c65e4 in __CFRunLoopDoSource0 ()
#25	0x00000001803c5d54 in __CFRunLoopDoSources0 ()
#26	0x00000001803c043c in __CFRunLoopRun ()
#27	0x00000001803bfd28 in CFRunLoopRunSpecific ()
#28	0x000000018986ebc0 in GSEventRunModal ()
#29	0x00000001053fbfdc in -[UIApplication _run] ()
#30	0x00000001053ffc54 in UIApplicationMain ()
#31	0x00000001048c1ab8 in UIApplicationMain(_:_:_:_:) ()
#32	0x0000000102e98334 in static UIApplicationDelegate.main() ()
#33	0x0000000102e982ac in static AppDelegate.$main() ()
#34	0x0000000102e983b0 in main at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/VisualEffectBlurViewExample/AppDelegate.swift:11
#35	0x00000001032ed558 in start_sim ()
#36	0x00000001034be0e0 in start ()


(lldb) register read
General Purpose Registers:
        x0 = 0x0000000109355e10
        x1 = 0x0000000105dc0a8c  "_generateEffectAnimations:"
        x2 = 0x0000600001754a40
        x3 = 0x00000001801997a0  libsystem_malloc.dylib`nanov2_calloc
        x4 = 0x0000000000000002
        x5 = 0x0000000000000000
        x6 = 0x0000000000000000
        x7 = 0x0000600000c645a0
        x8 = 0x4a717af24b9c0077
        x9 = 0x000000000664c940
       x10 = 0x00000001170116c8
       x11 = 0x000000000000008c
       x12 = 0x00000001170116c0
       x13 = 0x0000000000000000
       x14 = 0x0000000000000000
       x15 = 0xffffffffffffffff
       x16 = 0x0000000102fec472  (void *)0x1d900000000102fe
       x17 = 0x00000001049a0d30  UIKitCore`-[UIVisualEffectView _generateEffectAnimations:]
       x18 = 0x0000000000000000
       x19 = 0x0000000109355e10
       x20 = 0x0000000000000000
       x21 = 0x0000000000000000
       x22 = 0x0000600001754a40
       x23 = 0x0000600000018150
       x24 = 0x0000000000000001
       x25 = 0x0000000000000001
       x26 = 0x0000000000000000
       x27 = 0x0000000000000000
       x28 = 0x0000000000000000
        fp = 0x000000016cf6eea0
        lr = 0x00000001049a1510  UIKitCore`-[UIVisualEffectView _generateDeferredAnimations:] + 280
        sp = 0x000000016cf6ee50
        pc = 0x00000001049a0d30  UIKitCore`-[UIVisualEffectView _generateEffectAnimations:]
      cpsr = 0x40001000
      
(lldb) po $arg1
<VisualEffectBlurView.VisualEffectView: 0x109355e10; baseClass = UIVisualEffectView; frame = (0 0; 414 896); layer = <CALayer: 0x60000022ff40>> effect=<UIBlurEffect: 0x600000014480> style=UIBlurEffectStyleExtraLight
(lldb) po $arg2
4393273996
(lldb) po (char *) $arg2
"_generateEffectAnimations:"
(lldb) po (char *) $arg3
<_UIViewDeferredBasicAnimation: 0x60000174c280> key=effect duration=0.300000 initialValue=<UIBlurEffect: 0x600000010750> style=UIBlurEffectStyleProminent animationFrames=(
    "<_UIViewAnimationFrame: 0x600000275500> value=<UIBlurEffect: 0x600000014480> style=UIBlurEffectStyleExtraLight startTime=0.000000 duration=0.300000"
)
```



* `-(void)_generateBackgroundEffects:(id)arg1 contentEffects:(id)arg2`
  * `[UIVisualEffectView _generateBackgroundEffects:contentEffects:]`


```
// Callstack:
Thread 1 Queue : com.apple.main-thread (serial)
#0	0x0000000105e9cef8 in -[UIVisualEffectView _generateBackgroundEffects:contentEffects:] ()
#1	0x0000000105e9d568 in -[UIVisualEffectView _generateDeferredAnimations:] ()
#2	0x0000000106dd7ce0 in -[UIViewAnimationState _finalizeDeferredAnimations] ()
#3	0x0000000106dd7d8c in -[UIViewAnimationState pop] ()
#4	0x0000000106dd5e78 in +[UIViewAnimationState popAnimationState] ()
#5	0x0000000106e01188 in +[UIView _setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:] ()
#6	0x00000001042fd198 in VisualEffectViewExperiment02ViewController.updateBlurEffect() at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/Routes/VisualEffectViewExperiment02ViewController.swift:380
#7	0x00000001042fc468 in closure #1 in closure #4 in VisualEffectViewExperiment02ViewController.viewDidLoad() at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/Routes/VisualEffectViewExperiment02ViewController.swift:252
#8	0x0000000104358074 in ClosureInjector.invoke() at /Users/dominicgo/Library/Developer/Xcode/DerivedData/VisualEffectBlurViewExample-fnwcamkgjdtfdjglnemnpctwikua/SourcePackages/checkouts/DGSwiftUtilities/Sources/Common/ClosureInjector/ClosureInjector.swift:28
#9	0x00000001043580b0 in @objc ClosureInjector.invoke() ()
#10	0x00000001068fce90 in -[UIApplication sendAction:to:from:forEvent:] ()
#11	0x00000001062229d4 in -[UIControl sendAction:to:forEvent:] ()
#12	0x0000000106222d18 in -[UIControl _sendActionsForEvents:withEvent:] ()
#13	0x000000010621f858 in -[UIButton _sendActionsForEvents:withEvent:] ()
#14	0x0000000106222d54 in -[UIControl _sendActionsForEvents:withEvent:] ()
#15	0x000000010621f858 in -[UIButton _sendActionsForEvents:withEvent:] ()
#16	0x0000000106221a54 in -[UIControl touchesEnded:withEvent:] ()
#17	0x000000010693052c in -[UIWindow _sendTouchesForEvent:] ()
#18	0x0000000106931a10 in -[UIWindow sendEvent:] ()
#19	0x000000010691168c in -[UIApplication sendEvent:] ()
#20	0x0000000106991014 in __dispatchPreprocessedEventFromEventQueue ()
#21	0x0000000106993ec4 in __processEventQueue ()
#22	0x000000010698cf58 in __eventFetcherSourceCallback ()
#23	0x00000001803c669c in __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ ()
#24	0x00000001803c65e4 in __CFRunLoopDoSource0 ()
#25	0x00000001803c5d54 in __CFRunLoopDoSources0 ()
#26	0x00000001803c043c in __CFRunLoopRun ()
#27	0x00000001803bfd28 in CFRunLoopRunSpecific ()
#28	0x000000018986ebc0 in GSEventRunModal ()
#29	0x00000001068f7fdc in -[UIApplication _run] ()
#30	0x00000001068fbc54 in UIApplicationMain ()
#31	0x0000000105dbdab8 in UIApplicationMain(_:_:_:_:) ()
#32	0x00000001042f4334 in static UIApplicationDelegate.main() ()
#33	0x00000001042f42ac in static AppDelegate.$main() ()
#34	0x00000001042f43b0 in main at /Users/dominicgo/Documents/Programming/VisualEffectBlurView/example/VisualEffectBlurViewExample/AppDelegate.swift:11
#35	0x0000000104749558 in start_sim ()
#36	0x00000001049f20e0 in start ()

(lldb) register read
General Purpose Registers:
        x0 = 0x000000010a91e840
        x1 = 0x00000001072bc84b  "_generateBackgroundEffects:contentEffects:"
        x2 = 0x000060000170ee40
        x3 = 0x0000000000000000
        x4 = 0x0000000000000002
        x5 = 0x0000000000000000
        x6 = 0x00006000000180a0
        x7 = 0x0000600000c64540
        x8 = 0x78886f5ac33b00ad
        x9 = 0x0000000001ad4a88
       x10 = 0x000000011387fab8
       x11 = 0x000000000000004b
       x12 = 0x000000011387fab0
       x13 = 0x0000000000000000
       x14 = 0x0000000000000000
       x15 = 0xffffffffffffffff
       x16 = 0x0000000104448472  (void *)0xdd90000000010444
       x17 = 0x0000000105e9cef8  UIKitCore`-[UIVisualEffectView _generateBackgroundEffects:contentEffects:]
       x18 = 0x0000000000000000
       x19 = 0x000000010a91e840
       x20 = 0x000060000170ee40
       x21 = 0x0000000000000000
       x22 = 0x0000000000000000
       x23 = 0x0000600000018000
       x24 = 0x0000000000000000
       x25 = 0x0000000000000000
       x26 = 0x0000000000000000
       x27 = 0x0000000000000000
       x28 = 0x0000000000000000
        fp = 0x000000016bb12ea0
        lr = 0x0000000105e9d568  UIKitCore`-[UIVisualEffectView _generateDeferredAnimations:] + 368
        sp = 0x000000016bb12e50
        pc = 0x0000000105e9cef8  UIKitCore`-[UIVisualEffectView _generateBackgroundEffects:contentEffects:]
      cpsr = 0x40001000

(lldb) po $arg1
<VisualEffectBlurView.VisualEffectView: 0x10a91e840; baseClass = UIVisualEffectView; frame = (0 0; 414 896); layer = <CALayer: 0x6000002758e0>> effect=<UIBlurEffect: 0x6000000180b0> style=UIBlurEffectStyleProminent

(lldb) po $arg2
4415277131

(lldb) po (char *)$arg2
"_generateBackgroundEffects:contentEffects:"

(lldb) po (char *)$arg3
<_UIViewDeferredBasicAnimation: 0x60000170ee40> key=backgroundEffects duration=0.300000 initialValue=(
    "<UIBlurEffect: 0x60000000ceb0> style=UIBlurEffectStyleRegular"
) animationFrames=(
    "<_UIViewAnimationFrame: 0x6000002283c0> value=(\n    \"<UIBlurEffect: 0x6000000180b0> style=UIBlurEffectStyleProminent\"\n) startTime=0.000000 duration=0.300000"
)

(lldb) po (char *)$arg4
<nil>

// Action: Stepthrough

(lldb) po (char *)$arg3
<_UIViewDeferredBasicAnimation: 0x6000017955c0> key=backgroundEffects duration=0.300000 initialValue=(
    "<UIBlurEffect: 0x6000000180b0> style=UIBlurEffectStyleProminent"
) animationFrames=(
    "<_UIViewAnimationFrame: 0x6000002a08e0> value=(\n    \"<UIBlurEffect: 0x6000000241f0> style=UIBlurEffectStyleExtraLight\"\n) startTime=0.000000 duration=0.300000"
)

(lldb) po (char *)$arg4
<nil>
```



* `-(void)_setBackdropViewBackgroundColorAlpha:(double)arg1`
  * `[UIVisualEffectView _setBackdropViewBackgroundColorAlpha:]`
  * **Status**: Implemented
  * **Observations**:
    * There is a transparent white overlay in the effect (e.g. `_UIVisualEffectSubview`)
    * Tried invoking this to get rid of the whitecast (i.e. as a replacement for `shouldOnlyShowBgLayer`), but doesn't do anything when invoked in `VisualEffectViewExperiment01ViewController`.



* `-(void)_resetEffect`
* `-(id)_debug;`
* `-(id)_whatsWrongWithThisEffect;`
* `-(double)_backdropViewBackgroundColorAlpha;`
* `-(void)_setTintOpacity:(double)arg1`
* `-(id)_contentHost`



```




-(id)_backgroundHost;
-(NSArray *)backgroundEffects;
-(NSArray *)contentEffects;
```