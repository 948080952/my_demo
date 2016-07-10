//
//  DPToastHolder.m
//  DPToastDemo
//
//  Created by Dai Pei on 16/4/10.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPToastHolder.h"
#import "DPToastModel.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

static const CGFloat DPToastOpacity = 0.8;
static const CGFloat DPToastStartAlpha = 0.0;
static const CGFloat DPToastCornerRadius = 10;
static const CGFloat DPToastMaxMessageLines = 0;
static const CGFloat DPToastFontSize = 16.0;

//loadingToast
static const CGFloat DPLoadingToastViewWidth = 100;
static const CGFloat DPLoadingToastViewHeight = 100;

static const NSTimeInterval DPToastDefaultDuration;


@interface DPToastHolder ()

@property (nonatomic, strong)DPToastModel *mainModel;
@property (nonatomic, strong)DPToastModel *secondModel;
@property (nonatomic, strong)UIView *loadingToastView;
@property (nonatomic, strong)UILabel *messageToastView;

@end

@implementation DPToastHolder

#pragma mark - Public Method

- (instancetype)initWithDPToastModel:(DPToastModel *)model {
    self = [super init];
    if (self) {
        self.mainModel = model;
    }
    return self;
}

- (void)addDPToastModel:(DPToastModel *)model {
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configToast];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ConfigViews

- (void)configToast {
    
}

#pragma mark - Privite Method

- (CGPoint)centerPointForPosition:(DPToastPosition)position withToast:(UIView *)toast {
//    CGFloat toastWidth = toast.frame.size.width;
//    CGFloat toastHeight = toast.frame.size.height;
    switch (position) {
        case DPToastPositionLoadingTop:
            return CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
            break;
        case DPToastPositionLoadingCenter:
            return CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
            break;
        case DPToastPositionLoadingBottom:
            return CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
            break;
        case DPToastPositionLoadingDefault:
            return CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
            break;
        case DPToastPositionMessageTop:
            return CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
            break;
        case DPToastPositionMessageCenter:
            return CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
            break;
        case DPToastPositionMessageBottom:
            return CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
            break;
        case DPToastPositionMessageDefault:
            return CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
            break;
        default:
            NSLog(@"never reach here!");
            break;
    }
    return CGPointZero;
}

- (CGSize)sizeForSrting:(NSString *)string font:(UIFont *)font {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        CGRect boundingRect = [string boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:CGSizeMake(300, 0) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
}

#pragma mark - Getters

- (UIView *)loadingToastView {
    if (_loadingToastView) {
        _loadingToastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DPLoadingToastViewWidth, DPLoadingToastViewHeight)];
        _loadingToastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:DPToastOpacity];
        _loadingToastView.center = [self centerPointForPosition:self.mainModel.position withToast:_loadingToastView];
        _loadingToastView.alpha = DPToastStartAlpha;
        _loadingToastView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
        _loadingToastView.layer.masksToBounds = YES;
        _loadingToastView.layer.cornerRadius = DPToastCornerRadius;
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicatorView.center = CGPointMake(DPLoadingToastViewWidth / 2, DPLoadingToastViewHeight / 2);
        [_loadingToastView addSubview:activityIndicatorView];
    }
    return _loadingToastView;
}

- (UILabel *)messageToastView {
    if (_messageToastView) {
        _messageToastView = [[UILabel alloc] init];
        [_messageToastView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:DPToastOpacity]];
        _messageToastView.font = [UIFont systemFontOfSize:DPToastFontSize];
        _messageToastView.numberOfLines = DPToastMaxMessageLines;
        _messageToastView.textColor = [UIColor whiteColor];
        [_messageToastView.layer setCornerRadius:DPToastCornerRadius];
        _messageToastView.layer.masksToBounds = YES;
        _messageToastView.alpha = DPToastStartAlpha;
        _messageToastView.lineBreakMode = NSLineBreakByWordWrapping;
        _messageToastView.textAlignment = NSTextAlignmentCenter;
    }
    return _messageToastView;
}


@end
