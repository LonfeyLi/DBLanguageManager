//
//  DBViewController.m
//  DBLanguageManager
//
//  Created by lonfey6@163.com on 12/03/2021.
//  Copyright (c) 2021 lonfey6@163.com. All rights reserved.
//

#import "DBViewController.h"
#import "DBLanguageManager.h"
#import "NSObject+Language.h"
@interface DBViewController ()

@end

@implementation DBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-80, [UIScreen mainScreen].bounds.size.width, 20)];
//    label.attributesArray = @[@{NSForegroundColorAttributeName:UIColor.blackColor},@{NSForegroundColorAttributeName:UIColor.redColor},@{NSForegroundColorAttributeName:UIColor.blackColor},@{NSForegroundColorAttributeName:UIColor.blueColor}];
//    label.attributedText = [[NSAttributedString alloc] initWithString:@"labelText"];
    label.text = @"labelText";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2, 200, 30);
    [button setTitle:@"buttonText" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)buttonClick:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"Change Language"]) {
        [DBLanguageManager.shareManager changeLanguageWithType:@"Chinese"];
    } else {
        [DBLanguageManager.shareManager changeLanguageWithType:@"English"];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
