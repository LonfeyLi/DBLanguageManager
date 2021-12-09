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
        language = [language stringByReplacingOccurrencesOfString:DBLanguageManager.shareManager.markString withString:@""];
        [[DBLanguageManager shareManager] addObject:self];
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
        [[DBLanguageManager shareManager] addObject:self];
        if (self.attributesArray.count) {
            [self setAttributedTextWithLanguage:language];
        } else {
            language = [language stringByReplacingOccurrencesOfString:DBLanguageManager.shareManager.markString withString:@""];
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:language];
            NSRange range = NSMakeRange(0, attributedText.string.length);
            NSDictionary *dictionary = [attributedText attributesAtIndex:0 effectiveRange:&range];
            [attribute addAttributes:dictionary range:NSMakeRange(0, language.length)];
            [self lf_setAttributedText:attribute];
        }
    } else {
        [self lf_setAttributedText:attributedText];
    }
}
- (NSString *)fetchLanguage {
    NSString *languageType = [[DBLanguageManager shareManager] fetchCurrentLanguageType];
    NSString *language = [[DBLanguageManager shareManager] fetchLanguageWithKey:self.languageKey languageType:languageType];
    return  language;
}

- (void)changeLanguage {
    NSString *language = [self fetchLanguage];
    if (language) {
        if (self.attributedText) {
            [self setAttributedTextWithLanguage:language];
        } else {
            language = [language stringByReplacingOccurrencesOfString:DBLanguageManager.shareManager.markString withString:@""];
            [self lf_setText:language];
        }
    }
}
- (void)setAttributedTextWithLanguage:(NSString *)language {
    if (self.attributesArray.count) {
        NSArray<NSString *> *textArray = [language componentsSeparatedByString:DBLanguageManager.shareManager.markString];
        language = [language stringByReplacingOccurrencesOfString:DBLanguageManager.shareManager.markString withString:@""];
        NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
        [textArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx<self.attributesArray.count) {
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:obj];
                [att addAttributes:self.attributesArray[idx] range:NSMakeRange(0, obj.length)];
                [attributedText appendAttributedString:att];
            } else {
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:obj];
                [att addAttributes:self.attributesArray[0] range:NSMakeRange(0, obj.length)];
                [attributedText appendAttributedString:att];
            }
        }];
        [self lf_setAttributedText:attributedText];
    }
    else {
        NSRange range = NSMakeRange(0, self.attributedText.string.length);
        NSDictionary *dictionary = [self.attributedText attributesAtIndex:0 effectiveRange:&range];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:language];
        [attribute addAttributes:dictionary range:NSMakeRange(0, language.length)];
        [self lf_setAttributedText:attribute];
    }
}

- (void)dealloc {
    [[DBLanguageManager shareManager] removeObject:self];
}
@end

