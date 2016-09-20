//
//  DPPackedAdsManager.m
//  iFun
//
//  Created by Dai Pei on 16/7/27.
//  Copyright © 2016年 AppFinder. All rights reserved.
//

#import "DPPackedAdsManager.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import "DPPackedAd.h"

@interface DPPackedAdsManager () <FBNativeAdDelegate>

@property (nonatomic, strong) FBNativeAd *nativeAd;
@property (nonatomic, strong) DPPackedAd *packedAd;
@property (nonatomic, strong) NSString *placement;
@property (nonatomic, strong) UIViewController *parentVC;
@property (nonatomic, weak) id<DPPackedAdsManagerDelegate> delegate;

@end

@implementation DPPackedAdsManager

- (instancetype)initWithPlacement:(NSString *)placement viewController:(UIViewController *)viewController delegate:(id<DPPackedAdsManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.placement = placement;
        self.parentVC = viewController;
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithPlace:(NSString *)placement delegate:(id<DPPackedAdsManagerDelegate>)delegate{
    self = [super init];
    if (self) {
        self.placement = placement;
        self.delegate = delegate;
    }
    return self;
}

- (void)loadAds {
    [self loadAdsAtPlace:self.placement];
}

#pragma mark - Privite Method

- (DPPackedAd *)packFBNativeAd:(FBNativeAd *)nativeAd {
    DPPackedAd *packedAd = [[DPPackedAd alloc] init];
    packedAd.title = nativeAd.title;
    packedAd.subtitle = nativeAd.subtitle;
    packedAd.callToAction = nativeAd.callToAction;
    packedAd.body = nativeAd.body;
    packedAd.placementID = nativeAd.placementID;
    UIView *clickableView = [[UIView alloc] init];
    clickableView.backgroundColor = [UIColor clearColor];
    [nativeAd registerViewForInteraction:clickableView withViewController:self.parentVC];
    packedAd.clickableView = clickableView;
    return packedAd;
}

- (void)makeLogWith:(FBNativeAd *)nativeAd status:(NSString *)status {
    NSLog(@"[DPPackedAdsManager]: nativeAd:%@ status:%@", nativeAd.placementID, status);
}

- (void)loadAdsAtPlace:(NSString *)placement {
    FBNativeAd *nativeAd = [[FBNativeAd alloc] initWithPlacementID:placement];
    nativeAd.delegate = self;
    nativeAd.mediaCachePolicy = FBNativeAdsCachePolicyAll;
    [nativeAd loadAd];
}

#pragma mark - FBNativeAdDelegate

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
    [self makeLogWith:nativeAd status:@"load"];
    if (self.nativeAd) {
        [self.nativeAd unregisterView];
    }
    self.nativeAd = nativeAd;
    
    self.packedAd = [self packFBNativeAd:self.nativeAd];
    
    __weak typeof(self) weakSelf = self;
    [self.nativeAd.icon loadImageAsyncWithBlock:^(UIImage * _Nullable image) {
        if (image) {
            weakSelf.packedAd.icon = image;
            [weakSelf.nativeAd.coverImage loadImageAsyncWithBlock:^(UIImage * _Nullable image) {
                if (image) {
                    weakSelf.packedAd.coverImage = image;
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(packedAdDidLoad:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.delegate packedAdDidLoad:weakSelf.packedAd];
                        });
                    }
                }
            }];
        }
    }];
}

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd {
    [self makeLogWith:nativeAd status:@"will log impression"];
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd {
    [self makeLogWith:nativeAd status:@"did click"];
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error {
    [self makeLogWith:nativeAd status:[NSString stringWithFormat:@"fail with error:%@", error]];
}

@end
