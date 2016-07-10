//
//  StickerCell.h
//  StickerSample
//
//  Created by Dai Pei on 16/3/8.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerCell : UICollectionViewCell

- (void)setTextForLabel:(NSString *)text;
- (void)setImageForImageView:(UIImage *)image;
@property (nonatomic, assign)BOOL purchased;

@end
