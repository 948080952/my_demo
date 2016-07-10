//
//  ComponentModel.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "JSONModel.h"
#import <CoreGraphics/CoreGraphics.h>

@protocol ComponentModel @end

@interface ComponentModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *componentName;
@property (nonatomic, assign) CGFloat relativeCenterX;
@property (nonatomic, assign) CGFloat relativeCenterY;
@property (nonatomic, assign) CGFloat relativeWidth;
@property (nonatomic, assign) CGFloat relativeHeight;

@end
