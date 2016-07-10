//
//  DPDownloadManager.h
//  DownloadTaskSample1
//
//  Created by Dai Pei on 16/3/27.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#define AdsCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"AdsCache"]

#define AdsFileName(url) url.lastPathComponent

#define AdsFileFullpath(url) [AdsCachesDirectory stringByAppendingPathComponent:AdsFileName(url)]

#import <Foundation/Foundation.h>

@interface DPDownloadManager : NSObject



@end
