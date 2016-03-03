//
//  DPTabBar.m
//  SnapUpload
//
//  Created by Dai Pei on 16/2/24.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import "DPTabBar.h"
#import "DPTabBarItem.h"

@implementation DPTabBar

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame SelectedImages:(NSArray *)selectedImages andUnSelectedImages:(NSArray *)unSelectedImages {
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.selectedImages = selectedImages;
        self.unSelectedImages = unSelectedImages;
        _itemNumbers = [selectedImages count];
        [self ConfigViews];
    }
    return self;
}

#pragma mark - ConfigViews

- (void)ConfigViews {
    CGFloat itemWidth = self.frame.size.width / _itemNumbers;
    CGFloat itemHeight = self.frame.size.height;
    for (NSInteger i = 0; i < _itemNumbers; i++) {
        DPTabBarItem *item = [[DPTabBarItem alloc] init];
        item.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
        UIImage *selectedImage = [UIImage imageNamed:self.selectedImages[i]];
        UIImage *unSelectedImage = [UIImage imageNamed:self.unSelectedImages[i]];
        item.selectImage = selectedImage;
        item.unSelectImage = unSelectedImage;
        item.backgroundColor = [UIColor clearColor];
        item.selected = NO;
        [self.items addObject:item];
        [item addTarget:self action:@selector(itemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

#pragma mark - Action Method

- (void)setselectedItem:(NSInteger)index {
    _selectedItem = index;
    self.items[index].selected = YES;
}

#pragma mark - Private Method

- (void)itemWasSelected:(DPTabBarItem *)sender {
    NSInteger index = [self.items indexOfObject:sender];
    self.items[_selectedItem].selected = NO;
    _selectedItem = index;
    self.items[_selectedItem].selected = YES;
    [self.delegate selectedDidChange:_selectedItem];
}

#pragma mark - Getter

- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

@end
