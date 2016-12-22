//
//  NSString+DPExtension.h
//  TestByteToString
//
//  Created by Dai Pei on 2016/11/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(HexString)

+ (NSData *)dataWithHexString:(NSString *)hexString;
+ (NSString *)hexStringWithData:(NSData *)data;

@end

@interface NSString (DPRandomString)

+ (NSString *)randomStringWithLength:(NSUInteger)length;
+ (NSString *)randomUpperLetterStringWithLength:(NSUInteger)length;
+ (NSString *)randomLowerLetterStringWithLength:(NSUInteger)length;
+ (NSString *)randomHexstringWithLength:(NSUInteger)length;

@end
