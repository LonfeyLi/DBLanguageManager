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
        
        SEL originalSelectorDidAppear = @selector(setTitle:forState:);
        SEL swizzledSelectorDidAppear = @selector(lf_setTitle:forState:);
        
        Method originalMethodAppear = class_getInstanceMethod(class, originalSelectorDidAppear);
        Method swizzledMethodAppear = class_getInstanceMethod(class, swizzledSelectorDidAppear);
        
        BOOL willAddMethod =
        class_addMethod(class,
                        originalSelectorDidAppear,
                        method_getImplementation(swizzledMethodAppear),
                        method_getTypeEncoding(swizzledMethodAppear));
        
        if (willAddMethod) {
            class_replaceMethod(class,
                                swizzledSelectorDidAppear,
                                method_getImplementation(originalMethodAppear),
                                method_getTypeEncoding(originalMethodAppear));
        } else {
            method_exchangeImplementations(originalMethodAppear, swizzledMethodAppear);
        }
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

- (void)dealloc{
    [self.stateDictionary removeAllObjects];
    [[DBLanguageManager shareManager] removeView:self];
}
@end
