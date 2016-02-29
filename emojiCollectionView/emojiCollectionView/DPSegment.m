//
//  DPSegment.m
//  emojiCollectionView
//
//  Created by Dai Pei on 16/2/21.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPSegment.h"

@interface DPSegment() {
    
    NSInteger _selectedIndex;
    
}




@end

@implementation DPSegment

- (instancetype)initWithSelectedIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _selectedIndex = index;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
