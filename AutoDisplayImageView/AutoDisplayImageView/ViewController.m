//
//  ViewController.m
//  AutoDisplayImageView
//
//  Created by Dai Pei on 16/3/19.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)UIImageView *autoDisplayimageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.autoDisplayimageView];
    self.autoDisplayimageView.frame = self.view.frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.autoDisplayimageView startAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)autoDisplayimageView {
    if (!_autoDisplayimageView) {
        _autoDisplayimageView = [[UIImageView alloc] init];
        _autoDisplayimageView.animationImages = [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"1-1.jpg"],
                                                 [UIImage imageNamed:@"1-2.jpg"],
                                                 [UIImage imageNamed:@"1-3.jpg"],
                                                 [UIImage imageNamed:@"1-4.jpg"], nil];
    }
    _autoDisplayimageView.animationRepeatCount = 0;
    _autoDisplayimageView.animationDuration = 10;
    return _autoDisplayimageView;
}

@end
