//
//  UIImageView+Language.m
//  DBLanguageManager
//
//  Created by 李龙飞 on 2021/12/9.
//

#import "UIImageView+Language.h"
#import "NSObject+Language.h"
#import "DBLanguageManager.h"
#import <objc/runtime.h>
@implementation UIImageView (Language)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(setImage:);
        SEL swizzledSelector = @selector(lf_setImage:);
        
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
    });
}
- (void)lf_setImage:(UIImage *)image {
    if (!self.languageKey) {
        self.languageKey = image.accessibilityIdentifier;
    }
    NSString *language = [self fetchLanguage];
    if (language) {
        [[DBLanguageManager shareManager] addObject:self];
        [self lf_setImage:[UIImage imageNamed:language]];
    } else {
        [self lf_setImage:image];
    }
    [self lf_setImage:image];
}
- (NSString *)fetchLanguage {
    NSString *languageType = [[DBLanguageManager shareManager] fetchCurrentLanguageType];
    NSString *language = [[DBLanguageManager shareManager] fetchLanguageWithKey:self.languageKey languageType:languageType];
    return  language;
}
- (void)changeLanguage {
    NSString *language = [self fetchLanguage];
    if (language) {
        [self lf_setImage:[UIImage imageNamed:language]];
    }
}
- (void)dealloc {
    [[DBLanguageManager shareManager] removeObject:self];
}
@end
