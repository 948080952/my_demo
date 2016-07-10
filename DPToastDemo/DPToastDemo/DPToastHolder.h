//
//  DPToastHolder.h
//  DPToastDemo
//
//  Created by Dai Pei on 16/4/10.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPToastModel.h"

@interface DPToastHolder : UIViewController

- (instancetype)initWithDPToastModel:(DPToastModel *)model;
- (void)addDPToastModel:(DPToastModel *)model;

@end
