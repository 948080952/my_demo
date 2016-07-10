//
//  RecentStickerHelper.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/12.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StickerPageModel.h"

@interface RecentStickerHelper : NSObject {
    NSInteger _numberOfStacks;
    NSString *_packageName;
    NSMutableArray *_contents;
}
//@property (nonatomic, strong)NSMutableArray *contents;

- (instancetype)initWithPackageName:(NSString *)name;
- (void)loadDataFromPageModel:(StickerPageModel *)page;
- (BOOL)loadDataFromUserDefault;
- (void)saveDataToUserDefault;
- (void)addSticker:(NSString *)stickerName;
- (NSMutableArray *)getContents;

@end
