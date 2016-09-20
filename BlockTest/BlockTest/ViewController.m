//
//  ViewController.m
//  BlockTest
//
//  Created by Dai Pei on 2016/8/26.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"

typedef int(^blk)(int count);
typedef int (^blkt1)(void);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    blk block = func2(2);
//    block(1);
    [self stackOrHeap];
//    [self stackOrHeap2];
    UIView *view = [[UIView alloc] init];
    view = [UIView new];
}

//- (blk)func:(int)rate {
//    return ^(int count){
//        NSLog(@"rate %i", rate);
//        return rate;
//    };
//}
//
//blk func2(int rate) {
//    return ^(int count){
//        NSLog(@"rate %i", rate);
//        return rate;
//    };
//}

-(void) stackOrHeap{
    __block int val =10;
    int *valPtr = &val;
    blkt1 s= ^{
        NSLog(@"val_block = %d",++val);
        return val;};
    s();
    blkt1 h = [s copy];
    h();
    
    NSLog(@"valPointer = %d",*valPtr);
}

-(void) stackOrHeap2{
    __block int val =10;
    int *valPtr = &val;
    blkt1 s= ^{
        NSLog(@"val_block2 = %d",++val);
        return val;};
    s();
    NSLog(@"valPointer2 = %d",*valPtr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
