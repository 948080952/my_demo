//
//  EditedView.h
//  emojiCollectionView
//
//  Created by Dai Pei on 16/2/18.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditedView : UIView

+ (void)setActiveEditedView:(EditedView *)view;
- (instancetype)initWithEmojiUILabel:(UILabel *)label;
- (void)setScale:(CGFloat)scale;


@end
