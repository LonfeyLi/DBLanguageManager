//
//  NSObject+Language.h
//  DBLanguageManager
//
//  Created by 李龙飞 on 2021/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Language)
@property(nonatomic,strong,setter=setLanguageKey:) NSString *languageKey;
@property(nonatomic,strong,setter=setAttributesArray:) NSArray *attributesArray;
@property(nonatomic,assign,setter=setImageIsFilePath:) BOOL imageIsFilePath;
- (void)changeLanguage;
@end

NS_ASSUME_NONNULL_END
