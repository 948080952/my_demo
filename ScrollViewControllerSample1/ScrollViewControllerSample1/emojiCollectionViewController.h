//
//  emojiCollectionViewController.h//  emojiCollectionView
//
//  Created by Dai Pei on 16/2/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

typedef NS_ENUM(NSInteger, EmojiCategoryType) {
    EmojiCategoryTypeRecent = 0,
    EmojiCategoryTypePeople,
    EmojiCategoryTypeNature,
    EmojiCategoryTypeFoods,
    EmojiCategoryTypeActivity,
    EmojiCategoryTypePlaces,
    EmojiCategoryTypeObjects,
    EmojiCategoryTypeSymbols,
    EmojiCategoryTypeFlags,
    EmojiCategoryTypeNumber
};

typedef void (^AddEmojiViewBlock)(UILabel *emojiLabel);

@interface emojiCollectionViewController : UIViewController

- (instancetype)initWithTypeSource:(EmojiCategoryType)type;

- (instancetype)initWithTypeSource:(EmojiCategoryType)type andBlock:(AddEmojiViewBlock) block;

@end
