//
//  ViewController.m
//  FacebookDemo
//
//  Created by Dai Pei on 16/7/26.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import "DPPackedAdsManager.h"
#import "DPPackedAd.h"

@interface ViewController () <DPPackedAdsManagerDelegate>

@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) FBMediaView *mediaView;
@property (nonatomic, strong) FBNativeAd *nativeAd;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) DPPackedAdsManager *manager;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    self.manager = [[DPPackedAdsManager alloc] initWithPlacement:DPFacebookNativeAdsPlacement1
                                                          viewController:self
                                                                delegate:self];
    [self.manager loadAds];

}

- (void)initView {
    [self.view addSubview:self.adView];
    [self.adView addSubview:self.mediaView];
    [self.view addSubview:self.button];
}

- (void)packedAdDidLoad:(DPPackedAd *)packedAd {
    NSLog(@"%@ %@ %@ %@", packedAd.title, packedAd.subtitle, packedAd.body, packedAd.callToAction);
    self.imageView.image = packedAd.coverImage;
    [self.adView addSubview:self.imageView];
    packedAd.clickableView.frame = self.adView.bounds;
    [self.adView addSubview:packedAd.clickableView];
    
}


- (void)buttonClicked:(UIButton *)sender {
    
    
}


- (UIView *)adView {
    if (!_adView) {
        _adView = [[UIView alloc] init];
        _adView.frame = CGRectMake(0, 200, self.view.frame.size.width, 300);
        _adView.backgroundColor = [UIColor grayColor];
    }
    return _adView;
}

- (FBMediaView *)mediaView {
    if (!_mediaView) {
        _mediaView = [[FBMediaView alloc] init];
        _mediaView.frame = CGRectMake(0, 10, self.view.frame.size.width, 290);
        _mediaView.autoplayEnabled = NO;
    }
    return _mediaView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button setTitle:@"load ad" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _button.frame = CGRectMake(300, 100, 100, 30);
    }
    return _button;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
