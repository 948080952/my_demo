//
//  ViewController.m
//  DownloadTaskSample1
//
//  Created by Dai Pei on 16/3/26.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DPDownloadManager.h"

@interface ViewController () <NSURLSessionDownloadDelegate> {
    NSURL *_url;
}

@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *button2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.button];
    [self.view addSubview:self.button2];
    [self createCacheDirectory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)download {
    NSURL *url = [NSURL URLWithString:@"http://scontent-sjc2-1.cdninstagram.com/l/t50.2886-16/12824404_666704896814912_923717049_n.mp4"];
    _url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    [task resume];
}


- (void)start:(id)sender {
    [self download];
}

- (void)judge:(id)sender {
    if ([[NSFileManager defaultManager] fileExistsAtPath:AdsFileFullpath(_url)]) {
        [self judgeFileType:[NSURL fileURLWithPath:AdsFileFullpath(_url)]];
    }
}

- (void)createCacheDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:AdsCachesDirectory]) {
        [fileManager createDirectoryAtPath:AdsCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button setTitle:@"start" forState:UIControlStateNormal];
        [_button setFrame:CGRectMake(10, 10, 100, 50)];
        [_button addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button2 setTitle:@"judge" forState:UIControlStateNormal];
        [_button2 setFrame:CGRectMake(10, 100, 100, 50)];
        [_button2 addTarget:self action:@selector(judge:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[location path]]) {
        NSLog(@"download finished! %@", location);
    }else {
        NSLog(@"no such file or directory!");
    }
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:[location path] toPath:AdsFileFullpath(downloadTask.response.URL) error:&error];
    if (error) {
        NSLog(@"copy error:%@", error);
    }else {
        NSLog(@"copy succeed");
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"finish:%lld total:%lld", totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)judgeFileType:(NSURL *)url {
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    BOOL hasVideoTracks = [tracks count] > 0;
    if (hasVideoTracks) {
        NSLog(@"the file is video!");
    }else {
        NSLog(@"the file is not video!");
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"error:%@", error);
    }
}

@end
