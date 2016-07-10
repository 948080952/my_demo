//
//  StickerCell.m
//  StickerSample
//
//  Created by Dai Pei on 16/3/8.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "StickerCell.h"

@interface StickerCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation StickerCell


#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self ConfigViews];
    }
    return self;
}

#pragma mark - ConfigViews

- (void)ConfigViews {
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.contentImageView];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(7, 7, 7, 7));
    }];
    
}

#pragma mark - Action Method

- (void)setTextForLabel:(NSString *)text {
    self.contentLabel.text = text;
    self.contentLabel.hidden = NO;
    self.contentImageView.hidden = YES;
}

- (void)setImageForImageView:(UIImage *)image {
    self.contentImageView.image = image;
    self.contentImageView.hidden = NO;
    self.contentLabel.hidden = YES;
}

- (void)setPurchased:(BOOL)purchased {
    self.purchased = purchased;
    
}



#pragma mark - Getters

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:45 * rateToFit];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.backgroundColor = [UIColor clearColor];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}



@end
