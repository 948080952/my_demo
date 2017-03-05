//
//  GiftSpinElementAnimationDelegate.h
//  TemplateSpinDemo
//
//  Created by Jerry Liu on 17/2/20.
//  Copyright © 2017年 beddup. All rights reserved.
//

#ifndef GiftSpinElementAnimationDelegate_h
#define GiftSpinElementAnimationDelegate_h


#endif /* GiftSpinElementAnimationDelegate_h */

#define kDefaultAnimationSpeed 1.0
#define kMinAnimationSpeed  0.9

@protocol GiftSpinElementAnimationDelegate <NSObject>

- (void)speedUp:(CGFloat)increment;

- (void)speedDown:(CGFloat)decrement;

//- (void)startAnimation;

@optional
- (void)setAbsoluteSpeed:(CGFloat)absoluteSpeed;

- (void)resetSpeed;

@end
