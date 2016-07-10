//
//  JsonBuilder.m
//  StickerSample
//
//  Created by Dai Pei on 16/3/6.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "JsonBuilder.h"
#import <UIKit/UIKit.h>

@interface JsonBuilder ()

@property (nonatomic, strong) NSMutableArray *emojiCategoryArray;

@end

@implementation JsonBuilder

- (void)getJsonContent {
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Category-Emoji-Mini" ofType:@"json"];
    
    NSData *jsonData;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
//        jsonData = [[NSData alloc] initWithContentsOfFile:path2];
//    }else {
//        jsonData = [[NSData alloc] initWithContentsOfFile:path1];
//    }
    jsonData = [[NSData alloc] initWithContentsOfFile:path2];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
    NSArray *emojiCategoryDataArray = jsonDic[@"EmojiDataArray"];
    self.emojiCategoryArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [emojiCategoryDataArray count]; i++) {
        
        NSDictionary *categoryDic = emojiCategoryDataArray[i];
        NSDictionary *categoryDataDic = categoryDic[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        NSArray *emojisArray = [dataString componentsSeparatedByString:@","];
        [self.emojiCategoryArray addObject:emojisArray];
    }
    
}

- (void)serializeJson {
    NSDictionary *componentDic = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"componentName", [NSNumber numberWithInt:0], @"relativeCenterX", [NSNumber numberWithInt:0], @"relativeCenterY", [NSNumber numberWithInt:0], @"relativeWidth", [NSNumber numberWithInt:0], @"relativeHeight", nil];
    NSArray *componentArray = [NSArray arrayWithObject:componentDic];
    NSArray *pageIconArray = [NSArray arrayWithObjects:@"image_emojitype_recent", @"image_emojitype_people", @"image_emojitype_nature", @"image_emojitype_foods", @"image_emojitype_activity", @"image_emojitype_places", @"image_emojitype_objects", @"image_emojitype_symbols", @"image_emojitype_flags", nil];
    NSArray *pageNameArray = [NSArray arrayWithObjects:@"recent", @"people", @"nature", @"foods", @"activity", @"places", @"objects", @"foods", @"flags", nil];
    NSMutableArray *pagesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.emojiCategoryArray.count; i++) {
        NSArray *emojiArray = [self.emojiCategoryArray objectAtIndex:i];
        NSMutableArray *stickersArray = [[NSMutableArray alloc] init];
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *pageDic = nil;
        for (int j = 0; j < emojiArray.count; j++) {
            NSDictionary *stickerDic = [NSDictionary dictionaryWithObjectsAndKeys:emojiArray[j], @"stickerName", componentArray, @"components",nil];
            [stickersArray addObject:stickerDic];
        }
        NSDictionary *sectionDic = [NSDictionary dictionaryWithObjectsAndKeys:stickersArray, @"stickers", @"", @"sectionName", nil];
        [sectionArray addObject:sectionDic];
        pageDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:sectionArray, @"sections", pageIconArray[i], @"pageIconName", pageNameArray[i], @"pageName", [NSNumber numberWithInt:i], @"pageIndex", [NSNumber numberWithInt:2], @"stickerType", [NSNumber numberWithInt:5], @"numberOfRow", [NSNumber numberWithInt:0], @"coordinateType",nil];

        
        [pagesArray addObject:pageDic];
        
    }
    NSMutableDictionary *packageDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:pagesArray, @"pages", @"image_stickertype_emoji", @"packageSelectedIconName", @"image_stickertype_white_emoji", @"packageUnselectedIconName", 1, @"defaultPageIndex", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:packageDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonStr);
}

@end
