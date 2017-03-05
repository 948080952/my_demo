//
//  DPAutoScrollView.h
//  DPAutoScrollView
//
//  Created by DaiPei on 2017/2/17.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftSpinElementAnimationDelegate.h"

@interface DPAutoScrollView : UIView <GiftSpinElementAnimationDelegate>

- (void)setImage:(UIImage *)image;
- (void)setIntialSpeed:(CGFloat)intialSpeed;
- (void)startScroll;
- (void)stopScroll;

@end
