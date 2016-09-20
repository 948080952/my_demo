//
//  DPStackView.m
//  DPStackViewDemo
//
//  Created by Dai Pei on 2016/8/2.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPStackView.h"
#import "DPStackViewCell.h"

@interface DPStackView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGFloat itemTotalLenth;
@property (nonatomic, assign) NSInteger itemCountInSection;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL endDecelerate;
@property (nonatomic, assign) NSInteger accelerateCount;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) CGFloat sectionLenth;
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) BOOL shouldTrasition;
@property (nonatomic, assign) BOOL shouldReloadData;
@property (nonatomic, assign) BOOL longPress;

@end

@implementation DPStackView

- (instancetype)initWithBounds:(CGRect)bounds delegate:(id<DPStackViewDelegate>)delegate dataSource:(id<DPStackViewDataSource>)dataSource {
    self = [super init];
    if (self) {
        self.bounds = bounds;
        self.layer.masksToBounds = YES;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.shouldReloadData = NO;
        self.shouldTrasition = NO;
        self.delegate = delegate;
        self.dataSource = dataSource;
        self.itemTotalLenth = 0;
        [self setUp];
        [self initView];
        [self adjustCollectionViewOffset];
        [self scheduleTimer];
        [self addGesture];
    }
    return self;
}

#pragma mark - Public Method

- (void)registerCellClass:(Class)viewClass forCellWithReuseIdentifier:(NSString *)identifier {
    self.reuseIdentifier = identifier;
    [self.collectionView registerClass:viewClass forCellWithReuseIdentifier:identifier];
}

- (void)reloadData {
    self.shouldReloadData = YES;
}

- (void)finishSetup {
    self.shouldTrasition = YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.endDecelerate = YES;
//    self.accelerateCount = 0;
//    [self.timer invalidate];
//    [self onTimer];
//    [self scheduleTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"begin drag");
    CALayer *presentLayer = self.collectionView.layer.presentationLayer;
    [self.collectionView setContentOffset:CGPointMake(presentLayer.bounds.origin.x, self.collectionView.contentOffset.y) animated:NO];
    [self.collectionView.layer removeAllAnimations];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self.timer invalidate];
        [self onTimer];
        [self scheduleTimer];
    }
    NSLog(@"end drag");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > self.flowLayout.collectionViewContentSize.width / 2.0 - 50 && scrollView.contentOffset.x < self.flowLayout.collectionViewContentSize.width / 2.0 + 50) {
        if (self.shouldReloadData) {
            NSLog(@">>>>>>>>>reload Data");
            [self setUp];
            [self.collectionView reloadData];
            self.shouldReloadData = NO;
        }
    }
//    NSLog(@"offset x %f y %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
}

#pragma mark - UICollectionViewDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row % self.itemCount;
    CGSize size = [self.delegate stackView:self sizeForItemAtIndex:index];
    return CGSizeMake(size.width, self.bounds.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(stackView:didSelectAtIndex:)]) {
        NSInteger index = indexPath.row % self.itemCount;
        [self.delegate stackView:self didSelectAtIndex:index];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCountInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"indexPath: (%li, %li)", (long)indexPath.section, (long)indexPath.row);
    DPStackViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    if (self.shouldTrasition) {
        if (indexPath.section == 2 && self.currentSection != 2) {
            [self moveFirstToLast];
            self.currentSection = 1;
        }
        if (indexPath.section == 0 && self.currentSection != 0) {
            [self moveLastToFirst];
            self.currentSection = 1;
        }
    }
    NSInteger index = indexPath.row % self.itemCount;
    return [self.dataSource stackView:self cellForItemAtIndex:index withReusableCell:cell];
}

#pragma mark - Privite Method

- (void)addGesture {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    recognizer.delegate = self;
    recognizer.minimumPressDuration = 0.1;
    [self addGestureRecognizer:recognizer];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)recognizer {
    CALayer *presentLayer = self.collectionView.layer.presentationLayer;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
//            NSLog(@">>>>>>>>>begin");
//            [self pauseLayer:self.collectionView.layer];
            [self.timer invalidate];
            [self.collectionView setContentOffset:CGPointMake(presentLayer.bounds.origin.x, self.collectionView.contentOffset.y) animated:NO];
            [self.collectionView.layer removeAllAnimations];
            self.longPress = YES;
            break;
        case UIGestureRecognizerStateEnded:
//            NSLog(@">>>>>>>>>end");
            self.longPress = NO;
            [self onTimer];
            [self scheduleTimer];
//            [self.timer invalidate];
//            [self resumeLayer:self.collectionView.layer];
//            [self onTimer];
//            [self scheduleTimer];
            break;
        default:
            break;
    }
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)setUp {
    self.currentSection = 1;
    
    self.itemCount = [self.dataSource numberOfItemsInStackView:self];
    for (NSInteger i = 0; i < self.itemCount; i++) {
        self.itemTotalLenth += [self.delegate stackView:self sizeForItemAtIndex:i].width;
    }
    
    NSInteger rateOfSection = 2 * ceil(self.bounds.size.width / self.itemTotalLenth);
    self.itemCountInSection = self.itemCount * rateOfSection;
    self.sectionLenth = self.itemTotalLenth * rateOfSection;
}

- (void)initView {
    [self addSubview:self.collectionView];
}

- (void)moveFirstToLast {
    NSLog(@"first to last %f", self.flowLayout.collectionViewContentSize.width / 3.0);
    [UIView setAnimationsEnabled:NO];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveSection:0 toSection:2];
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x - self.flowLayout.collectionViewContentSize.width / 3.0, self.collectionView.contentOffset.y);
    } completion:nil];
    [UIView setAnimationsEnabled:YES];
}

- (void)moveLastToFirst {
//    NSLog(@"last to first");
    [UIView setAnimationsEnabled:NO];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveSection:2 toSection:0];
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + self.flowLayout.collectionViewContentSize.width / 3.0, self.collectionView.contentOffset.y);
    } completion:nil];
    [UIView setAnimationsEnabled:YES];
}

- (void)scheduleTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)onTimer {
    if (self.longPress) {
        return ;
    }
    if (self.endDecelerate) {
//        self.accelerateCount += 25;
//        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction  animations:^{
//            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + self.accelerateCount, self.collectionView.contentOffset.y) animated:NO];
//        } completion:nil];
//        if (self.accelerateCount >= 100) {
//            self.endDecelerate = NO;
//            self.accelerateCount = 0;
//        }
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + 100, self.collectionView.contentOffset.y) animated:NO];
        } completion:nil];
        self.endDecelerate = NO;
    }else {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction  animations:^{
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + 100, self.collectionView.contentOffset.y) animated:NO];
        } completion:nil];
    }
}

- (void)adjustCollectionViewOffset {
    NSInteger row = self.itemCountInSection / 2;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.minimumLineSpacing = 10;
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-200, 0, self.bounds.size.width + 400, self.bounds.size.height) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
