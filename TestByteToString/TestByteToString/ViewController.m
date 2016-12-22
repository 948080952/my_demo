//
//  ViewController.m
//  TestByteToString
//
//  Created by Dai Pei on 2016/11/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"

#import "NSString+DPExtension.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    int a = 11;
    NSLog(@"%04x", a);
}

- (NSString *)packString:(NSString *)string {
    NSMutableString *packedStr = [NSMutableString stringWithString:[NSString randomHexstringWithLength:5]];
    [packedStr appendString:[string substringToIndex:1]];
    [packedStr appendString:[NSString randomHexstringWithLength:5]];
    [packedStr appendString:[string substringFromIndex:1]];
    NSLog(@"first pack:%@", packedStr);
    NSData *tmp = [packedStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [tmp base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"base64:%@", base64Str);
    packedStr = [NSMutableString stringWithString:[NSString randomUpperLetterStringWithLength:1]];
    [packedStr appendString:[base64Str substringToIndex:1]];
    [packedStr appendString:[NSString randomUpperLetterStringWithLength:1]];
    [packedStr appendString:[base64Str substringWithRange:NSMakeRange(1, 3)]];
    [packedStr appendString:[NSString randomUpperLetterStringWithLength:2]];
    [packedStr appendString:[base64Str substringFromIndex:4]];
    NSLog(@"second pack:%@", packedStr);
    return [packedStr copy];
}

- (NSString *)unpackString:(NSString *)string {
    NSMutableString *unpackString = [NSMutableString stringWithString:[string substringWithRange:NSMakeRange(1, 1)]];
    [unpackString appendString:[string substringWithRange:NSMakeRange(3, 3)]];
    [unpackString appendString:[string substringFromIndex:8]];
    NSLog(@"first unpack:%@", unpackString);
    NSData *tmp = [[NSData alloc]initWithBase64EncodedString:unpackString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *normalStr = [[NSString alloc] initWithData:tmp encoding:NSUTF8StringEncoding];
    unpackString = [NSMutableString stringWithString:[normalStr substringWithRange:NSMakeRange(5, 1)]];
    [unpackString appendString:[normalStr substringFromIndex:11]];
    NSLog(@"second unpack:%@", unpackString);
    return [unpackString copy];
}

- (void)testWithChar {
    char *a = malloc(sizeof(char));
    memset(a, 0, sizeof(char));
    for (int i = 0; i < 10; i++) {
        NSLog(@"before transform:%d %u %c", *a, *a, *a);
        NSString *tmp = [[NSString alloc] initWithBytes:a length:sizeof(char) encoding:NSASCIIStringEncoding];
        NSLog(@"the str is:%@ %lu", tmp, sizeof(char));
        memset(a, 0, sizeof(char));
        NSUInteger used;
        [tmp getBytes:a maxLength:sizeof(char) usedLength:&used encoding:NSASCIIStringEncoding options:0 range:NSMakeRange(0, tmp.length) remainingRange:NULL];
        NSLog(@"after transform:%d %u %c", *a, *a, *a);
        *a = 1 << i;
    }
}

- (void)testWithInt {
    int32_t *a = malloc(sizeof(int32_t) * 2);
    memset(a, 0, sizeof(int32_t) * 2);
    for (int i = 0; i < 33; i++) {
        NSLog(@"before transform:%d %u %c", *a, *a, *a);
        NSString *tmp = [[NSString alloc] initWithBytes:a length:sizeof(int32_t) * 2 encoding:NSASCIIStringEncoding];
        memset(a, 0, sizeof(int32_t) * 2);
        NSLog(@"the str is:%@", tmp);
        NSUInteger used;
        [tmp getBytes:a maxLength:sizeof(int32_t) * 2 usedLength:&used encoding:NSASCIIStringEncoding options:0 range:NSMakeRange(0, tmp.length) remainingRange:NULL];
        NSLog(@"after transform:%d %u %c", *a, *a, *a);
        *a = 1 << i;
    }
}

- (void)testHexString {
    int32_t *a = malloc(sizeof(int32_t));
    memset(a, 0, sizeof(int32_t));
    for (int i = 0; i < 32; i++) {
        *a += 1 << i;
        NSLog(@"before:%u %d", *a, *a);
//        char *dataBuffer = (char *)a;
//        NSMutableString *hexString = [NSMutableString stringWithCapacity:2 * sizeof(int32_t)];
//        for (int i = 0; i < sizeof(int32_t); i++) {
//            [hexString appendFormat:@"%02x", (unsigned char)dataBuffer[i]];
//        }
        NSData *data1 = [NSData dataWithBytes:a length:sizeof(int32_t)];
        NSString *hexString = [NSString hexStringWithData:data1];
        NSLog(@"map str:%@", hexString);
        NSData *data = [NSString dataWithHexString:hexString];
        int32_t *b = malloc(sizeof(int32_t));
        [data getBytes:b range:NSMakeRange(0, sizeof(int32_t))];
        NSLog(@"after:%u %d", *b, *b);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
