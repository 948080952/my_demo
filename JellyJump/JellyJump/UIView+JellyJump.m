//
//  UIView+JellyJump.m
//  JellyJump
//
//  Created by DaiPei on 2017/3/5.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

#import "UIView+JellyJump.h"

@implementation UIView (JellyJump)

- (void)startJump {
    
    CGFloat sx = 1;
    CGFloat sy = 1;
    CGFloat sz = 1;
    
    CGFloat tx = 0;
    CGFloat ty = 0;
    CGFloat tz = 0;
    
    
    CAKeyframeAnimation *jellyJump = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    NSValue *value0 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(sx, sy, sz)];
    
    sx = 1.1;
    sy = 0.9;
    ty = (1 - sy) * CGRectGetHeight(self.layer.bounds) / 2;
    CATransform3D scale1 = CATransform3DMakeScale(sx, sy, sz);
    CATransform3D move1 = CATransform3DMakeTranslation(tx, ty, tz);
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale1, move1)];
    
    sx = 0.95;
    sy = 1;
    ty = -CGRectGetHeight(self.layer.bounds) * 0.25;
    CATransform3D scale2 = CATransform3DMakeScale(sx, sy, sz);
    CATransform3D move2 = CATransform3DMakeTranslation(tx, ty, tz);
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale2, move2)];
    
    CATransform3D scale3 = CATransform3DMakeScale(sx, sy, sz);
    CATransform3D move3 = CATransform3DMakeTranslation(tx, ty, tz);
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale3, move3)];
    
    sx = 1;
    sy = 1;
    ty = 0;
    CATransform3D scale4 = CATransform3DMakeScale(sx, sy, sz);
    CATransform3D move4 = CATransform3DMakeTranslation(tx, ty, tz);
    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale4, move4)];
    
    sx = 1.1;
    sy = 0.9;
    ty = (1 - sy) * CGRectGetHeight(self.layer.bounds) / 2;
    CATransform3D scale5 = CATransform3DMakeScale(sx, sy, sz);
    CATransform3D move5 = CATransform3DMakeTranslation(tx, ty, tz);
    NSValue *value5 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale5, move5)];
    
    sx = 1;
    sy = 1;
    ty = 0;
    CATransform3D scale6 = CATransform3DMakeScale(sx, sy, sz);
    CATransform3D move6 = CATransform3DMakeTranslation(tx, ty, tz);
    NSValue *value6 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale6, move6)];
    
    CATransform3D scale7 = CATransform3DMakeScale(sx, sy, sz);
    CATransform3D move7 = CATransform3DMakeTranslation(tx, ty, tz);
    NSValue *value7 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale7, move7)];
    
    
    
    jellyJump.values = @[value0, value1, value2, value3, value4, value5, value6, value7];
    jellyJump.keyTimes = @[@(0), @(0.1), @(0.25), @(0.35), @(0.4), @(0.5), @(0.58), @(1)];
    
    jellyJump.duration = 1.5;
    jellyJump.fillMode = kCAFillModeBackwards;
    jellyJump.removedOnCompletion = NO;
    jellyJump.repeatCount = INFINITY;
    
    jellyJump.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0 :0];
    
    [self.layer addAnimation:jellyJump forKey:@"jellyJump"];
}

@end
