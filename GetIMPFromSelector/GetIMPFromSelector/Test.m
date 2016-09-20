//
//  Test.m
//  GetIMPFromSelector
//
//  Created by Dai Pei on 2016/9/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "Test.h"
#import <objc/runtime.h>

@implementation Test

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getIMPFromSelector:@selector(aaa)];
        [self getIMPFromSelector:@selector(test1)];
        [self getIMPFromSelector:@selector(test2)];
    }
    return self;
}

- (void)test1 {
    NSLog(@"test1");
}

+ (void)test2 {
    NSLog(@"test2");
}

- (void)getIMPFromSelector:(SEL)aSelector {
    
    // first method
    IMP instanceIMP1 = class_getMethodImplementation(objc_getClass("Test"), aSelector);
    IMP classIMP1 = class_getMethodImplementation(objc_getMetaClass("Test"), aSelector);
    
    // second method
    Method instanceMethod = class_getInstanceMethod(objc_getClass("Test"), aSelector);
    IMP instanceIMP2 = method_getImplementation(instanceMethod);
    
    Method classMethod1 = class_getClassMethod(objc_getClass("Test"), aSelector);
    IMP classIMP2 = method_getImplementation(classMethod1);
    
    Method classMethod2 = class_getClassMethod(objc_getMetaClass("Test"), aSelector);
    IMP classIMP3 = method_getImplementation(classMethod2);
    
    NSLog(@"instance1:%p instance2:%p class1:%p class2:%p class3:%p", instanceIMP1, instanceIMP2, classIMP1, classIMP2, classIMP3);
}

@end
