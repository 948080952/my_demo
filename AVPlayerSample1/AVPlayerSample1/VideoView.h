//
//  VideoView.h
//  AVPlayerSample1
//
//  Created by Dai Pei on 16/3/18.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andVideoUrl:(NSURL *)videoUrl;
- (void)startVideoPlay;

@end
