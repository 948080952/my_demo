//
//  ViewController.m
//  AutoScrollImageSample
//
//  Created by Dai Pei on 16/3/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "AutoScrollImageVC.h"
#import "AutoScrollIamgeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    AutoScrollImageVC *autoScrollImageVC = [[AutoScrollImageVC alloc] initWithImageData:@[@"image1", @"image2", @"image3", @"image4"]];
//    [autoScrollImageVC setIntervals:2];
//    [self addChildViewController:autoScrollImageVC];
//    [autoScrollImageVC didMoveToParentViewController:self];
//    autoScrollImageVC.view.frame = CGRectMake(40, 150, 150, 150);
//    [self.view addSubview:autoScrollImageVC.view];
//    [autoScrollImageVC startScroll];
    
    AutoScrollIamgeView *autoScrollImageView = [[AutoScrollIamgeView alloc] initWithFrame:CGRectMake(100, 100, 200, 200) andImageData:@[@"image1", @"image2", @"image3", @"image4"]];
    [autoScrollImageView setIntervals:2];
    [self.view addSubview:autoScrollImageView];
    [autoScrollImageView startScroll];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
