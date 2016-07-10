//
//  ViewController.m
//  AVPlayerSample2
//
//  Created by Dai Pei on 16/3/19.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong)AVPlayerViewController *playerViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addChildViewController:self.playerViewController];
    [self.view addSubview:self.playerViewController.view];
    [self.playerViewController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playerViewController.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AVPlayerViewController *)playerViewController {
    if (!_playerViewController) {
        _playerViewController = [[AVPlayerViewController alloc] init];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"jingongshixi" withExtension:@"mp4"];
        _playerViewController.player = [AVPlayer playerWithURL:url];
        _playerViewController.view.frame = self.view.frame;
        _playerViewController.showsPlaybackControls = NO;
        
    }
    return _playerViewController;
}


@end
