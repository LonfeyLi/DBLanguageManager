//
//  NSObject+Language.m
//  DBLanguageManager
//
//  Created by 李龙飞 on 2021/11/12.
//

#import "NSObject+Language.h"
#import <objc/runtime.h>
@implementation NSObject (Language)

- (NSString *)languageKey {
    NSString *languageKey = objc_getAssociatedObject(self, @selector(languageKey));
    if (!languageKey) {
        self.languageKey = languageKey;
    }
    return languageKey;
}
- (void)setLanguageKey:(NSString *)languageKey {
    objc_setAssociatedObject(self, @selector(languageKey), languageKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)changeLanguage {
}
@end
