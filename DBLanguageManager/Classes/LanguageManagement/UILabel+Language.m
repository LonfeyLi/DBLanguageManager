//
//  UILabel+Language.m
//  DBLanguageManager
//
//  Created by 李龙飞 on 2021/11/12.
//

#import "UILabel+Language.h"
#import "NSObject+Language.h"
#import "DBLanguageManager.h"
#import <objc/runtime.h>
@implementation UILabel (Language)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(didMoveToSuperview);
        SEL swizzledSelector = @selector(lf_didMoveToSuperview);
        Method originMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        BOOL willAddMethod = class_addMethod([self class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (willAddMethod) {
            class_replaceMethod([self class], swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}
- (void)lf_didMoveToSuperview {
    if (!self.languageKey&&!self.languageKey.length) {
        if (self.text) {
            self.languageKey = self.text;
        } else {
            self.languageKey = [self.attributedText.string copy];
        }
    }
    [self changeLanguage];
    [[DBLanguageManager shareManager] addView:self];
}
- (void)changeLanguage {
    NSString *languageType = [[DBLanguageManager shareManager] fetchCurrentLanguageType];
    NSString *language = [[DBLanguageManager shareManager] fetchLanguageWithKey:self.languageKey languageType:languageType];
    if (language) {
        [self setTextWithLanguage:language];
    }
}
- (void)setTextWithLanguage:(NSString *)language {
    if (self.attributedText) {
        NSInteger length = language.length;
        NSRange range = NSMakeRange(0, self.attributedText.string.length);
        NSDictionary *dictionary = [self.attributedText attributesAtIndex:0 effectiveRange:&range];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:language];
        range = NSMakeRange(0, length);
        [attribute addAttributes:dictionary range:range];
        self.attributedText = attribute;
    } else {
        self.text = language;
    }
}
-(void)dealloc{
    [[DBLanguageManager shareManager] removeView:self];
}
@end
