//
//  UIButton+Language.m
//  DBLanguageManager
//
//  Created by 李龙飞 on 2021/12/1.
//

#import "UIButton+Language.h"
#import "DBLanguageManager.h"
#import <objc/runtime.h>

@interface UIButton (Language)
@property(nonatomic,strong)NSMutableDictionary *stateDictionary;
@end

@implementation UIButton (Language)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(setTitle:forState:);
        SEL swizzledSelector = @selector(lf_setTitle:forState:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL willAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (willAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
//        SEL originalSelector1 = @selector(setTitle:forState:);
//        SEL swizzledSelector1 = @selector(lf_setTitle:forState:);
//
//        Method originalMethod1 = class_getInstanceMethod(class, originalSelector1);
//        Method swizzledMethod1 = class_getInstanceMethod(class, swizzledSelector1);
//
//        BOOL willAddMethod1 =
//        class_addMethod(class,
//                        originalSelector1,
//                        method_getImplementation(swizzledMethod1),
//                        method_getTypeEncoding(swizzledMethod1));
//
//        if (willAddMethod1) {
//            class_replaceMethod(class,
//                                swizzledSelector1,
//                                method_getImplementation(originalMethod1),
//                                method_getTypeEncoding(originalMethod1));
//        } else {
//            method_exchangeImplementations(originalMethod1, swizzledMethod1);
//        }
    });
}
-(NSMutableDictionary*)stateDictionary{
    NSMutableDictionary *stateDictionary = objc_getAssociatedObject(self, @selector(stateDictionary));
    if (!stateDictionary) {
        stateDictionary = [[NSMutableDictionary alloc] init];
        [self setStateDictionary:stateDictionary];
    }
    return stateDictionary;
}

-(void)setStateDictionary:(NSMutableDictionary *)stateDictionary{
    objc_setAssociatedObject(self, @selector(stateDictionary), stateDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)lf_setTitle:(NSString *)title forState:(UIControlState)state {
    [self.stateDictionary setObject:title forKey:@(state)];
    NSString *languageType = [[DBLanguageManager shareManager] fetchCurrentLanguageType];
    NSString *language = [[DBLanguageManager shareManager] fetchLanguageWithKey:title languageType:languageType];
    if (language) {
        self.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [[DBLanguageManager shareManager] addView:self];
        [self lf_setTitle:language forState:state];
    } else {
        [self lf_setTitle:title forState:state];
    }
}

-(void)changeLanguage {
    NSString *languageType = [[DBLanguageManager shareManager] fetchCurrentLanguageType];
    [self.stateDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSNumber *state_number = (NSNumber*)key;
        NSString *title = (NSString*)obj;
        NSString *language = [[DBLanguageManager shareManager] fetchLanguageWithKey:title languageType:languageType];
        language = language?language:title;
        [self lf_setTitle:language forState:[state_number integerValue]];
    }];
}

- (void)dealloc {
    [self.stateDictionary removeAllObjects];
    [[DBLanguageManager shareManager] removeView:self];
}
@end
