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
- (NSArray *)attributesArray {
    NSArray *attributes = objc_getAssociatedObject(self, @selector(attributesArray));
    if (!attributes) {
        self.attributesArray = attributes;
    }
    return attributes;
}
- (void)setAttributesArray:(NSArray *)attributesArray {
    objc_setAssociatedObject(self, @selector(attributesArray), attributesArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)imageIsFilePath {
    BOOL isFilePath = objc_getAssociatedObject(self, @selector(imageIsFilePath));
    if (!isFilePath) {
        self.imageIsFilePath = isFilePath;
    }
    return isFilePath;
}
- (void)setImageIsFilePath:(BOOL)imageIsFilePath {
    objc_setAssociatedObject(self, @selector(imageIsFilePath), @(imageIsFilePath), OBJC_ASSOCIATION_ASSIGN);
}
- (void)changeLanguage {
}
@end
