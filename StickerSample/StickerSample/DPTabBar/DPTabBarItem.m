//
//  DPTabBarItem.m
//  SnapUpload
//
//  Created by Dai Pei on 16/2/24.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import "DPTabBarItem.h"

@implementation DPTabBarItem

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    UIImage *image = nil;
    
    if ([self isSelected]) {
        image = self.selectImage;
    }else {
        image = self.unSelectImage;
    }
    
    imageSize = image.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [image drawInRect:CGRectMake((frameSize.width - imageSize.width) / 2, (frameSize.height - imageSize.height) / 2, imageSize.width, imageSize.height)];
    
    CGContextRestoreGState(context);
}

@end
