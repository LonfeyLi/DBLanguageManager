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
@property(nonatomic,strong) NSArray *languageArray;
@property(nonatomic,strong) NSArray *codesArray;
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
        self.languageArray = [NSArray array];
        self.codesArray = [NSArray array];
    }
    return self;
}

- (void)configureLanguageArray:(NSArray<NSString *> *)languageArray {
    self.languageArray = languageArray;
}

- (void)configureCodesArray:(NSArray<NSString *> *)codesArray {
    self.codesArray = codesArray;
}

- (void)changeLanguageWithType:(LanguageType)type {
    [self saveLanguageWithType:type];
    [self.viewsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        [self.recusiveLock lock];
        [view changeLanguage];
        [self.recusiveLock unlock];
    }];
}

- (void)saveLanguageWithType:(LanguageType)type {
    [[NSUserDefaults standardUserDefaults] setValue:@(type) forKey:kLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)fetchLanguageWithKey:(NSString*)key languageType:(LanguageType)type {
    NSString *language = nil;
    if (self.languageArray.count) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.languageArray[type] ofType:@"strings"];
        NSDictionary *languageDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        language = [languageDic valueForKey:key];
    }
    return language;
}

- (LanguageType)fetchCurrentLanguageType {
    NSNumber *languageType_Number =  [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageKey];
    if (!languageType_Number) {
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
            __block NSUInteger index = 0;
            [self.codesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([currentLanguage hasPrefix:obj]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            [self saveLanguageWithType:index];
            languageType_Number = [NSNumber numberWithInteger:index];
        }
    }
    return [languageType_Number integerValue];
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
