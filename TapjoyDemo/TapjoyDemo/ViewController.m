//
//  ViewController.m
//  TapjoyDemo
//
//  Created by Dai Pei on 16/5/14.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import <AdSupport/AdSupport.h>
#import <Tapjoy/Tapjoy.h>

@interface ViewController () <TJPlacementDelegate>
@property (nonatomic, strong)UIButton *button1;
@property (nonatomic, strong)UIButton *button2;
@property (nonatomic, strong)UIButton *button3;
@property (nonatomic, strong)UIButton *button4;
@property (nonatomic, strong)TJPlacement *place1;
@property (nonatomic, strong)TJPlacement *place2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ASIdentifierManager *manager = [[ASIdentifierManager alloc] init];
    NSLog(@">>>>>>>>>>>>adid:%@", manager.advertisingIdentifier);
    
    [self ConfigViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConfigViews

- (void)ConfigViews {
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    [self.view addSubview:self.button4];
}

#pragma mark - TJPlacementDelegate

- (void)requestDidSucceed:(TJPlacement*)placement {
    NSLog(@">>>>>>>>>>>>%@ request success", placement.placementName);
//    if ([placement.placementName isEqualToString:@"OfferWall"]) {
//        self.button2.hidden = NO;
//    }else if ([placement.placementName isEqualToString:@"OfferWall2"]) {
//        self.button4.hidden = NO;
//    }
}

- (void)requestDidFail:(TJPlacement *)placement error:(NSError *)error {
    NSLog(@">>>>>>>>>>>>%@ request failed with error: %@", placement.placementName, error);
}

- (void)contentIsReady:(TJPlacement*)placement {
    NSLog(@">>>>>>>>>>>>>%@ is ready", placement.placementName);
    if ([placement.placementName isEqualToString:@"OfferWall"]) {
        self.button2.hidden = NO;
    }else if ([placement.placementName isEqualToString:@"OfferWall2"]) {
        self.button4.hidden = NO;
    }
}

- (void)contentDidAppear:(TJPlacement*)placement {
    if ([placement.placementName isEqualToString:@"OfferWall"]) {
        [self.place1 requestContent];
    }else if ([placement.placementName isEqualToString:@"OfferWall2"]) {
        [self.place2 requestContent];
    }
}

- (void)contentDidDisappear:(TJPlacement*)placement {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEarnedCurrencyAlert:) name:TJC_CURRENCY_EARNED_NOTIFICATION object:nil];
}

#pragma mark - Action Method

- (void)button1Clicked:(UIButton *)sender {
    self.place1 = [TJPlacement placementWithName:@"OfferWall" delegate:self];
    [self.place1 requestContent];
}

- (void)button2Clicked:(UIButton *)sender {
    if (self.place1.isContentReady) {
        [self.place1 showContentWithViewController:self];
    }
    self.button2.hidden = YES;
}

- (void)button3Clicked:(UIButton *)sender {
    self.place2 = [TJPlacement placementWithName:@"OfferWall2" delegate:self];
    [self.place2 requestContent];
}

- (void)button4Clicked:(UIButton *)sender {
    if (self.place2.isContentReady) {
        [self.place2 showContentWithViewController:self];
    }
    self.button4.hidden = YES;
}

- (void)showEarnedCurrencyAlert:(NSNotification*)notifyObj {
    NSNumber *currencyEarned = notifyObj.object;
    int earnedNum = [currencyEarned intValue];
    
    NSLog(@"Currency earned: %d", earnedNum);
    
    [Tapjoy showDefaultEarnedCurrencyAlert];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_CURRENCY_EARNED_NOTIFICATION object:nil];
}

#pragma mark - Getters

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button1 setTitle:@"load ad1" forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [_button1 setFrame:CGRectMake(100, 100, 100, 50)];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button2 setTitle:@"show ad1" forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [_button2 setFrame:CGRectMake(100, 200, 100, 50)];
        _button2.hidden = YES;
    }
    return _button2;
}

- (UIButton *)button3 {
    if (!_button3) {
        _button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button3 setTitle:@"load ad2" forState:UIControlStateNormal];
        [_button3 setFrame:CGRectMake(100, 300, 100, 50)];
        [_button3 addTarget:self action:@selector(button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

- (UIButton *)button4 {
    if (!_button4) {
        _button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button4 setTitle:@"show ad2" forState:UIControlStateNormal];
        [_button4 setFrame:CGRectMake(100, 400, 100, 50)];
        [_button4 addTarget:self action:@selector(button4Clicked:) forControlEvents:UIControlEventTouchUpInside];
        _button4.hidden = YES;
    }
    return _button4;
}

@end
