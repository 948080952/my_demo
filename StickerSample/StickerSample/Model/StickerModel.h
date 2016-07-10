//
//  StickerModel.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//


#import "ComponentModel.h"
#import "JSONModel.h"

@protocol StickerModel @end
@interface StickerModel : JSONModel

@property (nonatomic, strong) NSString *stickerName;
@property (nonatomic, strong) NSArray<ComponentModel, ConvertOnDemand> *components;

@end
