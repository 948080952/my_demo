//
//  emojiCollectionViewController.m
//  emojiCollectionView
//
//  Created by Dai Pei on 16/2/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "emojiCollectionViewController.h"
#import "RateForFit.h"

#define cellWidth 54*rateToFit
#define cellHeight 54*rateToFit
#define emojiSize 50*rateToFit


@interface emojiCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *emojisCategoryArray;
    NSArray *emojisArray;
    AddEmojiViewBlock _completionBlock;
    
}

@property (nonatomic, assign) EmojiCategoryType dataSourceType;
@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@end


@implementation emojiCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - Init

- (instancetype)initWithTypeSource:(EmojiCategoryType)type {
    self = [super init];
    if (self) {
        self.dataSourceType = type;
    }
    return self;
}

- (instancetype)initWithTypeSource:(EmojiCategoryType)type andBlock:(AddEmojiViewBlock) block {
    self = [super init];
    if (self) {
        self.dataSourceType = type;
        _completionBlock = block;
    }
    return self;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    emojisCategoryArray = [[NSMutableArray alloc] init];
    [self getJSONContent];
    [self.view setBackgroundColor:[UIColor clearColor]];
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]collectionViewLayout:_flowLayout];
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.myCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [emojisCategoryArray[self.dataSourceType] count];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    
    for (id subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *emojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, cellWidth, cellHeight)];
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.text = emojisCategoryArray[self.dataSourceType][indexPath.row];
    emojiLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:emojiSize];
    

    [cell.contentView addSubview:emojiLabel];
    
    
    return cell;
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(cellWidth, cellHeight);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 23.8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeScale(1.0, 1.0);

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSArray *cellSubViews = cell.contentView.subviews;
    UILabel *emojiLabel = (UILabel *)cellSubViews[0];
    
    [self dismissViewControllerAnimated:NO completion:^{


        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        CGRect rect = [collectionView convertRect:cell.frame toView:self.view];
        UILabel *newLabel = [[UILabel alloc] initWithFrame:rect];
        newLabel.text = emojiLabel.text;
        newLabel.font = emojiLabel.font;
        
        _completionBlock(newLabel);
    }];
    
}


#pragma mark - Privite Methods

- (void)getJSONContent {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category-Emoji" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
    NSArray *emojiCategoryArray = jsonDic[@"EmojiDataArray"];
    
    for (int i = 0; i < [emojiCategoryArray count]; i++) {
        NSDictionary *categoryDic = emojiCategoryArray[i];
        NSDictionary *categoryDataDic = categoryDic[@"CVCategoryData"];
        NSString *dataString = categoryDataDic[@"Data"];
        emojisArray = [dataString componentsSeparatedByString:@","];
        [emojisCategoryArray addObject:emojisArray];
        
    }
}

@end
