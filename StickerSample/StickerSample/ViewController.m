//
//  ViewController.m
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "StickerViewController.h"
#import "StickerDataController.h"
#import "JsonBuilder.h"
#import "SecondViewController.h"

@interface ViewController ()<StickerViewControllerDelegate> {
    JsonBuilder *builder;
}
@property (nonatomic, strong)UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ConfigViews];
    builder = [[JsonBuilder alloc] init];
    [builder getJsonContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConfigViews

- (void)ConfigViews {
    [self.view addSubview:self.button];
}

#pragma mark - Getters

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button.frame = CGRectMake(100, 100, 100, 50);
        [_button setTitle:@"Sticker" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


#pragma mark - StickerViewControllerDelegate

- (void)addStickers:(NSMutableArray *)stickers {
    for (UIView *view in stickers) {
        [self.view addSubview:view];
    }
}

#pragma mark - Privite Method

- (void)buttonClicked:(id)sender {
    StickerViewController *stickerViewController = [[StickerViewController alloc] initWithStickerArray:[[StickerDataController sharedInstance] stickerPackages]];
    stickerViewController.delegate = self;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    view.frame = self.view.frame;
    stickerViewController.view.backgroundColor = [UIColor clearColor];
    [stickerViewController.view insertSubview:view atIndex:0];
    stickerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:stickerViewController animated:YES completion:nil];
    
    NSLog(@"reach here");
}

@end
