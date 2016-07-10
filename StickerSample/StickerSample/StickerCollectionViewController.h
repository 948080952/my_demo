//
//  StickerCollectionViewController.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StickerPageModel;
@class RecentStickerHelper;

@protocol StickerCollectionViewControllerDelegate;

@interface StickerCollectionViewController : UIViewController

@property (nonatomic, weak)id<StickerCollectionViewControllerDelegate> delegate;

- (instancetype)initWithPageModel:(StickerPageModel *)pageModel andBundleName:(NSString *)bundleName;
- (instancetype)initWithPageModel:(StickerPageModel *)pageModel andBundleName:(NSString *)bundleName andRecentStickerHelper:(RecentStickerHelper *)helper andRecentPage:(BOOL)isRecentPage;

@end

@protocol StickerCollectionViewControllerDelegate <NSObject>

@optional
- (void)stickerDidSelected:(NSIndexPath *)cellIndex andPageIndex:(NSInteger)pageIndex withFrame:(CGRect)frame;

@end