//
//  StickerPackageModel.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//


#import "StickerPageModel.h"
#import "JSONModel.h"



@interface StickerPackageModel : JSONModel

@property (nonatomic, strong) NSArray<StickerPageModel, ConvertOnDemand> *pages;
@property (nonatomic, strong) NSString *packageSelectedIconName;
@property (nonatomic, strong) NSString *packageUnselectedIconName;
@property (nonatomic, assign) NSInteger defaultPageIndex;
@property (nonatomic, strong) NSString *packageName;
@property (nonatomic, strong) NSString<Optional> *bundleName;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, assign) NSInteger recentPageIndex;

@end
