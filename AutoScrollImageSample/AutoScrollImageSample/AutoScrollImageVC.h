//
//  AutoScrollImageVC.h
//  AutoScrollImageSample
//
//  Created by Dai Pei on 16/3/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"

@interface AutoScrollImageVC : ViewController


@property (nonatomic, assign)CGFloat intervals;

- (instancetype)initWithImageData:(NSArray *)imageArray;
- (void)setIntervals:(CGFloat)intervals;
- (void)startScroll;

@end
