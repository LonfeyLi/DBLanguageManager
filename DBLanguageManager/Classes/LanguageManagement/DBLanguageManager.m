//
//  DBLanguageManager.m
//  DBLanguageManager
//
//  Created by 李龙飞 on 2021/11/12.
//

#import "DBLanguageManager.h"
#import "UILabel+Language.h"
#import "NSObject+Language.h"

static DBLanguageManager *_manager = nil;

@interface DBLanguageManager ()
@property(nonatomic,strong) NSMutableDictionary *viewsDic;
@property(nonatomic,strong) NSRecursiveLock *recusiveLock;
@property(nonatomic,strong) NSString *defaultLanguage;
@property(nonatomic,strong) NSDictionary *languageDictionary;
@end

@implementation DBLanguageManager

+ (instancetype)shareManager  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [DBLanguageManager new];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewsDic = [NSMutableDictionary dictionary];
        self.recusiveLock = [[NSRecursiveLock alloc] init];
        self.languageDictionary = [NSDictionary dictionary];
        self.defaultLanguage = @"English";
        self.markString = @"#";
    }
    return self;
}
- (void)configureMarkString:(NSString *)markString {
    self.markString = markString;
}
- (void)configureDefaultLanguage:(NSString *)language {
    self.defaultLanguage = language;
}
- (void)configureLanguagesDictionary:(NSDictionary *)languageDictionary {
    self.languageDictionary = languageDictionary;
}

- (void)changeLanguageWithType:(NSString *)type {
    [self saveLanguageWithType:type];
    [self.viewsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        [self.recusiveLock lock];
        [view changeLanguage];
        [self.recusiveLock unlock];
    }];
}

- (void)saveLanguageWithType:(NSString *)type {
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:kLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)fetchLanguageWithKey:(NSString*)key languageType:(NSString *)type {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:type ofType:@"strings"];
    NSDictionary *languageDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *language = [languageDic valueForKey:key];
    return language;
}

- (NSString *)fetchCurrentLanguageType {
    __block NSString *languageType =  [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageKey];
    if (!languageType) {
        NSArray *languageArray = [NSLocale preferredLanguages];
        NSString *countryCode = @"";
        if (@available(iOS 10.0, *)) {
            countryCode = [NSString stringWithFormat:@"-%@", [NSLocale currentLocale].countryCode];
        } else {
            countryCode = [NSString stringWithFormat:@"-%@",[ [NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
        }
        if (languageArray.count) {
            NSString *currentLanguage = [languageArray firstObject];
            currentLanguage = [currentLanguage stringByReplacingOccurrencesOfString:countryCode withString:@""];
            [self.languageDictionary.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([currentLanguage hasPrefix:obj]) {
                    languageType = [self.languageDictionary valueForKey:obj];
                    *stop = YES;
                }
            }];
        }
        if (!languageType) {
            languageType = self.defaultLanguage;
        }
        [self saveLanguageWithType:languageType];
    }
    return languageType;
}

- (void)addView:(UIView *)view {
    NSString *hashKey = [NSString stringWithFormat:@"%ld",view.hash];
    if (![self.viewsDic.allKeys containsObject:hashKey]) {
        [self.viewsDic setValue:view forKey:hashKey];
    }
}

- (void)removeView:(UIView *)view {
    NSString *hashKey = [NSString stringWithFormat:@"%ld",view.hash];
    if ([self.viewsDic.allKeys containsObject:hashKey]) {
        [self.viewsDic removeObjectForKey:hashKey];
    }
}

@end
