//
//  DPToast.m
//  DPToastDemo
//
//  Created by Dai Pei on 16/4/10.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPToast.h"
#import <UIKit/UIKit.h>
#import "DPToastHolder.h"
#import "DPToastModel.h"

static const CGFloat DPToastDefaultTimeInterval = 2.00f;

@interface DPToast ()

@end

@implementation DPToast

#pragma mark - Action Method

+ (void)makeLoadingToast {
    [self makeLoadingToast:DPLoadingToastPositionDefault withCompletion:nil];
}

+ (void)makeLoadingToastWithCompletion:(DPToastCompletion)completionHandler {
    [self makeLoadingToast:DPLoadingToastPositionDefault withCompletion:completionHandler];
}

+ (void)makeLoadingToast:(DPLoadingToastPosition)position withCompletion:(DPToastCompletion)completionHandler {
    
    DPToastModel *model = [[DPToastModel alloc] init];
    model.toastType = DPToastTypeLoading;
    switch (position) {
        case DPLoadingToastPositionTop:
            model.position = DPToastPositionLoadingTop;
            break;
        case DPLoadingToastPositionBottom:
            model.position = DPToastPositionLoadingBottom;
            break;
        case DPLoadingToastPositionCenter:
            model.position = DPToastPositionLoadingCenter;
            break;
        case DPLoadingToastPositionDefault:
            model.position = DPToastPositionLoadingDefault;
            break;
        default:
            break;
    }
    UIViewController *topestVC = [self getTopMostViewController];
    if ([topestVC class] == [DPToastHolder class]) {
        DPToastHolder *holder = (DPToastHolder *)topestVC;
        [holder addDPToastModel:model];
        return ;
    }
    DPToastHolder *holder = [[DPToastHolder alloc] initWithDPToastModel:model];
    [topestVC presentViewController:holder animated:NO completion:^{
        completionHandler();
    }];
}

+ (void)hideLoadingToast {
    UIViewController *topestVC = [self getTopMostViewController];
    if ([topestVC class] != [DPToastHolder class]) {
        return ;
    }
    [topestVC dismissViewControllerAnimated:NO completion:nil];
}

+ (void)makeMessageToast:(NSString *)message {
    [self makeMessageToast:message position:DPMessageToastPositionDefault duration:DPToastDefaultTimeInterval withCompletion:nil];
}

+ (void)makeMessageToast:(NSString *)message withCompletion:(DPToastCompletion)completionHandler {
    [self makeMessageToast:message position:DPMessageToastPositionDefault duration:DPToastDefaultTimeInterval withCompletion:completionHandler];
}

+ (void)makeMessageToast:(NSString *)message position:(DPMessageToastPosition)position withCompletion:(DPToastCompletion)completionHandler {
    [self makeMessageToast:message position:position duration:DPToastDefaultTimeInterval withCompletion:completionHandler];
}

+ (void)makeMessageToast:(NSString *)message duration:(NSTimeInterval)interval withCompletion:(DPToastCompletion)completionHandler {
    [self makeMessageToast:message position:DPMessageToastPositionDefault duration:interval withCompletion:completionHandler];
}

+ (void)makeMessageToast:(NSString *)message position:(DPMessageToastPosition)position duration:(NSTimeInterval)interval withCompletion:(DPToastCompletion)completionHandler {
    DPToastModel *model = [[DPToastModel alloc] init];
    model.message = message;
    model.interval = interval;
    model.toastType = DPToastTypeMessage;
    switch (position) {
        case DPMessageToastPositionTop:
            model.position = DPToastPositionMessageTop;
            break;
        case DPMessageToastPositionBottom:
            model.position = DPToastPositionLoadingBottom;
            break;
        case DPMessageToastPositionCenter:
            model.position = DPToastPositionMessageCenter;
            break;
        case DPMessageToastPositionDefault:
            model.position = DPToastPositionMessageDefault;
            break;
        default:
            break;
    }
    UIViewController *topestVC = [self getTopMostViewController];
    if ([topestVC class] == [DPToastHolder class]) {
        DPToastHolder *holder = (DPToastHolder *)topestVC;
        [holder addDPToastModel:model];
        return ;
    }
    DPToastHolder *holder = [[DPToastHolder alloc] initWithDPToastModel:model];
    [topestVC presentViewController:holder animated:NO completion:^{
        completionHandler();
    }];
}

#pragma mark - Privite Method

+ (UIViewController *)getTopMostViewController {
    
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    BOOL isPresenting = NO;
    do {
        UIViewController *presented = [rootController presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            rootController = presented;
        }
    } while (isPresenting);
    
    return rootController;
}

@end
