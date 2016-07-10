//
//  RecentStickerHelper.m
//  StickerSample
//
//  Created by Dai Pei on 16/3/12.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "RecentStickerHelper.h"
#import "SectionModel.h"
#import "StickerModel.h"

@implementation RecentStickerHelper

- (instancetype)initWithPackageName:(NSString *)name {
    self = [super init];
    if (self) {
        _packageName = name;
    }
    return self;
}

- (void)loadDataFromPageModel:(StickerPageModel *)page {
    SectionModel *section = page.sections[0];
    _numberOfStacks = section.stickers.count;
    _contents = [[NSMutableArray alloc] init];
    for (int i = 0; i < section.stickers.count; i ++) {
        StickerModel *sticker = section.stickers[i];
        [_contents addObject:sticker.stickerName];
    }
    if (![self loadDataFromUserDefault]) {
        [self saveDataToUserDefault];
    }
}

- (BOOL)loadDataFromUserDefault {
    BOOL haveDataInUserDefault = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_packageName]) {
        haveDataInUserDefault = YES;
//        _contents = [[NSUserDefaults standardUserDefaults] objectForKey:_packageName];
        NSArray *tmpArray = [[NSUserDefaults standardUserDefaults] objectForKey:_packageName];
        _contents = [[NSMutableArray alloc] init];
        for (NSString *stickerName in tmpArray) {
            [_contents addObject:stickerName];
        }
    }
    return haveDataInUserDefault;
}

- (void)saveDataToUserDefault {
    [[NSUserDefaults standardUserDefaults] setObject:_contents forKey:_packageName];
}

- (void)addSticker:(NSString *)stickerName {
    BOOL isStringInStack = NO;
    
    for (NSInteger i = 0; i < _numberOfStacks; i++) {
        
        if ([stickerName isEqualToString:_contents[i]]) {
            [_contents removeObjectAtIndex:i];
            isStringInStack = YES;
            break;
        }
    }
    

    [_contents insertObject:stickerName atIndex:0];
    
    if (!isStringInStack) {
        
        [_contents removeObjectAtIndex:_numberOfStacks];
    }
    [self saveDataToUserDefault];
}

- (NSMutableArray *)getContents {
    return _contents;
}



@end
