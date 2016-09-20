//
//  DPPackedAd.h
//  iFun
//
//  Created by Dai Pei on 16/7/28.
//  Copyright © 2016年 AppFinder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPPackedAd : NSObject

@property (nonatomic, strong) UIView            *clickableView;

@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *subtitle;
@property (nonatomic, strong) NSString          *callToAction;
@property (nonatomic, strong) UIImage           *icon;
@property (nonatomic, strong) UIImage           *coverImage;
@property (nonatomic, strong) NSString          *body;
@property (nonatomic, strong) NSString          *placementID;


@end
