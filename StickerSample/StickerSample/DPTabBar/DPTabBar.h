//
//  DPTabBar.h
//  SnapUpload
//
//  Created by Dai Pei on 16/2/24.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPTabBarItem;

@protocol DPTabBarDelegate <NSObject>

@required
- (void)selectedDidChange:(NSInteger)index;

@end

@interface DPTabBar : UIView {
    NSInteger _itemNumbers;
    NSInteger _selectedItem;
}
@property (nonatomic, weak)id<DPTabBarDelegate> delegate;
@property (nonatomic, strong)NSArray *selectedImages;
@property (nonatomic, strong)NSArray *unSelectedImages;
@property (nonatomic, strong)NSMutableArray<DPTabBarItem *> *items;

- (instancetype)initWithFrame:(CGRect)frame SelectedImages:(NSArray *)selectedImages andUnSelectedImages:(NSArray *)unSelectedImages;
- (void)setselectedItem:(NSInteger)index;

@end
