//
//  ViewController.m
//  NativeXDemo
//
//  Created by Dai Pei on 16/5/12.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "NativeXSDK.h"
#import <AdSupport/ASIdentifierManager.h>

static NSString *appID = @"71781";
static NSString *DeviceID = @"100";

@interface ViewController () <NativeXAdEventDelegate, NativeXRewardDelegate>
@property (nonatomic, strong)UIButton *button1;
@property (nonatomic, strong)UIButton *button2;
@property (nonatomic, strong)UIButton *button3;
@property (nonatomic, strong)UIButton *button4;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
    NSLog(@">>>>>>>>>>the device id is: %@", [[manager advertisingIdentifier] UUIDString]);
//    SKRequest *aaaa = [[SKRequest alloc] init];
    Class m = NSClassFromString(@"SKRequest");
    id object = [[m alloc]init];
    NSLog(@"hello %@ ", [object class]);
    [NativeXSDK enableDebugLog:YES];
//    [NativeXSDK initializeWithAppId:appID andRewardDelegate:self];
    [NativeXSDK initializeWithAppId:appID andPublisherUserId:DeviceID andRewardDelegate:self];
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

#pragma mark - NativeXAdEventDelegate

- (void)adFetched:(NSString*)placementName {
    NSLog(@">>>>>>>>>>>%@", placementName);
    if ([placementName isEqualToString:@"Store Open"]) {
        self.button2.hidden = NO;
    }else if ([placementName isEqualToString:@"App Install Ads"]) {
        self.button4.hidden = NO;
    }
    
}

#pragma mark - NativeXRewardDelegate

- (void) rewardAvailable:(NativeXRewardInfo*) rewardInfo {
    for (NativeXReward *reward in rewardInfo.rewards) {
        NSLog(@">>>>>>>>>>>>>>>>the reward is %@", reward.amount);
    }
}

#pragma mark - Action Method

- (void)button1Clicked:(UIButton *)sender {
//    [NativeXSDK fetchAdWithPlacement:kAdPlacementStoreOpen andFetchDelegate:self];
//    [NativeXSDK fetchAdsAutomaticallyWithPlacement:kAdPlacementStoreOpen andFetchDelegate:self];
    [NativeXSDK fetchAdsAutomaticallyWithName:@"Store Open" andFetchDelegate:self];
    
}

- (void)button2Clicked:(UIButton *)sender {
//    [NativeXSDK showAdWithPlacement:kAdPlacementStoreOpen];
    [NativeXSDK showAdWithName:@"Store Open"];
    self.button2.hidden = YES;
}

- (void)button3Clicked:(UIButton *)sender {
    [NativeXSDK fetchAdsAutomaticallyWithName:@"App Install Ads" andFetchDelegate:self];
//    [NativeXSDK fetchAdsAutomaticallyWithName:@"shabi" andFetchDelegate:self];
}

- (void)button4Clicked:(UIButton *)sender {
    [NativeXSDK showAdWithName:@"App Install Ads"];
//    [NativeXSDK showAdWithName:@"shabi"];
    self.button4.hidden = YES;
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
