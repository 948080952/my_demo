//
//  StickerDataController.m
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "StickerDataController.h"
#import "StickerPackageModel.h"



@implementation StickerDataController

+ (instancetype)sharedInstance {
    static StickerDataController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[StickerDataController alloc] init];
        [instance initData];
    });
    return instance;
}

- (void)initData {
    [self initDataFromLocal];
    [self initDataFromRemote];
}

- (void)initDataFromLocal {
    NSString *path;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        path = [[NSBundle mainBundle] pathForResource:@"emoji_mini" ofType:@"json"];
    }else {
        path = [[NSBundle mainBundle] pathForResource:@"emoji1" ofType:@"json"];
    }
    NSError *error = nil;
    NSString *jsonStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    StickerPackageModel *model = [[StickerPackageModel alloc] initWithString:jsonStr error:nil];
//    NSLog(@"packageSelectedIconName:%@", model.packageSelectedIconName);
//    NSLog(@"packageUnselectedIconName:%@",model.packageUnselectedIconName);
//    NSLog(@"defaultPageIndex:%ld", (long)model.defaultPageIndex);
//    NSLog(@"error:%@", error);
    [self.stickerPackages addObject:model];
    
    NSBundle *bundle1 = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"TrinkitImage" withExtension:@"bundle"]];
    NSString *path2 = [bundle1 pathForResource:@"trinkit" ofType:@"json"];
    NSString *jsonStr2 = [[NSString alloc] initWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
    StickerPackageModel *model2 = [[StickerPackageModel alloc] initWithString:jsonStr2 error:nil];
    [self.stickerPackages addObject:model2];
    
    NSBundle *bundle2 = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SuitImage" withExtension:@"bundle"]];
    NSString *path3 = [bundle2 pathForResource:@"suit" ofType:@"json"];
    NSString *jsonStr3 = [[NSString alloc] initWithContentsOfFile:path3 encoding:NSUTF8StringEncoding error:nil];
    StickerPackageModel *model3 = [[StickerPackageModel alloc] initWithString:jsonStr3 error:nil];
    [self.stickerPackages addObject:model3];
}

- (void)initDataFromRemote {
    
}

- (NSMutableArray *)stickerPackages {
    if (!_stickerPackages) {
        _stickerPackages = [[NSMutableArray alloc] init];
    }
    return _stickerPackages;
}


@end
