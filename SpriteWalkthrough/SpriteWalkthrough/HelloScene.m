//
//  HelloScene.m
//  SpriteWalkthrough
//
//  Created by Dai Pei on 2016/9/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "HelloScene.h"
#import "SpaceshipScene.h"

@implementation HelloScene

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    
    if (helloNode != nil) {
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX:0 y:100 duration:0.5];
        SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
        SKAction *pause = [SKAction waitForDuration:0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        [helloNode runAction:moveSequence completion:^{
            SpaceshipScene *spaceshipScene = [[SpaceshipScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:spaceshipScene transition:doors];
        }];
    }
}

- (void)createSceneContents {
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode =  SKSceneScaleModeAspectFit;
    [self addChild:[self newHelloNode]];
}

- (SKLabelNode *)newHelloNode {
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.name = @"helloNode";
    helloNode.text = @"Hello, World!";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    return helloNode;
}

@end
