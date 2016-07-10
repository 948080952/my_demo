//
//  StickerCollectionViewController.m
//  StickerSample
//
//  Created by Dai Pei on 16/3/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "StickerCollectionViewController.h"
#import "StickerPackageModel.h"
#import "StickerPageModel.h"
#import "StickerModel.h"
#import "ComponentModel.h"
#import "StickerCell.h"
#import "SectionModel.h"
#import "RecentStickerHelper.h"


static NSString *cellReuseIdentifier = @"cell";
static NSString *headerReuseIdentifier = @"header";
static NSString *footerReuseIdentifier = @"footer";

@interface StickerCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat cellWidth, cellHeight;
    NSString *_bundleName;
    RecentStickerHelper *_recentStickerHelper;
    BOOL _recentPage;
    BOOL _recordSticker;

}

@property (nonatomic, strong) StickerPageModel *stickerPage;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation StickerCollectionViewController

#pragma mark - Init



- (instancetype)initWithPageModel:(StickerPageModel *)pageModel andBundleName:(NSString *)bundleName {
    self = [super init];
    if (self) {
        self.stickerPage = pageModel;
        cellWidth = screenWidth / pageModel.numberOfRow - 10;
        cellHeight = cellWidth;
        _bundleName = bundleName;
        _recordSticker = NO;
    }
    return self;
}

- (instancetype)initWithPageModel:(StickerPageModel *)pageModel andBundleName:(NSString *)bundleName andRecentStickerHelper:(RecentStickerHelper *)helper andRecentPage:(BOOL)isRecentPage {
    
    self = [super init];
    if (self) {
        self.stickerPage = pageModel;
        cellWidth = screenWidth / pageModel.numberOfRow - 10;
        cellHeight = cellWidth;
        _bundleName = bundleName;
        _recentStickerHelper = helper;
        _recordSticker = YES;
        _recentPage = isRecentPage;
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

}

#pragma mark - ConfigViews 

- (void)ConfigViews {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(118);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(screenWidth - 30);
        make.bottom.equalTo(self.view).with.offset(-44);
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect rect = [collectionView convertRect:cell.frame toView:self.view];
    if ([self.delegate respondsToSelector:@selector(stickerDidSelected:andPageIndex:withFrame:)]) {
        [self.delegate stickerDidSelected:indexPath andPageIndex:self.stickerPage.pageIndex withFrame:rect];
    }
    if (_recordSticker) {
        if (_recentPage) {
            [_recentStickerHelper addSticker:[_recentStickerHelper getContents][indexPath.row]];
        }else {
            SectionModel *section = self.stickerPage.sections[indexPath.section];
            StickerModel *sticker = section.stickers[indexPath.row];
            [_recentStickerHelper addSticker:sticker.stickerName];
        }
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        if (finished) {
            cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        if (finished) {
            cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    }];
}


#pragma mark - UICollectionViewDataSource

- (StickerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    SectionModel *section = self.stickerPage.sections[indexPath.section];
    StickerModel *sticker = section.stickers[indexPath.row];
    switch (self.stickerPage.stickerType) {
        case StickerTypeEmoji: {
            if (!_recentPage) {
                [cell setTextForLabel:sticker.stickerName];
            }else {
                [cell setTextForLabel:[_recentStickerHelper getContents][indexPath.row]];
            }
            break;
        }
        case StickerTypeSingle:
        case StickerTypeAssembled: {
            if (!_recentPage) {
                NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:_bundleName withExtension:@"bundle"]];
                NSString *imagePath = [bundle pathForResource:sticker.stickerName ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                [cell setImageForImageView:image];
            }else {
                NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:_bundleName withExtension:@"bundle"]];
                NSString *imagePath = [bundle pathForResource:[_recentStickerHelper getContents][indexPath.row] ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                [cell setImageForImageView:image];
            }
            break;
        }
        default:
            break;
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    SectionModel *section = self.stickerPage.sections[indexPath.section];
    UICollectionReusableView *reuseView;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        for (UIView *subview in reuseView.subviews) {
            [subview removeFromSuperview];
        }
        UILabel *headerLabel = [[UILabel alloc] init];
        headerLabel.text = section.headerName;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [reuseView addSubview:headerLabel];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(reuseView);
        }];
        
    }else {
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerReuseIdentifier forIndexPath:indexPath];
        for (UIView *subview in reuseView.subviews) {
            [subview removeFromSuperview];
        }
        UILabel *footerLabel = [[UILabel alloc] init];
        footerLabel.text = section.footerName;
        footerLabel.textColor = [UIColor whiteColor];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [reuseView addSubview:footerLabel];
        [footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(reuseView);
        }];
    }
    return reuseView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
        return self.stickerPage.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!_recentPage) {
        SectionModel *sectionModel = self.stickerPage.sections[section];
        return sectionModel.stickers.count;
    }else {
        return [_recentStickerHelper getContents].count;
    }
    
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellWidth, cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    SectionModel *sectionModel = self.stickerPage.sections[section];
    if (sectionModel.headerName == nil || [sectionModel.headerName isEqualToString:@""] || self.stickerPage.sections.count == 1) {
        return CGSizeZero;
    }
    CGFloat width = screenWidth - 31;
    CGFloat height = width / 344.5 * 31.7;
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    SectionModel *sectionModel = self.stickerPage.sections[section];
    if (sectionModel.footerName == nil || [sectionModel.footerName isEqualToString:@""] || self.stickerPage.sections.count == 1) {
        return CGSizeZero;
    }
    CGFloat width = screenWidth - 31;
    CGFloat height = width / 344.5 * 31.7;
    return CGSizeMake(width, height);
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 118, screenWidth - 30, screenHeight - 162) collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[StickerCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseIdentifier];
    }
    return _collectionView;
}


@end
