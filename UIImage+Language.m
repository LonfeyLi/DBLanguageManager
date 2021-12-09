//
//  UIImage+Language.m
//  DBLanguageManager
//
//  Created by 李龙飞 on 2021/12/9.
//

#import "UIImage+Language.h"
#import "NSObject+Language.h"
#import "DBLanguageManager.h"
#import <objc/runtime.h>
@implementation UIImage (Language)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //imageNamed:
        Class class = object_getClass(self);
        SEL originalSelector = @selector(imageNamed:);
        SEL swizzledSelector = @selector(lf_imageNamed:);
        Method originMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL willAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (willAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
        //imageWithContentsOfFile:
        SEL originalSelector1 = @selector(imageWithContentsOfFile:);
        SEL swizzledSelector1 = @selector(lf_imageWithContentsOfFile:);
        Method originMethod1 = class_getClassMethod(class, originalSelector1);
        Method swizzledMethod1 = class_getClassMethod(class, swizzledSelector1);
        BOOL willAddMethod1 = class_addMethod(class, originalSelector1, method_getImplementation(swizzledMethod1), method_getTypeEncoding(swizzledMethod1));
        if (willAddMethod1) {
            class_replaceMethod(class, swizzledSelector1, method_getImplementation(originMethod1), method_getTypeEncoding(originMethod1));
        } else {
            method_exchangeImplementations(originMethod1, swizzledMethod1);
        }
    });
}
+ (UIImage *)lf_imageNamed:(NSString *)name {
    if (!self.languageKey) {
        self.languageKey = name;
    }
    UIImage *image = [UIImage lf_imageNamed:name];
    NSString *language = [self fetchLanguage];
    if (language) {
        image = [UIImage lf_imageNamed:language];
    }
    [image setAccessibilityIdentifier:name];
    return  image;
}
+ (UIImage *)lf_imageWithContentsOfFile:(NSString *)path {
        if (!self.languageKey) {
            self.languageKey = path;
        }
    UIImage *image = [UIImage lf_imageWithContentsOfFile:path];
    [image setAccessibilityIdentifier:path];
    NSString *language = [self fetchLanguage];
    if (language) {
        image = [UIImage lf_imageWithContentsOfFile:language];
    }
    return  image;
}
+ (NSString *)fetchLanguage {
    NSString *languageType = [[DBLanguageManager shareManager] fetchCurrentLanguageType];
    NSString *language = [[DBLanguageManager shareManager] fetchLanguageWithKey:self.languageKey languageType:languageType];
    return  language;
}

- (void)changeLanguage {

}
@end
