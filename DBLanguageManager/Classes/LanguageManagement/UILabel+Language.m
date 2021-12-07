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
        //text
        SEL originalSelector = @selector(setText:);
        SEL swizzledSelector = @selector(lf_setText:);
        Method originMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        BOOL willAddMethod = class_addMethod([self class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (willAddMethod) {
            class_replaceMethod([self class], swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
        //attributedString
        SEL originalSelector1 = @selector(setAttributedText:);
        SEL swizzledSelector1 = @selector(lf_setAttributedText:);
        Method originMethod1 = class_getInstanceMethod([self class], originalSelector1);
        Method swizzledMethod1 = class_getInstanceMethod([self class], swizzledSelector1);
        BOOL willAddMethod1 = class_addMethod([self class], originalSelector1, method_getImplementation(swizzledMethod1), method_getTypeEncoding(swizzledMethod));
        if (willAddMethod1) {
            class_replaceMethod([self class], swizzledSelector1, method_getImplementation(originMethod1), method_getTypeEncoding(originMethod1));
        } else {
            method_exchangeImplementations(originMethod1, swizzledMethod1);
        }
    });
}
- (void)lf_setText:(NSString *)text {
    if (!self.languageKey) {
        self.languageKey = text;
    }
    NSString *language = [self fetchLanguage];
    if (language) {
        [[DBLanguageManager shareManager] addView:self];
        [self lf_setText:language];
    } else {
        [self lf_setText:text];
    }
}
- (void)lf_setAttributedText:(NSAttributedString *)attributedText {
    if (!self.languageKey) {
        self.languageKey = attributedText.string;
    }
    NSString *language = [self fetchLanguage];
    if (language) {
        [[DBLanguageManager shareManager] addView:self];
        NSMutableAttributedString *attribute = [self attributedStringWithLanguage:language];
        [self lf_setAttributedText:attribute];
    } else {
        [self lf_setAttributedText:attributedText];
    }
}
- (NSString *)fetchLanguage {
    NSString *languageType = [[DBLanguageManager shareManager] fetchCurrentLanguageType];
    NSString *language = [[DBLanguageManager shareManager] fetchLanguageWithKey:self.languageKey languageType:languageType];
    return  language;
}
- (NSMutableAttributedString *)attributedStringWithLanguage:(NSString *)language {
    NSInteger length = language.length;
    NSRange range = NSMakeRange(0, self.attributedText.string.length);
    NSDictionary *dictionary = [self.attributedText attributesAtIndex:0 effectiveRange:&range];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:language];
    range = NSMakeRange(0, length);
    [attribute addAttributes:dictionary range:range];
    return  attribute;
}

- (void)changeLanguage {
    NSString *language = [self fetchLanguage];
    if (language) {
        [self setTextWithLanguage:language];
    }
}
- (void)setTextWithLanguage:(NSString *)language {
    if (self.attributedText) {
        NSMutableAttributedString *attribute = [self attributedStringWithLanguage:language];
        [self lf_setAttributedText:attribute];
    } else {
        [self lf_setText:language];
    }
}

-(void)dealloc{
    [[DBLanguageManager shareManager] removeView:self];
}
@end

