//
//  ViewController.m
//  KVODemo
//
//  Created by Dai Pei on 2016/12/21.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.count = 0;
    
    
    self.button.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:self.button];
    
    self.label.frame = CGRectMake(100, 50, 50, 20);
    [self.view addSubview:self.label];
    
    [self addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"count"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%li", (long)self.count);
    self.label.text = [NSString stringWithFormat:@"%li", (long)self.count];
    
}

#pragma mark - Action Method

- (void)buttonClicked:(UIButton *)sender {
    self.count++;
}

#pragma mark - Getter

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button setTitle:@"button" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = [NSString stringWithFormat:@"%li", (long)self.count];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
