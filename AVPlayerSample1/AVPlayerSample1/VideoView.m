//
//  VideoView.m
//  AVPlayerSample1
//
//  Created by Dai Pei on 16/3/18.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "VideoView.h"
#import <AVFoundation/AVFoundation.h>


@interface VideoView () {
    NSURL *_videoUrl;
}

@property (nonatomic, strong)AVPlayerItem *playerItem;
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)AVPlayerLayer *playerLayer;

@end

@implementation VideoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andVideoUrl:(NSURL *)videoUrl {
    self = [super initWithFrame:frame];
    if (self) {
        _videoUrl = videoUrl;
        [self ConfigViews];
    }
    return self;
}

- (void)ConfigViews {
    [self.layer addSublayer:self.playerLayer];
}


#pragma Action Method

- (void)startVideoPlay {
    [self.player play];
}

#pragma mark - Getters

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _playerLayer;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    }
    return _player;
}

- (AVPlayerItem *)playerItem {
    if (!_playerItem) {
        _playerItem = [[AVPlayerItem alloc] initWithURL:_videoUrl];
    }
    return _playerItem;
}

@end
