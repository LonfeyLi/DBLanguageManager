//
//  DBLanguageManager.h
//  DBLanguageManager
//
//  Created by 李龙飞 on 2021/11/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
static NSString *const kLanguageKey = @"kLanguageKey";
typedef NS_ENUM (NSInteger , LanguageType) {
    LanguageType_English = 0,
    LanguageType_ChinessSimple = 1,
};

@interface DBLanguageManager : NSObject

+ (instancetype)shareManager;
/**
 配置支持的语言数组
 * array：语言数组 名字和strings文件名对应
 */
- (void)configureLanguageArray:(NSArray<NSString *> *)languageArray;
/**
 配置支持的语言对应的code数组
 * codesArray：语言code数组
 */
- (void)configureCodesArray:(NSArray<NSString *> *)codesArray;
/**
 切换语言
 * type：语言类型
 */
- (void)changeLanguageWithType:(LanguageType)type;
/**
 获取指定词语对应的语言
 * key：词语对应的key
 * type：语言类型
 */
- (NSString*)fetchLanguageWithKey:(NSString*)key languageType:(LanguageType)type;
/**
 获取当前语言
 */
- (LanguageType)fetchCurrentLanguageType;
/**
 添加需要改变语言的view
 * view:改变语言的view
 */
- (void)addView:(UIView *)view;
/**
 移除需要改变语言的view
 * view：view对应的哈希值
 */
- (void)removeView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
