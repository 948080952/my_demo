//
//  ViewController.m
//  emojiCollectionView
//
//  Created by Dai Pei on 16/2/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "emojiCollectionViewController.h"
#import "RateForFit.h"
#import "EmojiPageViewController.h"
#import "EditedView.h"

@interface ViewController () 

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) EmojiPageViewController *emojiPageViewController;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure

- (void)configViews {
    
    [self.view addSubview:self.button];
    
//    [self addChildViewController:self.mPageViewController];
//    [self.view addSubview:self.mPageViewController.view];
//    self.mPageViewController.view.frame = [[UIScreen mainScreen] bounds];
//    [self.parentViewController didMoveToParentViewController:self];
//    
//    
//    [self.view addSubview:self.segmentControl];
    
}


#pragma mark - Action method

- (void)popCollectionView:(UIButton *)sender {
        self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.emojiPageViewController.view.backgroundColor = [UIColor clearColor];
    [self presentViewController:self.emojiPageViewController animated:YES completion:^{
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }];
}



#pragma mark - Getters






- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button.frame = CGRectMake(100, 100, 100, 50);
        [_button setTitle:@"emoji" forState:UIControlStateNormal];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button addTarget:self action:@selector(popCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


- (EmojiPageViewController *)emojiPageViewController {
    if (!_emojiPageViewController) {
        _emojiPageViewController = [[EmojiPageViewController alloc] initWithBlock:^(UILabel *emojiLabel) {
            EditedView *emojiView = [[EditedView alloc] initWithEmojiUILabel:emojiLabel];
            [self.view addSubview:emojiView];
            [EditedView setActiveEditedView:emojiView];
        }];
    }
    return _emojiPageViewController;
}


@end
