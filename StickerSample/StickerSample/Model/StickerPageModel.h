//
//  StickerPageModel.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//


#import "StickerModel.h"
#import "JSONModel.h"
#import "SectionModel.h"

typedef NS_ENUM(NSInteger, StickerType) {
    StickerTypeSingle = 0,
    StickerTypeAssembled,
    StickerTypeEmoji
};

typedef NS_ENUM(NSInteger, CoordinateType) {
    CoordinateTypeRelative = 0,
    CoordinateTypeAbsolute
};

@protocol StickerPageModel @end

@interface StickerPageModel : JSONModel

@property (nonatomic, strong) NSArray<SectionModel, ConvertOnDemand> *sections;
@property (nonatomic, strong) NSString *pageIconName;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) StickerType stickerType;
@property (nonatomic, assign) NSInteger numberOfRow;
@property (nonatomic, assign) CoordinateType coordinateType;

@end

