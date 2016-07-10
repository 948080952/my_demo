//
//  ViewController.m
//  AVPlayerSample1
//
//  Created by Dai Pei on 16/3/18.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "VideoView.h"

@interface ViewController () {
    NSURL *_url;
}

@property (nonatomic, strong)NSURL *videoURL;
@property (nonatomic, strong)VideoView *videoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.videoView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.videoView startVideoPlay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Getters

- (VideoView *)videoView {
    if (!_videoView) {
        _videoView = [[VideoView alloc] initWithFrame:self.view.bounds andVideoUrl:self.videoURL];
    }
    return _videoView;
}

- (NSURL *)videoURL {
    if (!_videoURL) {
        _videoURL = [[NSBundle mainBundle] URLForResource:@"jingongshixi" withExtension:@"mp4"];
    }
    return _videoURL;
}



@end
