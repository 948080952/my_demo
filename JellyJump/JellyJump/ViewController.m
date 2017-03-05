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
