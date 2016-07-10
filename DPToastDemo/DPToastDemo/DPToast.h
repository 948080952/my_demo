//
//  DPToast.h
//  DPToastDemo
//
//  Created by Dai Pei on 16/4/10.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DPToastCompletion)(void);


typedef NS_ENUM(NSUInteger, DPLoadingToastPosition) {
    DPLoadingToastPositionDefault = 0,
    DPLoadingToastPositionTop,
    DPLoadingToastPositionCenter,
    DPLoadingToastPositionBottom
};


typedef NS_ENUM(NSUInteger, DPMessageToastPosition) {
    DPMessageToastPositionDefault = 0,
    DPMessageToastPositionTop,
    DPMessageToastPositionCenter,
    DPMessageToastPositionBottom
};

@interface DPToast : NSObject

/**第一个方法是执行异步操作前调用的
 * 第二和第三个方法是执行同步操作前调用的
 * 最后是隐藏Toast
 *  @param completionHandler 同步操作在这个回调中执行
 */
+ (void)makeLoadingToast;
+ (void)makeLoadingToastWithCompletion:(DPToastCompletion)completionHandler;
+ (void)makeLoadingToast:(DPLoadingToastPosition)position withCompletion:(DPToastCompletion)completionHandler;
+ (void)hideLoadingToast;


/**第一个方法是最简单的message toast 在它显示出来后如果不要执行耗时操作可以用它
 * 后面的方法是在执行同步操作前调用
 *
 *  @param message           你需要显示的提示信息
 *  @param completionHandler 同步操作在这个回调中执行
 */
+ (void)makeMessageToast:(NSString *)message;
+ (void)makeMessageToast:(NSString *)message withCompletion:(DPToastCompletion)completionHandler;
+ (void)makeMessageToast:(NSString *)message position:(DPMessageToastPosition)position withCompletion:(DPToastCompletion)completionHandler;
+ (void)makeMessageToast:(NSString *)message duration:(NSTimeInterval)interval withCompletion:(DPToastCompletion)completionHandler;
+ (void)makeMessageToast:(NSString *)message position:(DPMessageToastPosition)position duration:(NSTimeInterval)interval withCompletion:(DPToastCompletion)completionHandler;


@end
