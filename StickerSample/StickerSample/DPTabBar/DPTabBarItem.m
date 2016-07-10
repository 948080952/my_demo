//
//  DPTabBarItem.m
//  SnapUpload
//
//  Created by Dai Pei on 16/2/24.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import "DPTabBarItem.h"

@implementation DPTabBarItem {
    UIImage *_lockImage;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        _lockImage = [UIImage imageNamed:@"image_sticker_lock"];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize lockImageSize = CGSizeZero;
    UIImage *image = nil;
    CGFloat alpha;
    
    if ([self isSelected]) {
        image = self.selectImage;
        alpha = 0.03f;
    }else {
        image = self.unSelectImage;
        alpha = 0.45;
    }
    
    imageSize = image.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:alpha] setFill];
    CGContextFillRect(context, rect);
    
    [image drawInRect:CGRectMake((frameSize.width - imageSize.width) / 2, (frameSize.height - imageSize.height) / 2, imageSize.width, imageSize.height)];
    
    if (self.showLockImage) {
        lockImageSize = _lockImage.size;
        [_lockImage drawInRect:CGRectMake(frameSize.width - lockImageSize.width, 0, lockImageSize.width, lockImageSize.height)];
    }
    
    CGContextRestoreGState(context);
}

@end
