//
//  SectionModel.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/8.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "StickerModel.h"

@protocol SectionModel;
@interface SectionModel : JSONModel

@property (nonatomic, strong) NSArray<StickerModel, ConvertOnDemand> *stickers;
@property (nonatomic, strong) NSString *headerName;
@property (nonatomic, strong) NSString *footerName;

@end
