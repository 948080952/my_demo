//
//  ViewController.m
//  DPAutoScrollView
//
//  Created by DaiPei on 2017/2/17.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

#import "ViewController.h"
#import "DPAutoScrollView.h"
#import "TestViewController.h"

@interface ViewController ()

@property (nonatomic, strong) DPAutoScrollView *floor1;
@property (nonatomic, strong) DPAutoScrollView *floor2;
@property (nonatomic, strong) DPAutoScrollView *floor3;
@property (nonatomic, assign) BOOL state;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.floor1 = [[DPAutoScrollView alloc] init];
    [self.floor1 setImage:[UIImage imageNamed:@"image_floor"]];
    [self.floor1 setIntialSpeed:100];
    self.floor1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    [self.view addSubview:self.floor1];
    [self.floor1 startScroll];
    
}

- (IBAction)present:(id)sender {
    TestViewController *testVC = [[TestViewController alloc] init];
    [self presentViewController:testVC animated:YES completion:nil];
}

- (IBAction)startScroll:(id)sender {
    [self.floor1 startScroll];
}

- (IBAction)stopScroll:(id)sender {
    [self.floor1 stopScroll];
}

- (IBAction)speedUp:(id)sender {
    [self.floor1 speedUp:0.2];
}

- (IBAction)speedDown:(id)sender {
    [self.floor1 speedDown:-0.2];
}
- (IBAction)reset:(id)sender {
    [self.floor1 resetSpeed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
