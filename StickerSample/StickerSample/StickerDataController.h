//
//  StickerDataController.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StickerPackageModel.h"

@interface StickerDataController : NSObject

@property (nonatomic, strong)NSMutableArray<StickerPackageModel *> *stickerPackages;
+ (instancetype)sharedInstance;


@end
