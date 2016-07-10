//
//  StickerViewController.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StickerViewControllerDelegate;

@interface StickerViewController : UIViewController

@property (nonatomic, weak)id<StickerViewControllerDelegate> delegate;
- (instancetype)initWithStickerArray:(NSArray *)stickerPackages;

@end

@protocol StickerViewControllerDelegate <NSObject>

@required
- (void)addStickers:(NSMutableArray *)stickers;

@end