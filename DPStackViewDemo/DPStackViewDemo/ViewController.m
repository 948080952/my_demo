//
//  ViewController.m
//  DPStackViewDemo
//
//  Created by Dai Pei on 2016/8/1.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "DPStackLayout.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@property (nonatomic, strong) NSMutableArray *tmpArray;
@property (nonatomic, assign) NSInteger currentSession;
@property (nonatomic, assign) BOOL shouldTrasition;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL endDecelerating;
@property (nonatomic, assign) NSInteger accelerateCount;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) DPStackLayout *layout2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldTrasition = NO;
    self.currentSession = -1;
    self.endDecelerating = NO;
    self.tmpArray = [NSMutableArray arrayWithObjects:[UIColor grayColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor], [UIColor orangeColor], [UIColor redColor], [UIColor cyanColor], nil];
    self.navigationItem.leftBarButtonItem = self.barButtonItem;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.shouldTrasition = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.endDecelerating = YES;
    self.accelerateCount = 0;
}

#pragma mark - UICollectionViewDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return CGSizeMake(200, 400);
    }
    else if (indexPath.row == 3) {
        return CGSizeMake(150, 400);
    }
    else {
        return CGSizeMake(100, 400);
    }
//    return CGSizeMake(100, 400);
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"did select indexpath (%i, %i)", indexPath.section, indexPath.row);
//}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tmpArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.shouldTrasition) {
        if (indexPath.section == 2 && self.currentSession != 2) {
            [self addOneAtLast];
            self.currentSession = 1;
        }
        if (indexPath.section == 0 && self.currentSession != 0) {
            [self addOneAtFirst];
            self.currentSession = 1;
        }
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
    label.text = [NSString stringWithFormat:@"%li,%li", (long)indexPath.section, (long)indexPath.row];
    UIColor *color = [self.tmpArray objectAtIndex:indexPath.row];
    cell.backgroundColor = color;
    [cell.contentView addSubview:label];
    return cell;
}



#pragma mark - Privite Method

- (void)onTimer {
//    if (self.endDecelerating) {
//        self.accelerateCount += 2;
//        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
//            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + self.accelerateCount, self.collectionView.contentOffset.y) animated:NO];
//        } completion:nil];
//        if (self.accelerateCount >= 9) {
//            self.endDecelerating = NO;
//        }
//    }else {
//        
//    }
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction  animations:^{
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + 100, self.collectionView.contentOffset.y) animated:NO];
    } completion:nil];
    
}

- (void)addOneAtLast {
    NSLog(@"first to last");
    [UIView setAnimationsEnabled:NO];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveSection:0 toSection:2];
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x - self.layout.collectionViewContentSize.width / 3.0, self.collectionView.contentOffset.y);
    } completion:nil];
    [UIView setAnimationsEnabled:YES];
}

- (void)addOneAtFirst {
    NSLog(@"last to first");
    [UIView setAnimationsEnabled:NO];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveSection:2 toSection:0];
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + self.layout.collectionViewContentSize.width / 3.0, self.collectionView.contentOffset.y);
    } completion:nil];
    [UIView setAnimationsEnabled:YES];
}

- (void)barButtonClicked {
//    UIColor *tmp = [self.tmpArray objectAtIndex:self.tmpArray.count - 1];
//    [self.tmpArray removeObjectAtIndex:self.tmpArray.count - 1];
//    [self.tmpArray insertObject:tmp atIndex:0];
//    [UIView setAnimationsEnabled:NO];
//    [self.collectionView performBatchUpdates:^{
//        [self.collectionView moveSection:2 toSection:0];
//        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + 110 * 7, self.collectionView.contentOffset.y);
//    } completion:nil];
//    [UIView setAnimationsEnabled:YES];
//    [self.timer invalidate];
    [self.collectionView reloadData];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
//       self.layout2 = [[DPStackLayout alloc] init];
//        self.layout2.itemsCountInSection = 7;
//        self.layout2.minimumLineSpacing = 20;
//        self.layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.minimumLineSpacing = 10;
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UIBarButtonItem *)barButtonItem {
    if (!_barButtonItem) {
        _barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClicked)];
    }
    return _barButtonItem;
}

@end
