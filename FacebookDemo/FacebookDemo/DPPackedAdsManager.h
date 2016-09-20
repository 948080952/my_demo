//
//  DPPackedAdsManager.h
//  iFun
//
//  Created by Dai Pei on 16/7/27.
//  Copyright © 2016年 AppFinder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FBNativeAd;
@class DPPackedAd;


#define DPFacebookNativeAdsPlacement1           @"838745689558715_838746259558658"

@protocol DPPackedAdsManagerDelegate;

@interface DPPackedAdsManager : NSObject

- (instancetype)initWithPlacement:(NSString *)placement
                   viewController:(UIViewController *)viewController
                         delegate:(id<DPPackedAdsManagerDelegate>)delegate;
- (void)loadAds;

@end

@protocol DPPackedAdsManagerDelegate <NSObject>

- (void)packedAdDidLoad:(DPPackedAd *)packedAd;

@end
