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
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIImageView *imageView = [UIImageView new];
    imageView.frame = CGRectMake((screenWidth-300)/2, 180, 300, 300);
    imageView.image = [UIImage imageNamed:@"test_image"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 520, screenWidth, 20)];
    label.attributesArray = @[@{NSForegroundColorAttributeName:UIColor.blackColor},@{NSForegroundColorAttributeName:UIColor.redColor},@{NSForegroundColorAttributeName:UIColor.blackColor},@{NSForegroundColorAttributeName:UIColor.blueColor}];
    label.attributedText = [[NSAttributedString alloc] initWithString:@"labelText"];
//    label.text = @"labelText";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(screenWidth/2-100, 580, 200, 30);
    [button setTitle:@"buttonText" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.frame = CGRectMake(screenWidth-100, 94, 100, 30);
    [nextButton setTitle:@"下一页" forState:UIControlStateNormal];
    [nextButton setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}
- (void)buttonClick:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"Change Language"]) {
        [DBLanguageManager.shareManager changeLanguageWithType:@"Chinese"];
    } else {
        [DBLanguageManager.shareManager changeLanguageWithType:@"English"];
    }
}
- (void)nextButtonClick:(UIButton *)sender {
    [self.navigationController pushViewController:[DBViewController new] animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
