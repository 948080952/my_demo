//
//  DPToastModel.h
//  DPToastDemo
//
//  Created by Dai Pei on 16/4/11.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DPToastType) {
    DPToastTypeLoading = 0,
    DPToastTypeMessage,
    DPToastTypeUnknown
};

typedef NS_ENUM(NSUInteger, DPToastPosition) {
    DPToastPositionLoadingDefault = 0,
    DPToastPositionLoadingTop,
    DPToastPositionLoadingCenter,
    DPToastPositionLoadingBottom,
    DPToastPositionMessageDefault,
    DPToastPositionMessageTop,
    DPToastPositionMessageCenter,
    DPToastPositionMessageBottom
};

@interface DPToastModel : NSObject

@property (nonatomic, assign)DPToastType toastType;
@property (nonatomic, assign)DPToastPosition position;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, assign)NSTimeInterval interval;

@end
