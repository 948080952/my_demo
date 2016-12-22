//
//  SKScrollingNode.m
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "SKScrollingNode.h"

@implementation SKScrollingNode


+ (id) scrollingNodeWithImageNamed:(NSString *)name inContainerSize:(CGSize)size
{
    UIImage *image = [UIImage imageNamed:name];
    
    SKScrollingNode *realNode = [SKScrollingNode spriteNodeWithColor:[UIColor clearColor] size:size];
    realNode.scrollingSpeed = 1;
    
    CGFloat total = 0;
    CGFloat scaleRate = size.height / image.size.height;
    
    while(total<(size.width + image.size.width * scaleRate)){
        SKSpriteNode *child = [SKSpriteNode spriteNodeWithImageNamed:name];
        [child setScale:scaleRate];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0)];
        [realNode addChild:child];
        total+=child.size.width;
    }
    
    return realNode;
}


- (void) update:(NSTimeInterval)currentTime
{
    [self.children enumerateObjectsUsingBlock:^(SKNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SKSpriteNode *child = (SKSpriteNode *)obj;
        child.position = CGPointMake(child.position.x-self.scrollingSpeed, child.position.y);
        if (child.position.x <= -child.size.width){
            float delta = child.position.x+child.size.width;
            child.position = CGPointMake(child.size.width*(self.children.count-1)+delta, child.position.y);
        }
    }];
}

@end
