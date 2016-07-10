//
//  AutoScrollIamgeView.h
//  AutoScrollImageSample
//
//  Created by Dai Pei on 16/3/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoScrollIamgeView : UIView

@property (nonatomic, assign)CGFloat intervals;


- (instancetype)initWithFrame:(CGRect)frame andImageData:(NSArray *)imageArray;
- (void)setIntervals:(CGFloat)intervals;
- (void)startScroll;

@end
