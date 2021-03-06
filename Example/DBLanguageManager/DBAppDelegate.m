//
//  DBAppDelegate.m
//  DBLanguageManager
//
//  Created by lonfey6@163.com on 12/03/2021.
//  Copyright (c) 2021 lonfey6@163.com. All rights reserved.
//

#import "DBAppDelegate.h"
#import "DBLanguageManager.h"
#import "DBViewController.h"
@implementation DBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[DBLanguageManager shareManager] configureLanguagesDictionary:@{@"en":@"English",@"zh_Hans":@"Chinese"}];
    [[DBLanguageManager shareManager] configureDefaultLanguage:@"Chinese"];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.blackColor} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.redColor} forState:UIControlStateSelected];
    UITabBarController *tab = [[UITabBarController alloc] init];
    DBViewController *vc1 = [DBViewController new];
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nc1.tabBarItem.title = @"tabbar_title_1";
    DBViewController *vc2 = [DBViewController new];
    vc2.tabBarItem.title = @"tabbar_title_2";
    DBViewController *vc3 = [DBViewController new];
    vc3.tabBarItem.title = @"tabbar_title_3";
    tab.viewControllers = @[nc1,vc2,vc3];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
