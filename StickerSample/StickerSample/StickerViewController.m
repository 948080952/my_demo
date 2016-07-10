//
//  StickerViewController.m
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "StickerViewController.h"
#import "StickerDataController.h"
#import "StickerPackageModel.h"
#import "StickerPageModel.h"
#import "SectionModel.h"
#import "StickerPageViewController.h"
#import "DPTabBar.h"
#import "RecentStickerHelper.h"



@interface StickerViewController ()<DPTabBarDelegate, StickerPageViewControllerDelegate, StickerModel, StickerPageModel, ComponentModel> {
    NSInteger _numOfPackages;
    NSMutableArray *_selectedPackageIconArray;
    NSMutableArray *_unSelectedPackageIconArray;
    NSMutableArray *_stickerViewArray;
}

@property (nonatomic, strong)NSArray<StickerPackageModel *> *stickerPackages;
@property (nonatomic, strong)UIPageViewController *pageViewController;
@property (nonatomic, strong)NSMutableArray *stickerViewControllerArray;
@property (nonatomic, strong)DPTabBar *stickerTabBar;
@property (nonatomic, strong)UIImageView *closeButton;
@property (nonatomic, strong)UILabel *TitleLabel;


@end

@implementation StickerViewController

#pragma mark - Init

- (instancetype)initWithStickerArray:(NSArray *)stickerPackages {
    self = [super init];
    if (self) {
        self.stickerPackages = stickerPackages;
        _numOfPackages = [stickerPackages count];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ConfigViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConfigViews

- (void)ConfigViews {
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view addSubview:self.stickerTabBar];
    [self.stickerTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(44);
    }];
    
    [self.pageViewController.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageViewController.view).with.offset(32);
        make.left.equalTo(self.pageViewController.view).with.offset(15);
        make.width.mas_equalTo(28*rateToFit);
        make.height.mas_equalTo(28*rateToFit);
    }];
    
//    [self.pageViewController.view addSubview:self.TitleLabel];
//    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.closeButton);
//        make.centerX.equalTo(self.pageViewController.view);
//        make.width.mas_equalTo(150*rateToFit);
//        make.height.mas_equalTo(28*rateToFit);
//    }];
}

#pragma mark - Getters

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [_pageViewController setViewControllers:@[self.stickerViewControllerArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        _pageViewController.view.frame = [UIScreen mainScreen].bounds;
        _pageViewController.view.backgroundColor = [UIColor clearColor];
    }
    return _pageViewController;
}

- (NSMutableArray *)stickerViewControllerArray {
    if (!_stickerViewControllerArray) {
        _stickerViewControllerArray = [[NSMutableArray alloc] init];
        _selectedPackageIconArray = [[NSMutableArray alloc] init];
        _unSelectedPackageIconArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < _numOfPackages; i++) {
            StickerPageViewController *stickerPageViewController = [[StickerPageViewController alloc] initWithPackageModel:self.stickerPackages[i] andPackageNumber:i];
            stickerPageViewController.delegate = self;
            [_stickerViewControllerArray addObject:stickerPageViewController];
            if (self.stickerPackages[i].bundleName != nil) {
                NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:self.stickerPackages[i].bundleName withExtension:@"bundle"]];
                NSString *path1 = [bundle pathForResource:self.stickerPackages[i].packageSelectedIconName ofType:@"png"];
                NSString *path2 = [bundle pathForResource:self.stickerPackages[i].packageUnselectedIconName ofType:@"png"];
                UIImage *selectedImage = [UIImage imageWithContentsOfFile:path1];
                UIImage *unSelectedImage = [UIImage imageWithContentsOfFile:path2];
                [_selectedPackageIconArray addObject:selectedImage];
                [_unSelectedPackageIconArray addObject:unSelectedImage];
            }else {
                UIImage *selectedImage = [UIImage imageNamed:self.stickerPackages[i].packageSelectedIconName];
                UIImage *unSelectedImage = [UIImage imageNamed:self.stickerPackages[i].packageUnselectedIconName];
                [_selectedPackageIconArray addObject:selectedImage];
                [_unSelectedPackageIconArray addObject:unSelectedImage];
            }
        }
    }
    return _stickerViewControllerArray;
}

