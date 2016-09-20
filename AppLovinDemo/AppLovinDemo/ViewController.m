//
//  ViewController.m
//  AppLovinDemo
//
//  Created by Dai Pei on 2016/9/5.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "ALInterstitialAd.h"
#import "ALIncentivizedInterstitialAd.h"

@interface ViewController () <ALAdLoadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ALIncentivizedInterstitialAd shared] preloadAndNotify:self];
    NSLog(@"preloading...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ALAdLoadDelegate

- (void)adService:(alnonnull ALAdService *)adService didLoadAd:(alnonnull ALAd *)ad {
    [[ALIncentivizedInterstitialAd shared] show];
}

- (void)adService:(alnonnull ALAdService *)adService didFailToLoadAdWithError:(int)code {
    NSLog(@"code:%d", code);
}

@end
