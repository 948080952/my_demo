//
//  UIView+DaiPei.m
//  TestAssociatedObjects
//
//  Created by Dai Pei on 2016/9/9.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "UIView+DaiPei.h"
#import <objc/runtime.h>

@implementation UIView (DaiPei)
@dynamic originX;
@dynamic originY;

- (void)setOriginX:(id)originX {
    objc_setAssociatedObject(self, @selector(setOriginX:), originX, OBJC_ASSOCIATION_ASSIGN);
}

- (id)originX {
    return objc_getAssociatedObject(self, @selector(originX));
}

- (id)originY {
    return objc_getAssociatedObject(self, @selector(originY));
}


@end