- (DPTabBar *)stickerTabBar {
    if (!_stickerTabBar) {
        _stickerTabBar = [[DPTabBar alloc] initWithFrame:CGRectMake(0, screenHeight - 44, screenWidth, 44) SelectedImages:_selectedPackageIconArray andUnSelectedImages:_unSelectedPackageIconArray];
        _stickerTabBar.delegate = self;
        [_stickerTabBar setselectedItem:0];
        [_stickerTabBar setLockState:NO forIndex:0];
        [_stickerTabBar setLockState:YES forIndex:1];
        [_stickerTabBar setLockState:YES forIndex:2];
    }
    return _stickerTabBar;
}

- (UIImageView *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIImageView alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"image_btn_close"]];
        _closeButton.tintColor = [UIColor whiteColor];
        _closeButton.userInteractionEnabled = YES;
        [_closeButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushCloseButton:)]];
    }
    return _closeButton;
}

- (UILabel *)TitleLabel {
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc] init];
        _TitleLabel.text = @"Add Stickers";
        _TitleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:24*rateToFit];
        _TitleLabel.backgroundColor = [UIColor clearColor];
        _TitleLabel.textColor = [UIColor whiteColor];
        _TitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _TitleLabel;
}

#pragma mark - StickerPageViewControllerDelegate

- (void)stickerDidSelected:(NSIndexPath *)cellIndex andPageIndex:(NSInteger)pageIndex andPackageIndex:(NSInteger)packageIndex withFrame:(CGRect)frame {
    _stickerViewArray = [[NSMutableArray alloc] init];
    StickerPackageModel *package = self.stickerPackages[packageIndex];
    StickerPageModel *page = package.pages[pageIndex];
    SectionModel *section = page.sections[cellIndex.section];
    StickerModel *sticker = section.stickers[cellIndex.row];
    RecentStickerHelper *recentStickerHelper = [[RecentStickerHelper alloc] initWithPackageName:package.packageName];
    [recentStickerHelper loadDataFromUserDefault];
    StickerType type = page.stickerType;
    switch (type) {
        case StickerTypeEmoji: {
            
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.backgroundColor = [UIColor clearColor];
            if (package.recentPageIndex != pageIndex) {
                label.text = sticker.stickerName;
            }else {
//                label.text = [recentStickerHelper getContents][cellIndex];
                label.text = [[recentStickerHelper getContents] objectAtIndex:cellIndex.row];
            }
            label.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:45 * rateToFit];
            label.textAlignment = NSTextAlignmentCenter;
            [_stickerViewArray addObject:label];
            break;
        }
        case StickerTypeSingle: {
            NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:self.stickerPackages[packageIndex].bundleName withExtension:@"bundle"]];
            NSString *imagePath = [bundle pathForResource:sticker.stickerName ofType:@"png"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            imageView.image = image;
            imageView.backgroundColor = [UIColor clearColor];
            [_stickerViewArray addObject:imageView];
            break;
        }
        case StickerTypeAssembled: {

            NSInteger componentNum = sticker.components.count;
            NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:self.stickerPackages[packageIndex].bundleName withExtension:@"bundle"]];
            for (NSInteger i = 0; i < componentNum; i++) {
                UIImageView *imageView = [[UIImageView alloc] init];
                ComponentModel *component = sticker.components[i];
                NSString *imagePath = [bundle pathForResource:component.componentName ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                imageView.bounds = CGRectMake(0, 0, screenWidth * component.relativeWidth,
                                                 screenWidth * component.relativeHeight);
                imageView.image = image;
                imageView.center = CGPointMake(screenWidth * component.relativeCenterX, screenHeight * component.relativeCenterY);
                imageView.backgroundColor = [UIColor clearColor];
                [_stickerViewArray addObject:imageView];
            }
            break;
        }
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(addStickers:)]) {
        [self.delegate addStickers:_stickerViewArray];
    }
}

#pragma mark - DPTabBarDelegate

- (void)selectedDidChange:(NSInteger)index {
    [self.pageViewController setViewControllers:@[self.stickerViewControllerArray[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Privite Method

- (void)pushCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
