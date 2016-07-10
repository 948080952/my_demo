//
//  AutoScrollIamgeView.m
//  AutoScrollImageSample
//
//  Created by Dai Pei on 16/3/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "AutoScrollIamgeView.h"

@interface AutoScrollIamgeView () {
    NSInteger _currentIndex;
}

@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)UIScrollView *scrollView;

@end

@implementation AutoScrollIamgeView

#pragma mark - Init


- (instancetype)initWithFrame:(CGRect)frame andImageData:(NSArray *)imageArray {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        self.imageArray = imageArray;
        [self ConfigViews];

    }
    return self;
}

#pragma mark - Action Method

- (void)setIntervals:(CGFloat)intervals {
    _intervals = intervals;
}

- (void)startScroll {
    [NSTimer scheduledTimerWithTimeInterval:self.intervals target:self selector:@selector(changeIndex) userInfo:nil repeats:YES];
}

#pragma mark - Privite Method

- (void)changeIndex {
    _currentIndex++;
    _currentIndex = _currentIndex > self.imageArray.count ? 0 : _currentIndex;
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    [self.scrollView scrollRectToVisible:CGRectMake(width * _currentIndex, 0, width, height) animated:YES];
}

#pragma mark - ConfigViews

- (void)ConfigViews {
    
    [self.scrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.scrollView];
    
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = YES;
//        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        CGFloat imageWidth = self.frame.size.width;
        CGFloat imageHeight = self.frame.size.width;
        
        for (int i = 0; i < self.imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth * i,
                                                                                   0,
                                                                                   imageWidth,
                                                                                   imageHeight)];
            imageView.image = [UIImage imageNamed:self.imageArray[i]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_scrollView addSubview:imageView];
        }
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, imageWidth, imageWidth) animated:NO];
        [_scrollView setContentSize:CGSizeMake(imageWidth * self.imageArray.count, imageHeight)];
        
    }
    return _scrollView;
}


@end
