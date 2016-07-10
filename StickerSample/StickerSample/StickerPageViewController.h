//
//  StickerPageViewController.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerPackageModel.h"

@protocol StickerPageViewControllerDelegate;

@interface StickerPageViewController : UIViewController

@property (nonatomic, weak)id<StickerPageViewControllerDelegate> delegate;
- (instancetype)initWithPackageModel:(StickerPackageModel *)packageModel andPackageNumber:(NSInteger)number;

@end

@protocol StickerPageViewControllerDelegate <NSObject>

@required
- (void)stickerDidSelected:(NSIndexPath *)cellIndex andPageIndex:(NSInteger)pageIndex andPackageIndex:(NSInteger)packageIndex withFrame:(CGRect)frame;

@end
