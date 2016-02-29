//
//  ViewController.m
//  ScrollViewControllerSample1
//
//  Created by Dai Pei on 16/2/26.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "emojiCollectionViewController.h"

@interface ViewController ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ConfigViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - ConfigViews

- (void)ConfigViews {
    [self.view addSubview:self.scrollView];
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * 9, self.view.frame.size.height)];
        for (NSInteger i = 0; i < 9; i++) {
            emojiCollectionViewController *emojiVC = [[emojiCollectionViewController alloc] initWithTypeSource:(EmojiCategoryType)i];
            emojiVC.view.frame = CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height);
            [_scrollView addSubview:emojiVC.view];
            [self addChildViewController:emojiVC];
            [emojiVC didMoveToParentViewController:self];
        }
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}

@end
