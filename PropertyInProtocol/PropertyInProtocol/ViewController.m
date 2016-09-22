//
//  ViewController.m
//  PropertyInProtocol
//
//  Created by Dai Pei on 2016/9/21.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "MyProtocol.h"

@interface ViewController ()

//@property(nonatomic, readonly, copy) NSString *myName;
@property(nullable, nonatomic, readwrite, copy) NSString *nibName;

@end

@implementation ViewController

//@synthesize myName = _myName;
@synthesize nibName = _nibName;


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.myName = @"";
    self.nibName = @"1";
    NSLog(@"%@ %@", self.nibName, super.nibName);
    
}

//- (NSString *)myName {
//    return _myName;
//}
//
//- (void)setMyName:(NSString *)myName {
//    _myName = myName;
//}


@end
