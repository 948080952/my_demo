//
//  SpaceshipScene.h
//  SpriteWalkthrough
//
//  Created by Dai Pei on 2016/9/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

@interface SpaceshipScene : SKScene

@end
