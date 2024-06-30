//
//  NSValue+NSValue_Helpers.m
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 6/23/24.
//

#import "NSValue+NSValue_Helpers.h"
#import <objc/runtime.h>
#import <objc/message.h>

typedef struct CAmatrixRGBA {
    float m11, m12, m13, m14, m15;
    float m21, m22, m23, m24, m25;
    float m31, m32, m33, m34, m35;
    float m41, m42, m43, m44, m45;
} CAmatrixRGBA;

#define SwizzleSelector(clazz, selector, newImplementation, pPreviousImplementation) \
    (*pPreviousImplementation) = (__typeof((*pPreviousImplementation)))class_swizzleSelector((clazz), (selector), (IMP)(newImplementation))

#define SwizzleClassSelector(clazz, selector, newImplementation, pPreviousImplementation) \
    (*pPreviousImplementation) = (__typeof((*pPreviousImplementation)))class_swizzleClassSelector((clazz), (selector), (IMP)(newImplementation))

#define SwizzleSelectorWithBlock_Begin(clazz, selector) { \
    SEL _cmd = selector; \
    __block IMP _imp = class_swizzleSelectorWithBlock((clazz), (selector),
#define SwizzleSelectorWithBlock_End );}

#define SwizzleClassSelectorWithBlock_Begin(clazz, selector) { \
    SEL _cmd = selector; \
    __block IMP _imp = class_swizzleClassSelectorWithBlock((clazz), (selector),
#define SwizzleClassSelectorWithBlock_End );}


IMP class_swizzleSelector(Class clazz, SEL selector, IMP newImplementation)
{
    // If the method does not exist for this class, do nothing
    Method method = class_getInstanceMethod(clazz, selector);
    if (! method) {
        // Cannot swizzle methods which are not implemented by the class or one of its parents
        return NULL;
    }
    
    // Make sure the class implements the method. If this is not the case, inject an implementation, only calling 'super'
    const char *types = method_getTypeEncoding(method);
    
#if !defined(__arm64__)
    NSUInteger returnSize = 0;
    NSGetSizeAndAlignment(types, &returnSize, NULL);
    
    // Large structs on 32-bit architectures
    if (sizeof(void *) == 4 && types[0] == _C_STRUCT_B && returnSize != 1 && returnSize != 2 && returnSize != 4 && returnSize != 8) {
        class_addMethod(clazz, selector, imp_implementationWithBlock(^(__unsafe_unretained id self, va_list argp) {
            struct objc_super super = {
                .receiver = self,
                .super_class = class_getSuperclass(clazz)
            };
            
            // Sufficiently large struct
            typedef struct LargeStruct_ {
                char dummy[16];
            } LargeStruct;
            
            // Cast the call to objc_msgSendSuper_stret appropriately
            LargeStruct (*objc_msgSendSuper_stret_typed)(struct objc_super *, SEL, va_list) = (void *)&objc_msgSendSuper_stret;
            return objc_msgSendSuper_stret_typed(&super, selector, argp);
        }), types);
    }
    // All other cases
    else {
#endif
        class_addMethod(clazz, selector, imp_implementationWithBlock(^(__unsafe_unretained id self, va_list argp) {
            struct objc_super super = {
                .receiver = self,
                .super_class = class_getSuperclass(clazz)
            };
            
            // Cast the call to objc_msgSendSuper appropriately
            id (*objc_msgSendSuper_typed)(struct objc_super *, SEL, va_list) = (void *)&objc_msgSendSuper;
            return objc_msgSendSuper_typed(&super, selector, argp);
        }), types);
#if !defined(__arm64__)
    }
#endif
    
    // Swizzling
    return class_replaceMethod(clazz, selector, newImplementation, types);
}

IMP class_swizzleClassSelector(Class clazz, SEL selector, IMP newImplementation)
{
    return class_swizzleSelector(object_getClass(clazz), selector, newImplementation);
}

IMP class_swizzleSelectorWithBlock(Class clazz, SEL selector, id newImplementationBlock)
{
    IMP newImplementation = imp_implementationWithBlock(newImplementationBlock);
    return class_swizzleSelector(clazz, selector, newImplementation);
}

IMP class_swizzleClassSelectorWithBlock(Class clazz, SEL selector, id newImplementationBlock)
{
    IMP newImplementation = imp_implementationWithBlock(newImplementationBlock);
    return class_swizzleClassSelector(clazz, selector, newImplementation);
}

@interface CAFilter : NSObject

@property(copy) NSString *name;
@property(readonly) NSString *type;

@end

@implementation NSValue (CAFilterVerbose)

+ (void)load
{
  return;
  SwizzleSelectorWithBlock_Begin(self, @selector(description))
  ^(NSValue *self) {
    if (strcmp(self.objCType, @encode(CAmatrixRGBA)) == 0) {
      CAmatrixRGBA matrixRGBA;
      
      [self getValue:&matrixRGBA];
      return [NSString stringWithFormat:@"CAmatrixRGBA: {{%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}, {%lf, %lf, %lf, %lf, %lf}}", matrixRGBA.m11, matrixRGBA.m12, matrixRGBA.m13, matrixRGBA.m14, matrixRGBA.m15, matrixRGBA.m21, matrixRGBA.m22, matrixRGBA.m23, matrixRGBA.m24, matrixRGBA.m25, matrixRGBA.m31, matrixRGBA.m32, matrixRGBA.m33, matrixRGBA.m34, matrixRGBA.m35, matrixRGBA.m41, matrixRGBA.m42, matrixRGBA.m43, matrixRGBA.m44, matrixRGBA.m45];
    }
    return [self description];
  }
  SwizzleSelectorWithBlock_End;
}

@end


@implementation CAFilter (CAFilterVerbose)


+ (void)load
{
  return;
  SwizzleSelectorWithBlock_Begin(self, @selector(setValue:forKey:))
  ^(CAFilter *self, id value, NSString *key) {
    //((void (*)(id, SEL, NSString*))_imp)(self, _cmd, key);
    //[self setValue:value forKey:key];
    (self = ((id (*)(id, SEL, NSString*))_imp)(self, _cmd, key));
    NSLog(@"%@[%@] = %@", self.name, key, value);
  }
  SwizzleSelectorWithBlock_End;
}

@end
