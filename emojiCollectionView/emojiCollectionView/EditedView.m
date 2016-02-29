//
//  EditedView.m
//  emojiCollectionView
//
//  Created by Dai Pei on 16/2/18.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "EditedView.h"



@implementation EditedView {
    UILabel *_emojiLabel;
    UIButton *_deleteButton;

    UIView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialScale;
    CGFloat _initialArg;
}



+ (void)setActiveEditedView:(EditedView *)view {
    
    static EditedView *activeView = nil;
    
    if (view != activeView) {
        [activeView setActive:NO];
        activeView = view;
        [activeView setActive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

#pragma mark - Init

- (instancetype)initWithEmojiUILabel:(UILabel *)label {
    
    self = [super initWithFrame:CGRectMake(label.frame.origin.x - 16,
                                           label.frame.origin.y - 16,
                                           label.frame.size.width + 32,
                                           label.frame.size.height + 32)];
    
    if (self) {
        _emojiLabel = label;
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        _emojiLabel.frame = CGRectMake(16,
                                       16,
                                       label.frame.size.width,
                                       label.frame.size.height);
        _emojiLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        _emojiLabel.layer.cornerRadius = 3;
        [self addSubview:_emojiLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"Image_btn_delete"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _emojiLabel.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _circleView.center = CGPointMake(_emojiLabel.frame.size.width + _emojiLabel.frame.origin.x,
                                          _emojiLabel.frame.size.height + _emojiLabel.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.layer.cornerRadius = 12;
        _circleView.layer.masksToBounds = YES;
        _circleView.layer.borderWidth = 5;
        _circleView.layer.borderColor = [UIColor blackColor].CGColor;
        _circleView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_circleView];
        
        _scale = 1;
        _arg = 0;
        
        
        [self initGesures];
    }
    
    return self;
}

#pragma mark - Action Method

- (void)initGesures {
    _emojiLabel.userInteractionEnabled = YES;
    
    [_emojiLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_emojiLabel addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
    
}

- (void)viewDidTap:(UITapGestureRecognizer *)sender {
    
    [[self class] setActiveEditedView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer *)sender {
    
    [[self class] setActiveEditedView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _initialPoint = self.center;
    }
    
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint point1 = [sender translationInView:self.superview];
    
    static CGFloat tmpScale = 1;
    static CGFloat tmpArg = 0;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];

        CGPoint point2 = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        
        tmpScale = sqrt(point2.x * point2.x + point2.y * point2.y);
        tmpArg = atan2(point2.y, point2.x);
        
        _initialScale = _scale;
        _initialArg = _arg;
    }
    
    point1 = CGPointMake(_initialPoint.x + point1.x - self.center.x, _initialPoint.y + point1.y - self.center.y);
    
    CGFloat Scale = sqrt(point1.x * point1.x + point1.y * point1.y);
    CGFloat Arg = atan2(point1.y, point1.x);
    
    _arg = _initialArg + Arg - tmpArg;
    [self setScale:MAX(_initialScale * Scale / tmpScale, 0.5)];
    
}

- (void)setScale:(CGFloat)scale {
    
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _emojiLabel.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rect = self.frame;
    rect.origin.x += (rect.size.width - (_emojiLabel.frame.size.width + 32)) / 2;
    rect.origin.y += (rect.size.height - (_emojiLabel.frame.size.height + 32)) / 2;
    rect.size.width = _emojiLabel.frame.size.width + 32;
    rect.size.height = _emojiLabel.frame.size.height + 32;
    self.frame = rect;
    
    _emojiLabel.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _emojiLabel.layer.borderWidth = 1 / _scale;
    _emojiLabel.layer.cornerRadius = 3 / _scale;
    
}

- (void)setActive:(BOOL)active {
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    _emojiLabel.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (void)pushDeleteBtn:(id)sender{
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
