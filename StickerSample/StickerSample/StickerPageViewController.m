//
//  StickerPageViewController.m
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "StickerPageViewController.h"
#import "StickerPackageModel.h"
#import "StickerCollectionViewController.h"
#import "DZNSegmentedControl.h"
#import "StickerCollectionViewController.h"
#import "RecentStickerHelper.h"


@interface StickerPageViewController()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, StickerCollectionViewControllerDelegate> {
    StickerCollectionViewController *_nextViewController;
    BOOL _isSwipe;
    NSInteger _currentSegmentIndex;
    NSInteger _packageNumber;
}

@property (nonatomic, strong)StickerPackageModel *stickerPackage;
@property (nonatomic, strong)UIPageViewController *pageViewController;
@property (nonatomic, strong)NSMutableArray *stickerCollectionViewControllerArray;
@property (nonatomic, strong)DZNSegmentedControl *segmentControl;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation StickerPageViewController

#pragma mark - Init

- (instancetype)initWithPackageModel:(StickerPackageModel *)packageModel andPackageNumber:(NSInteger)number {
    self = [super init];
    if (self) {
        self.stickerPackage = packageModel;
        _packageNumber = number;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self ConfigViews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - ConfigViews

- (void)ConfigViews {
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(83);
        make.width.mas_equalTo(240*rateToFit);
        make.height.mas_equalTo(20*rateToFit);
    }];
    if (self.stickerPackage.pages.count == 1) {
        self.segmentControl.hidden = YES;
    }
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(32);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(150*rateToFit);
        make.height.mas_equalTo(28*rateToFit);
    }];
}

#pragma mark - UIPageViewControllerDelegate

- (void) pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    _nextViewController = (StickerCollectionViewController *)pendingViewControllers.firstObject;
    
}

- (void) pageViewController:(UIPageViewController *)pageViewController
         didFinishAnimating:(BOOL)finished
    previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
        transitionCompleted:(BOOL)completed {
    
    if (completed) {
        NSInteger index = [self.stickerCollectionViewControllerArray indexOfObject:_nextViewController];
        if (finished) {
            _isSwipe = YES;
            [self.segmentControl setSelectedSegmentIndex:index];
        }
    }else {
        _nextViewController = (StickerCollectionViewController *)previousViewControllers.firstObject;
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if ([self.stickerCollectionViewControllerArray count] == 1) {
        return nil;
    }
    
    NSInteger index = [self.stickerCollectionViewControllerArray indexOfObject:viewController];
    
    if (NSNotFound == index || index == 0) {
        return nil;
    }else {
        return self.stickerCollectionViewControllerArray[index - 1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if ([self.stickerCollectionViewControllerArray count] == 1) {
        return nil;
    }
    
    NSInteger index = [self.stickerCollectionViewControllerArray indexOfObject:viewController];
    
    if (NSNotFound == index || [self.stickerCollectionViewControllerArray count] - 1 == index) {
        return nil;
    }else {
        return self.stickerCollectionViewControllerArray[index + 1];
    }
}

#pragma mark - StickerCollectionViewControllerDelegate

- (void)stickerDidSelected:(NSIndexPath *)cellIndex andPageIndex:(NSInteger)pageIndex withFrame:(CGRect)frame {
    if ([self.delegate respondsToSelector:@selector(stickerDidSelected:andPageIndex:andPackageIndex:withFrame:)]) {
        [self.delegate stickerDidSelected:cellIndex andPageIndex:pageIndex andPackageIndex:_packageNumber withFrame:frame];
    }
}

#pragma mark - Privite Method

- (void)segmentDidChange:(DZNSegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    if (!_isSwipe) {
        StickerCollectionViewController *currentVC = self.stickerCollectionViewControllerArray[index];
        UIPageViewControllerNavigationDirection direction = index > _currentSegmentIndex ?
        UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        [self.pageViewController setViewControllers:@[currentVC]
                                          direction:direction
                                           animated:NO
                                         completion:nil];
    }
    _currentSegmentIndex = index;
    _isSwipe = NO;
}


#pragma mark - Getters

- (NSMutableArray *)stickerCollectionViewControllerArray {
    if (!_stickerCollectionViewControllerArray) {
        _stickerCollectionViewControllerArray = [[NSMutableArray alloc] init];
        
        if (self.stickerPackage.recentPageIndex == -1) {
            for (NSInteger i = 0; i < [self.stickerPackage.pages count]; i++) {
                StickerCollectionViewController *collectionVC = [[StickerCollectionViewController alloc] initWithPageModel:self.stickerPackage.pages[i] andBundleName:self.stickerPackage.bundleName];
                collectionVC.delegate = self;
                [_stickerCollectionViewControllerArray addObject:collectionVC];
            }
        }else {
            RecentStickerHelper *recentStickerHelper = [[RecentStickerHelper alloc] initWithPackageName:self.stickerPackage.packageName];
            [recentStickerHelper loadDataFromPageModel:self.stickerPackage.pages[self.stickerPackage.recentPageIndex]];
            for (NSInteger i = 0; i < [self.stickerPackage.pages count]; i++) {
                StickerCollectionViewController *collectionVC = [[StickerCollectionViewController alloc] initWithPageModel:self.stickerPackage.pages[i] andBundleName:self.stickerPackage.bundleName andRecentStickerHelper:recentStickerHelper andRecentPage:(i == self.stickerPackage.recentPageIndex)];
                collectionVC.delegate = self;
                [_stickerCollectionViewControllerArray addObject:collectionVC];
            }
        }
        
    }
    return _stickerCollectionViewControllerArray;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        [_pageViewController setViewControllers:@[self.stickerCollectionViewControllerArray[self.stickerPackage.defaultPageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        _pageViewController.view.backgroundColor = [UIColor clearColor];
        _pageViewController.view.bounds = [[UIScreen mainScreen] bounds];
    }
    return _pageViewController;
}

- (DZNSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        NSMutableArray<NSString *> *segmentArray = [[NSMutableArray alloc] init];
        NSMutableArray<NSString *> *imageNameArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [self.stickerPackage.pages count]; i++) {
            StickerPageModel *page = self.stickerPackage.pages[i];
            [segmentArray addObject:page.pageName];
            [imageNameArray addObject:page.pageIconName];
        }
        _segmentControl = [[DZNSegmentedControl alloc] initWithItems:segmentArray];
        [_segmentControl setItemsImageName:imageNameArray];
        _segmentControl.showsImage = YES;
        _currentSegmentIndex = self.stickerPackage.defaultPageIndex;
        _segmentControl.selectedSegmentIndex = _currentSegmentIndex;
        _segmentControl.showsCount = NO;
        _segmentControl.highlightColor = [UIColor whiteColor];
        _segmentControl.selectionIndicatorBackgroudColor = [UIColor clearColor];
        _segmentControl.selectionIndicatorHeight = 0;
        [_segmentControl setBackgroundColor:[UIColor clearColor]];
        _segmentControl.showHairLine = NO;
        [_segmentControl addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentControl;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.stickerPackage.titleName;
        _titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:24*rateToFit];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
