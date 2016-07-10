//
//  ViewController.m
//  YuXinSDK
//
//  Created by Dai Pei on 16/6/24.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "YuXinSDK.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;
@property (nonatomic, strong) UIButton *button7;
@property (nonatomic, strong) UIButton *button8;
@property (nonatomic, strong) UIButton *button9;
@property (nonatomic, strong) UIButton *button10;
@property (nonatomic, strong) UIButton *button11;
@property (nonatomic, strong) UIButton *button12;
@property (nonatomic, strong) UIButton *button13;
@property (nonatomic, strong) UIButton *button14;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger boardType;
@property (nonatomic, strong) NSMutableArray *fileNames;
@property (nonatomic, assign) NSInteger i;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.num = 0;
    self.boardType = 0;
    self.i = 0;
    
    self.fileNames = [NSMutableArray array];
    
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    [self.view addSubview:self.button4];
    [self.view addSubview:self.button5];
    [self.view addSubview:self.button6];
    [self.view addSubview:self.button7];
    [self.view addSubview:self.button8];
    [self.view addSubview:self.button9];
    [self.view addSubview:self.button10];
    [self.view addSubview:self.button11];
    [self.view addSubview:self.button12];
    [self.view addSubview:self.button13];
    [self.view addSubview:self.button14];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Method

- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [[YuXinSDK sharedInstance] loginWithUsername:@"DaiPei" password:@"D20101144" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        case 1:
            [[YuXinSDK sharedInstance] fetchFavourateBoardWithCompletion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        case 2:
            [[YuXinSDK sharedInstance] queryUserInfoWithUserID:@"DaiPei" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        case 3:
            [[YuXinSDK sharedInstance] logoutWithCompletion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        case 4:
            [[YuXinSDK sharedInstance] fetchFriendListWithCompletion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        case 5:{
            __weak typeof(self) weakSelf = self;
            [[YuXinSDK sharedInstance] fetchArticleTitleListWithBoard:@"water" start:@(self.num) completion:^(NSString *error, NSArray *responseModels) {
                for (YuXinTitle *model in responseModels) {
                    [weakSelf.fileNames addObject:model.fileName];
                }
            }];
            self.num = self.num + 20;
            break;
        }
        case 6:{
            [[YuXinSDK sharedInstance] fetchSubboard:self.boardType completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            self.boardType++;
            if (self.boardType == 8) {
                self.boardType = 0;
            }
            break;
        }
        case 7:{
            [[YuXinSDK sharedInstance] addFavourateBoard:@"Water" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        }
        case 8:{
            [[YuXinSDK sharedInstance] delFavourateBoard:@"Water" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        }
        case 9:{
            [[YuXinSDK sharedInstance] fetchArticlesWithBoard:@"Water" file:@"M.1468038488.A" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            self.i++;
            if (self.i == self.fileNames.count) {
                self.i = 0;
            }
            break;
        }
        case 10:{
            [[YuXinSDK sharedInstance] postArticleWithContent:@"不可回复测试" title:@"此帖不可回复" board:@"Water" canReply:NO userID:@"DaiPei" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        }
        case 11:{
            [[YuXinSDK sharedInstance] commentArticle:@"bukehuifu" content:@"评论1" board:@"Water" canReply:YES file:@"M.1468043980.A" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        }
        case 12:{
            [[YuXinSDK sharedInstance] deleteArticleWithBoard:@"Water" file:@"M.1468051512.A" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        }
        case 13:{
            [[YuXinSDK sharedInstance] reprintArticleWithFile:@"M.1463124411.A" from:@"Water" to:@"Water" completion:^(NSString *error, NSArray *responseModels) {
                
            }];
            break;
        }
        case 14:{
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Getter

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button1 setTitle:@"login" forState:UIControlStateNormal];
        _button1.frame = CGRectMake(20, 20, 100, 20);
        _button1.tag = 0;
        [_button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button2 setTitle:@"favourate" forState:UIControlStateNormal];
        _button2.frame = CGRectMake(20, 40, 100, 20);
        _button2.tag = 1;
        [_button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (UIButton *)button3 {
    if (!_button3) {
        _button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button3 setTitle:@"userinfo" forState:UIControlStateNormal];
        _button3.frame = CGRectMake(20, 60, 100, 20);
        _button3.tag = 2;
        [_button3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

- (UIButton *)button4 {
    if (!_button4) {
        _button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button4 setTitle:@"logout" forState:UIControlStateNormal];
        _button4.frame = CGRectMake(20, 80, 100, 20);
        _button4.tag = 3;
        [_button4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button4;
}

- (UIButton *)button5 {
    if (!_button5) {
        _button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button5 setTitle:@"friendlist" forState:UIControlStateNormal];
        _button5.frame = CGRectMake(20, 100, 100, 20);
        _button5.tag = 4;
        [_button5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button5;
}

- (UIButton *)button6 {
    if (!_button6) {
        _button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button6 setTitle:@"articlelist" forState:UIControlStateNormal];
        _button6.frame = CGRectMake(20, 120, 100, 20);
        _button6.tag = 5;
        [_button6 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button6;
}

- (UIButton *)button7 {
    if (!_button7) {
        _button7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button7 setTitle:@"subboard" forState:UIControlStateNormal];
        _button7.frame = CGRectMake(20, 140, 100, 20);
        _button7.tag = 6;
        [_button7 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button7;
}

- (UIButton *)button8 {
    if (!_button8) {
        _button8 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button8 setTitle:@"add" forState:UIControlStateNormal];
        _button8.frame = CGRectMake(20, 160, 100, 20);
        _button8.tag = 7;
        [_button8 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button8;
}

- (UIButton *)button9 {
    if (!_button9) {
        _button9 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button9 setTitle:@"del" forState:UIControlStateNormal];
        _button9.frame = CGRectMake(20, 180, 100, 20);
        _button9.tag = 8;
        [_button9 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button9;
}

- (UIButton *)button10 {
    if (!_button10) {
        _button10 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button10 setTitle:@"artical" forState:UIControlStateNormal];
        _button10.frame = CGRectMake(20, 200, 100, 20);
        _button10.tag = 9;
        [_button10 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button10;
}

- (UIButton *)button11 {
    if (!_button11) {
        _button11 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button11 setTitle:@"post" forState:UIControlStateNormal];
        _button11.frame = CGRectMake(20, 220, 100, 20);
        _button11.tag = 10;
        [_button11 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button11;
}

- (UIButton *)button12 {
    if (!_button12) {
        _button12 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button12 setTitle:@"pinglun" forState:UIControlStateNormal];
        _button12.frame = CGRectMake(20, 240, 100, 20);
        _button12.tag = 11;
        [_button12 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button12;
}

- (UIButton *)button13 {
    if (!_button13) {
        _button13 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button13 setTitle:@"delete" forState:UIControlStateNormal];
        _button13.frame = CGRectMake(20, 260, 100, 20);
        _button13.tag = 12;
        [_button13 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button13;
}

- (UIButton *)button14 {
    if (!_button14) {
        _button14 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button14 setTitle:@"reprint" forState:UIControlStateNormal];
        _button14.frame = CGRectMake(20, 280, 100, 20);
        _button14.tag = 13;
        [_button14 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button14;
}

@end
