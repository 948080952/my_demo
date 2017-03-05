//
//  ViewController.m
//  JellyJump
//
//  Created by DaiPei on 2017/3/5.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

#import "ViewController.h"
#import "UIView+JellyJump.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *jelly;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    tmp.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:tmp];
//    
//    
//    _jelly = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    _jelly.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:_jelly];
    
//    CGFloat sx = 1;
//    CGFloat sy = 1;
//    CGFloat sz = 1;
//    
//    
//    CAKeyframeAnimation *jellyJump = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    
//    NSValue *value0 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(sx, sy, sz)];
//    
//    sx = 1.1;
//    sy = 0.9;
//    
//    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(sx, sy, sz)];
//    CATransform3D scale1 = CATransform3DMakeScale(0.9, 1.1, 1);
//    CATransform3D move1 = CATransform3DMakeTranslation(0, -50, 0);
//    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale1, move1)];
//    CATransform3D scale2 = CATransform3DMakeScale(1, 1, 1);
//    CATransform3D move2 = CATransform3DMakeTranslation(0, 0, 0);
//    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DConcat(scale2, move2)];
//    
//    
//    jellyJump.values = @[value0, value1, value2, value3];
//    
//    jellyJump.duration = 1;
//    jellyJump.fillMode = kCAFillModeBackwards;
//    jellyJump.removedOnCompletion = NO;
//    jellyJump.repeatCount = INFINITY;
    
//    [_jelly startJump];
    
    UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
    coin.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:coin];
    
    [coin startJump];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
