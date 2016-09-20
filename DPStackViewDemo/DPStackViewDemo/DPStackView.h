//
//  DPStackView.h
//  DPStackViewDemo
//
//  Created by Dai Pei on 2016/8/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPStackViewCell;

typedef NS_ENUM(NSUInteger, DPStackViewScrollDirection) {
    DPStackViewScrollDirectionHorizontal,
    DPStackViewScrollDirectionVertical
};

@protocol DPStackViewDelegate;
@protocol DPStackViewDataSource;

@interface DPStackView : UIView

@property (nonatomic, assign) DPStackViewScrollDirection scrollDirection;
@property (nonatomic, weak) id<DPStackViewDelegate> delegate;
@property (nonatomic, weak) id<DPStackViewDataSource> dataSource;

- (instancetype)initWithBounds:(CGRect)bounds delegate:(id<DPStackViewDelegate>)delegate dataSource:(id<DPStackViewDataSource>)dataSource;

- (void)registerCellClass:(Class)viewClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)reloadData;
- (void)finishSetup;

@end


@protocol DPStackViewDelegate <NSObject>

@required
- (CGSize)stackView:(DPStackView *)stackView sizeForItemAtIndex:(NSUInteger)index;

@optional
- (void)stackView:(DPStackView *)stackView didSelectAtIndex:(NSUInteger)index;

@end

@protocol DPStackViewDataSource <NSObject>

@required
- (DPStackViewCell *)stackView:(DPStackView *)stackView cellForItemAtIndex:(NSUInteger)index withReusableCell:(DPStackViewCell *)cell;
- (NSUInteger)numberOfItemsInStackView:(DPStackView *)stackView;


@end