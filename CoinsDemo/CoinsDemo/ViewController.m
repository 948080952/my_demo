//
//  ViewController.m
//  CoinsDemo
//
//  Created by Dai Pei on 16/5/24.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)UIImageView *coinImageView;
@property (nonatomic, strong)UIImageView *shiningAnimationView1;
@property (nonatomic, strong)UIImageView *shiningAnimationView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.shiningAnimationView1];
    [self.view addSubview:self.coinImageView];
    [self.view addSubview:self.shiningAnimationView2];
    
    [self playCoinShiningAnimation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playCoinShiningAnimation {
    self.shiningAnimationView1.hidden = NO;
    self.shiningAnimationView2.hidden = NO;
    if (self.shiningAnimationView1.isAnimating) {
        [self.shiningAnimationView1 stopAnimating];
    }
    if (self.shiningAnimationView2.isAnimating) {
        [self.shiningAnimationView2 stopAnimating];
    }
    [self.shiningAnimationView1 startAnimating];
    [self.shiningAnimationView2 startAnimating];
}

- (UIImageView *)coinImageView {
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc] init];
        _coinImageView.image = [UIImage imageNamed:@"coin"];
        _coinImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coinImageView.userInteractionEnabled = YES;
        _coinImageView.frame = CGRectMake(100, 100, 24, 24);
        
    }
    return _coinImageView;
}

- (UIImageView *)shiningAnimationView1 {
    if (!_shiningAnimationView1) {
        _shiningAnimationView1 = [[UIImageView alloc] init];
        _shiningAnimationView1.backgroundColor = [UIColor clearColor];
        NSArray *animationImages = @[[UIImage imageNamed:@"coin_1"], [UIImage imageNamed:@"coin_2"]];
        _shiningAnimationView1.animationImages = animationImages;
        _shiningAnimationView1.hidden = YES;
        _shiningAnimationView1.animationDuration = 0.25;
        _shiningAnimationView1.frame = CGRectMake(92, 92, 40, 40);
    }
    return _shiningAnimationView1;
}

- (UIImageView *)shiningAnimationView2 {
    if (!_shiningAnimationView2) {
        _shiningAnimationView2 = [[UIImageView alloc] init];
        _shiningAnimationView2.backgroundColor = [UIColor clearColor];
        NSArray *animationImages = @[[UIImage imageNamed:@"coin_3"], [UIImage imageNamed:@"coin_4"]];
        _shiningAnimationView2.animationImages = animationImages;
        _shiningAnimationView2.hidden = YES;
        _shiningAnimationView2.animationDuration = 0.8;
        _shiningAnimationView2.frame = CGRectMake(92, 92, 40, 40);
    }
    return _shiningAnimationView2;
}

@end
