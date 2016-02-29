//
//  EmojiPageViewController.m
//  emojiCollectionView
//
//  Created by Dai Pei on 16/2/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "EmojiPageViewController.h"
#import "RateForFit.h"

@interface EmojiPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
    emojiCollectionViewController *_nextViewController;
    EmojiCategoryType _currentSegmentIndex;
    AddEmojiViewBlock _block;
}

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *emojiViewControllerArray;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation EmojiPageViewController

#pragma mark - Init

- (instancetype)initWithBlock:(AddEmojiViewBlock) block {
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPageViewControllerDelegate

- (void) pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    _nextViewController = (emojiCollectionViewController *)pendingViewControllers.firstObject;
    
}

- (void) pageViewController:(UIPageViewController *)pageViewController
         didFinishAnimating:(BOOL)finished
    previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
        transitionCompleted:(BOOL)completed {
    
    if (completed) {
        NSInteger index = [self.emojiViewControllerArray indexOfObject:_nextViewController];
        [self.segmentControl setSelectedSegmentIndex:index];
        _currentSegmentIndex = index;
    }else {
        _nextViewController = (emojiCollectionViewController *)previousViewControllers.firstObject;
    }
    
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.emojiViewControllerArray indexOfObject:viewController];
    if (NSNotFound == index || EmojiCategoryTypeRecent == index) {
        return nil;
    }else {
        return self.emojiViewControllerArray[index - 1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.emojiViewControllerArray indexOfObject:viewController];
    if (NSNotFound == index || EmojiCategoryTypeFlags == index) {
        return nil;
    }else {
        return self.emojiViewControllerArray[index + 1];
    }
}


#pragma mark - Action Method

- (void)segmentDidChange:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    if (index - _currentSegmentIndex > 1 || _currentSegmentIndex - index > 1) {
        if (index > _currentSegmentIndex) {
            for (int i = _currentSegmentIndex + 1; i <= index; ++i) {
                emojiCollectionViewController *currentVC = self.emojiViewControllerArray[i];
                [self.pageViewController setViewControllers:@[currentVC]
                                                   direction:UIPageViewControllerNavigationDirectionForward
                                                    animated:YES
                                                  completion:nil];
            }
        }else {
            for (NSInteger i = _currentSegmentIndex - 1; i >= index; --i) {
                emojiCollectionViewController *currentVC = self.emojiViewControllerArray[i];
                [self.pageViewController setViewControllers:@[currentVC]
                                                   direction:UIPageViewControllerNavigationDirectionReverse
                                                    animated:YES
                                                  completion:nil];
            }
        }
    }else {
        emojiCollectionViewController *currentVC = self.emojiViewControllerArray[index];
        UIPageViewControllerNavigationDirection direction = index > _currentSegmentIndex ?
        UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        [self.pageViewController setViewControllers:@[currentVC]
                                           direction:direction
                                            animated:YES
                                          completion:nil];
    }
    
    _currentSegmentIndex = index;
}


#pragma mark - Getters

- (NSMutableArray *)emojiViewControllerArray {
    if (!_emojiViewControllerArray) {
        _emojiViewControllerArray = [NSMutableArray array];
        for (int i = 0; i < EmojiCategoryTypeNumber; i++) {
            emojiCollectionViewController *emojiCollectionVC = [[emojiCollectionViewController alloc] initWithTypeSource:(EmojiCategoryType)i andBlock:_block];
            [_emojiViewControllerArray addObject:emojiCollectionVC];
        }
        
    }
    return _emojiViewControllerArray;
}


- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        [_pageViewController setViewControllers:@[self.emojiViewControllerArray[EmojiCategoryTypePeople]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        _pageViewController.view.backgroundColor = [UIColor blackColor];
        _pageViewController.view.bounds = [[UIScreen mainScreen] bounds];
        [_pageViewController.view addSubview:self.segmentControl];
    }
    return _pageViewController;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        NSArray *segmentArray = [NSArray arrayWithObjects:@"recent", @"people", @"nature", @"foods", @"activity", @"places", @"objects", @"symbols", @"flags", nil];
        _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
        _segmentControl.frame = CGRectMake(0, screenHeight - 50*rateToFit, screenWidth, 50*rateToFit);
        _currentSegmentIndex = EmojiCategoryTypePeople;
        _segmentControl.selectedSegmentIndex = _currentSegmentIndex;
        [_segmentControl addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentControl;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
