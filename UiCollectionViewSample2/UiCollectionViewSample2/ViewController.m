//
//  ViewController.m
//  UiCollectionViewSample2
//
//  Created by Dai Pei on 16/2/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"

#define collectionCell 5
#define screenHeight [[UIScreen mainScreen] bounds].size.height
#define screenWidth [[UIScreen mainScreen] bounds].size.width

@interface ViewController (){
    UICollectionView *myCollectionView;
    NSMutableArray *hArr;
    NSArray *emojis;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getJSONContent];
    hArr = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    myCollectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:flowLayout];
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:myCollectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
        emojis = [dataString componentsSeparatedByString:@","];
        for (int j = 0; j < [emojis count]; j++) {
            NSLog(@"%@", emojis[j]);
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return [emojis count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell *cell = [myCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 40, 40);
    label.text = emojis[indexPath.row];
    label.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30];
    label.textColor = [UIColor redColor];
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
//    NSInteger remainder = indexPath.row%collectionCell;
//    NSInteger currentRow = indexPath.row/collectionCell;
//    CGFloat currentHeight = [hArr[indexPath.row] floatValue];
//    
//    CGFloat positionX = (screenWidth/collectionCell - 8)*remainder + 5 * (remainder+1);
//    CGFloat positionY = (currentRow + 1)*5;
//    
//    for (NSInteger i = 0; i < currentRow; i++) {
//        NSInteger position = remainder + i*collectionCell;
//        positionY += [hArr[position] floatValue];
//    }
//    
//    cell.frame = CGRectMake(positionX, positionY, screenWidth/collectionCell - 8, currentHeight);
    
    [cell.contentView addSubview:label];
    
    return cell;
    
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 200;
    [hArr addObject:[NSString stringWithFormat:@"%f", height]];
    return CGSizeMake(screenWidth/collectionCell - 8, height);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[myCollectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}


@end
