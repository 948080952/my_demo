//
//  DPAutoScrollView.m
//  DPAutoScrollView
//
//  Created by DaiPei on 2017/2/17.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

#import "DPAutoScrollView.h"

#define MaxScrollSpeed          3
#define MinScrollSpeed          0.5
#define DefaultScrollSpeed      1

#define kScrollAnimationKey     @"scroll"


@interface DPAutoScrollView () <CAAnimationDelegate>

@property (nonatomic, strong) UIImage *textureImage;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat reSpeed;
@property (nonatomic, assign) CGFloat absSpeed;
@property (nonatomic, assign) CGFloat animationToValue;
@property (nonatomic, assign) CGFloat scrolledLength;
@property (nonatomic, assign) BOOL scrolling;

@property (nonatomic, strong) UIView *textureHolder;
@property (nonatomic, strong) UIImageView *texture1;
@property (nonatomic, strong) UIImageView *texture2;

@end

@implementation DPAutoScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.reSpeed = DefaultScrollSpeed;
        self.height = 0;
        self.width = 0;
        self.scrolling = YES;
        self.layer.masksToBounds = YES;
        
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.textureHolder];
    [self.textureHolder addSubview:self.texture1];
    [self.textureHolder addSubview:self.texture2];
}

#pragma mark - Override

- (void)layoutSubviews {
    
    if (self.frame.size.width - self.width < 0.1 && self.frame.size.height - self.height < 0.1) {
        return ;
    }
    
    UIImage *tmp = self.textureImage;
    
    if (!tmp) {
        NSLog(@"[DPAutoScrollView] :you should set image before");
        return ;
    }
    
    CGFloat contentWidth = self.frame.size.width;
    CGFloat contentHeight = self.frame.size.height;
    CGFloat imageHeight = tmp.size.height;
    CGFloat imageWidth = tmp.size.width;
    CGFloat textureHeight = contentHeight;
    CGFloat textureWidth = textureHeight / imageHeight * imageWidth;
    
    self.width = contentWidth;
    self.height = contentHeight;
    
    self.scrolledLength = textureWidth;
    
    self.animationToValue = 0;
    
    self.texture1.image = self.textureImage;
    self.texture1.frame = CGRectMake(0, 0, textureWidth, textureHeight);
    self.texture2.image = self.textureImage;
    self.texture2.frame = CGRectMake(textureWidth, 0, textureWidth, textureHeight);
    self.textureHolder.frame = CGRectMake(0, 0, textureWidth * 2, textureHeight);
    
    [self startGroupAnimation];
}

#pragma mark - GiftSpinElementAnimationDelegate

- (void)speedUp:(CGFloat)increment {
    [self changeSpeed:increment];
}

- (void)speedDown:(CGFloat)decrement {
    [self changeSpeed:-decrement];
}

- (void)setAbsoluteSpeed:(CGFloat)absoluteSpeed {
    _absSpeed = absoluteSpeed;
}

- (void)resetSpeed {
    _reSpeed = DefaultScrollSpeed;
}

#pragma mark - Public Method

- (void)setImage:(UIImage *)image {
    _textureImage = image;
}


- (void)startScroll {
    if (!self.scrolling) {
        [self startGroupAnimation];
        self.scrolling = YES;
    }
}

- (void)stopScroll {
    if (self.scrolling) {
        self.textureHolder.center = CGPointMake(self.textureHolder.layer.presentationLayer.position.x, self.textureHolder.center.y);
        [self.textureHolder.layer removeAllAnimations];
        self.textureHolder.layer.position = self.textureHolder.layer.presentationLayer.position;
        self.scrolling = NO;
    }
}

- (void)setIntialSpeed:(CGFloat)intialSpeed {
    _absSpeed = intialSpeed;
}

- (void)changeSpeed:(CGFloat)relativeSpeed {
    if (self.scrolling) {
        self.reSpeed += relativeSpeed;
        if (self.reSpeed <= MinScrollSpeed) {
            self.reSpeed = MinScrollSpeed;
        }
        [self startGroupAnimation];
    }
}

- (void)resetSpeed:(CGFloat)speed {
    self.reSpeed = speed;
    if (self.reSpeed <= MinScrollSpeed) {
        self.reSpeed = MinScrollSpeed;
    }
    [self startGroupAnimation];
}


#pragma mark - Private Method

- (void)startGroupAnimation {
    
    CGFloat linkValue = self.textureHolder.layer.position.x;
    
    if ([self.textureHolder.layer animationForKey:kScrollAnimationKey]) {
        
        linkValue = self.textureHolder.layer.presentationLayer.position.x;
        
    }
    
    CGFloat speed = self.absSpeed;
    
    speed *= self.reSpeed;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    
    CABasicAnimation *toLeftBounds = [CABasicAnimation animation];
    toLeftBounds.keyPath = @"position.x";
    toLeftBounds.fromValue = @(linkValue);
    toLeftBounds.toValue = @(0);
    toLeftBounds.duration = (linkValue) / speed;
    toLeftBounds.fillMode = kCAFillModeForwards;
    toLeftBounds.removedOnCompletion = NO;
    
    
    CABasicAnimation *fromRightBounds = [CABasicAnimation animation];
    fromRightBounds.keyPath = @"position.x";
    fromRightBounds.fromValue = @(self.textureHolder.layer.frame.size.width / 2);
    fromRightBounds.toValue = @(linkValue);
    fromRightBounds.duration = (self.textureHolder.layer.frame.size.width / 2 - linkValue) / speed;
    fromRightBounds.fillMode = kCAFillModeForwards;
    fromRightBounds.removedOnCompletion = NO;
    fromRightBounds.beginTime = toLeftBounds.duration;
    
    groupAnimation.animations = @[toLeftBounds, fromRightBounds];
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.duration = toLeftBounds.duration + fromRightBounds.duration;
    
    [self.textureHolder.layer addAnimation:groupAnimation forKey:kScrollAnimationKey];
    
}

#pragma - mark Getter

- (UIView *)textureHolder {
    if (!_textureHolder) {
        _textureHolder = [[UIView alloc] init];
    }
    return _textureHolder;
}

- (UIImageView *)texture1 {
    if (!_texture1) {
        _texture1 = [[UIImageView alloc] init];
        _texture1.contentMode = UIViewContentModeScaleToFill;
        _texture1.layer.borderWidth = 2;
        _texture1.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return _texture1;
}

- (UIImageView *)texture2 {
    if (!_texture2) {
        _texture2 = [[UIImageView alloc] init];
        _texture2.contentMode = UIViewContentModeScaleToFill;
        _texture2.layer.borderWidth = 2;
        _texture2.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _texture2;
}


@end
