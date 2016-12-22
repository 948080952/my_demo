//
//  NSString+DPExtension.m
//  TestByteToString
//
//  Created by Dai Pei on 2016/11/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "NSString+DPExtension.h"

@implementation NSString(HexString)

+ (NSData *)dataWithHexString:(NSString *)hexString {
    const char *chars = [hexString UTF8String];
    int i = 0;
    NSUInteger len = hexString.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

+ (NSString *)hexStringWithData:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", (unsigned char)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

@end

@implementation NSString (DPRandomString)

+ (NSString *)randomStringWithLength:(NSUInteger)length {
    NSMutableString *randomString = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        NSUInteger random = arc4random() % 95 + 32;
        [randomString appendFormat:@"%c", (char)random];
    }
    
    return [randomString copy];
}

+(NSString *)randomUpperLetterStringWithLength:(NSUInteger)length {
    NSMutableString *randomString = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        NSUInteger random = arc4random() % 26 + 65;
        [randomString appendFormat:@"%c", (char)random];
    }
    
    return [randomString copy];
}

+ (NSString *)randomLowerLetterStringWithLength:(NSUInteger)length {
    NSMutableString *randomString = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        NSUInteger random = arc4random() % 26 + 97;
        [randomString appendFormat:@"%c", (char)random];
    }
    
    return [randomString copy];
}

+ (NSString *)randomHexstringWithLength:(NSUInteger)length {
    NSMutableString *randomString = [NSMutableString string];
    NSUInteger length2 = (length >> 1) + 1;
    for (int i = 0; i < length2; i++) {
        char random = 1 << (arc4random() % 8);
        [randomString appendFormat:@"%02x", random];
    }
    
    return [randomString substringWithRange:NSMakeRange(0, length)];
}

@end
