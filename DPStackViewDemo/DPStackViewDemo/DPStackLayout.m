//
//  DPStackLayout.m
//  DPStackViewDemo
//
//  Created by Dai Pei on 2016/8/3.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPStackLayout.h"

@interface DPStackLayout ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation DPStackLayout

#pragma mark - Override

- (void)prepareLayout {
    [super prepareLayout];
    
//    self.cache = [NSCache new];
}

- (void)invalidateLayout {
    [super invalidateLayout];
//    self.cache = [NSCache new];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;
//    return [self layoutAttributesForElements:attributes];
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        NSLog(@"indexpath (%i, %i) x %f maxX %f", attr.indexPath.section, attr.indexPath.row, CGRectGetMinX(attr.frame), CGRectGetMaxX(attr.frame));
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [self attributesAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    return attr;
}

#pragma mark - Privite Method

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElements:(NSArray<UICollectionViewLayoutAttributes *> *)attributesArray {
    NSMutableArray<UICollectionViewLayoutAttributes *> *adjustedAttributesArray = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        if (attributes.representedElementKind != nil) {
            [adjustedAttributesArray addObject:attributes];
        }
        else {
            [adjustedAttributesArray addObject:[self attributes:attributes atIndexPath:attributes.indexPath]];
        }
    }
    return adjustedAttributesArray.copy;
}

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    return [self attributes:attributes atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)attributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath {
//    if ([self.cache objectForKey:indexPath]) {
//        return [self.cache objectForKey:indexPath];
//    }
//    
//    NSIndexPath *preIndexPath;
//    
//    if (indexPath.row != 0) {
//        NSInteger row = indexPath.row - 1;
//        preIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
//    }
//    else {
//        if (indexPath.section != 0) {
//            preIndexPath = [NSIndexPath indexPathForRow:self.itemsCountInSection - 1 inSection:indexPath.section - 1];
//        }else {
//            preIndexPath = nil;
//        }
//    }
//    if (preIndexPath) {
//        UICollectionViewLayoutAttributes *pre = [self.cache objectForKey:preIndexPath];
//        CGFloat x = pre.frame.origin.x + pre.frame.size.width;
//        CGRect frame = attributes.frame;
//        attributes.frame = CGRectMake(x + self.minimumLineSpacing, frame.origin.y, frame.size.width, frame.size.height);
////        NSLog(@"pre indexpath (%i, %i) originX %f maxX %f", preIndexPath.section, preIndexPath.row, CGRectGetMinX(pre.frame), CGRectGetMaxX(pre.frame));
////        NSLog(@"indexpath (%i, %i) originX %f maxX %f", indexPath.section, indexPath.row, CGRectGetMinX(attributes.frame), CGRectGetMaxX(attributes.frame));
//    }
//    [self.cache setObject:attributes forKey:indexPath];
    
    return attributes;
}

@end
