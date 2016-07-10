//
//  YuXinSDK.m
//  YuXinSDK
//
//  Created by Dai Pei on 16/6/24.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "YuXinSDK.h"
#import "iconv.h"

static NSString *URL_LOGIN                  = @"http://dian.hust.edu.cn:81/bbslogin";
static NSString *URL_LOGOUT                 = @"http://dian.hust.edu.cn:81/bbslogout";
static NSString *URL_SUBBOARD               = @"http://dian.hust.edu.cn:81/bbsboa";
static NSString *URL_FAVOURITES             = @"http://dian.hust.edu.cn:81/bbsbrd";
static NSString *URL_ADD_FAVOURITES_BOARD   = @"http://dian.hust.edu.cn:81/bbsbrdadd";
static NSString *URL_DEL_FAVOURITES_BOARD   = @"http://dian.hust.edu.cn:81/bbsbrddel";
static NSString *URL_Articles               = @"http://dian.hust.edu.cn:81/bbsnewtdoc";
static NSString *URL_Article                = @"http://dian.hust.edu.cn:81/bbsnewtcon";
static NSString *URL_Article_ONE            = @"http://dian.hust.edu.cn:81/bbscon";
static NSString *URL_POST_article           = @"http://dian.hust.edu.cn:81/bbssnd";
static NSString *URL_DEL_Article            = @"http://dian.hust.edu.cn:81/bbsdel";
static NSString *URL_USER_DETAIL            = @"http://dian.hust.edu.cn:81/bbsqry";
static NSString *URL_MAILS                  = @"http://dian.hust.edu.cn:81/bbsmail";
static NSString *URL_MAIL_DETAIL            = @"http://dian.hust.edu.cn:81/bbsmailcon";
static NSString *URL_POST_MAIL              = @"http://dian.hust.edu.cn:81/bbssndmail";
static NSString *URL_DEL_MAIL               = @"http://dian.hust.edu.cn:81/bbsdelmail";
static NSString *URL_NEW_MAIL               = @"http://dian.hust.edu.cn:81/bbsgetmsg";
static NSString *URL_FRIENDS                = @"http://dian.hust.edu.cn:81/bbsfall";
static NSString *URL_ADD_FRIEND             = @"http://dian.hust.edu.cn:81/bbsfadd";
static NSString *URL_DEL_FRIEND             = @"http://dian.hust.edu.cn:81/bbsfdel";
static NSString *URL_GET_BOARD_POST_POWER   = @"http://dian.hust.edu.cn:81/bbspst";
static NSString *URL_REPRINT                = @"http://dian.hust.edu.cn:81/bbsccc";

@interface YuXinSDK()

@property (nonatomic, strong) NSString *cookies;

@end

@implementation YuXinSDK

#pragma mark - Init

+ (instancetype)sharedInstance {
    static YuXinSDK *instance = nil;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        instance = [[YuXinSDK alloc] init];
        instance.shouldLog = YES;
    });
    return instance;
}

#pragma mark - Public Method

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(CompletionHandler)handler {
    
    NSString *bodyStr = [NSString stringWithFormat:@"xml=1&pw=%@&id=%@", password, username];
    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [self createRequestWithUrl:[URL_LOGIN copy] query:nil method:@"POST" cookie:nil body:bodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *loginTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeLogin parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:0 requestInfo:[NSString stringWithFormat:@"login"]];
                if (!error) {
                    YuXinLoginInfo *loginInfo = models[0];
                    weakSelf.cookies = [NSString stringWithFormat:@"utmpkey=%@;contdays=%@;utmpuserid=%@;utmpnum=%@;invisible=%@;version=1", loginInfo.utmpKey, loginInfo.contdays, loginInfo.utmpUserID, loginInfo.utmpNum, loginInfo.invisible];
                    handler(nil, [models copy]);
                }else {
                    handler(error, nil);
                }
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:0 requestInfo:@"login"];
            handler(error.localizedDescription, nil);
        }
    }];
    [loginTask resume];
}

- (void)logoutWithCompletion:(CompletionHandler)handler {
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_LOGOUT query:@"?xml=1" method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *logoutTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf makeLogWithError:error.localizedDescription modelsCount:0 requestInfo:@"logout"];
        if (!error) {
            weakSelf.cookies = nil;
            handler(nil, nil);
        }else {
            handler(error.localizedDescription, nil);
        }
    }];
    [logoutTask resume];
}

- (void)fetchFavourateBoardWithCompletion:(CompletionHandler)handler {
    NSString *queryStr = @"?xml=1";
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_FAVOURITES query:queryStr method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *fetchTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeFavourites parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                
                [weakSelf makeLogWithError:error modelsCount:[models count] requestInfo:@"favourate board"];
                handler(error, [models copy]);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:1 requestInfo:@"favourate board"];
            handler(error.localizedDescription, nil);
        }
    }];
    [fetchTask resume];
    
}

- (void)queryUserInfoWithUserID:(NSString *)userID completion:(CompletionHandler)handler {
    NSString *queryStr = [NSString stringWithFormat:@"?userid=%@&xml=1", userID];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_USER_DETAIL query:queryStr method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *queryTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeUserDetail parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                
                [weakSelf makeLogWithError:error modelsCount:[models count] requestInfo:@"user info"];
                handler(error, [models copy]);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:1 requestInfo:@"user info"];
            handler(error.localizedDescription, nil);
        }
    }];
    [queryTask resume];
}

- (void)fetchFriendListWithCompletion:(CompletionHandler)handler {
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_FRIENDS query:@"?xml=1" method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *fetchTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeFriends parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:[models count] requestInfo:@"friends info"];
                handler(error, [models copy]);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:1 requestInfo:@"friend info"];
            handler(error.localizedDescription, nil);
        }
    }];
    [fetchTask resume];
}

- (void)fetchArticleTitleListWithBoard:(NSString *)boardName start:(NSNumber *)startNum completion:(CompletionHandler)handler {
    
    NSString *queryStr = [NSString stringWithFormat:@"?board=%@&xml=1&start=%@&summary=1", boardName, startNum];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_Articles query:queryStr method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *fetchTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeArticles parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:[models count] requestInfo:@"friends info"];
                handler(error, [models copy]);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:1 requestInfo:@"friends info"];
            handler(error.localizedDescription, nil);
        }
    }];
    
    [fetchTask resume];
}

- (void)fetchSubboard:(YuXinBoardType)boardType completion:(CompletionHandler)handler {
    NSString *queryStr = [NSString stringWithFormat:@"?%ld=1&xml=1", (long)boardType];
    
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_SUBBOARD query:queryStr method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *fetchTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeSubboard parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:[models count] requestInfo:@"subboard"];
                handler(error, [models copy]);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:1 requestInfo:@"subboard"];
            handler(error.localizedDescription, nil);
        }
    }];
    
    [fetchTask resume];
}

- (void)addFavourateBoard:(NSString *)boardName completion:(CompletionHandler)handler {
    NSString *queryStr = [NSString stringWithFormat:@"?board=%@&xml=1", boardName];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_ADD_FAVOURITES_BOARD query:queryStr method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *addTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeAddFavouritesBoard parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:0 requestInfo:[NSString stringWithFormat:@"add %@ board", boardName]];
                handler(error, models);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:0 requestInfo:[NSString stringWithFormat:@"add %@ board", boardName]];
            handler(error.localizedDescription, nil);
        }
    }];
    [addTask resume];
}

- (void)delFavourateBoard:(NSString *)boardName completion:(CompletionHandler)handler {
    NSString *queryStr = [NSString stringWithFormat:@"?board=%@&xml=1", boardName];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_DEL_FAVOURITES_BOARD query:queryStr method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *delTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf makeLogWithError:error.localizedDescription modelsCount:0 requestInfo:[NSString stringWithFormat:@"delete %@ board", boardName]];
        handler(error.localizedDescription, nil);
    }];
    [delTask resume];
}

- (void)fetchArticlesWithBoard:(NSString *)boardName file:(NSString *)fileName completion:(CompletionHandler)handler{
    NSString *queryStr = [NSString stringWithFormat:@"?board=%@&file=%@&xml=1", boardName, fileName];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_Article query:queryStr method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *fetchTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeArticle parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:[models count] requestInfo:@"articles"];
                handler(error, models);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:1 requestInfo:@"articles"];
            handler(error.localizedDescription, nil);
        }
    }];
    [fetchTask resume];
}

- (void)postArticleWithContent:(NSString *)content title:(NSString *)title board:(NSString *)boardName canReply:(BOOL)canReply userID:(NSString *)userID completion:(CompletionHandler)handler {
    NSString *bodyStr;
    bodyStr = [NSString stringWithFormat:@"text=%@&title=%@&xml=1&board=%@&signature=1&nore=%@&userid=%@&", content, title, boardName, canReply? @"off" : @"on", userID];
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *bodyData = [bodyStr dataUsingEncoding:gb2312];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_POST_article query:nil method:@"POST" cookie:self.cookies body:bodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *postTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypePostArticle parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:0 requestInfo:@"post a article"];
                handler(error, models);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:0 requestInfo:@"post a article"];
            handler(error.localizedDescription, nil);
        }
    }];
    [postTask resume];
}

- (void)commentArticle:(NSString *)articleName content:(NSString *)content board:(NSString *)boardName canReply:(BOOL)canReply file:(NSString *)fileName completion:(CompletionHandler)handler {
    NSString *bodyStr= [NSString stringWithFormat:@"text=%@&title=Re: %@&xml=1&board=%@&signature=1&nore=%@&file=%@&", content, articleName, boardName, canReply? @"off" : @"on", fileName];
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *bodyData = [bodyStr dataUsingEncoding:gb2312];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_POST_article query:nil method:@"POST" cookie:self.cookies body:bodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *commentTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypePostArticle parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:0 requestInfo:@"comment"];
                handler(error, models);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:0 requestInfo:@"comment"];
            handler(error.localizedDescription, nil);
        }
    }];
    [commentTask resume];
}

- (void)deleteArticleWithBoard:(NSString *)boardName file:(NSString *)fileName completion:(CompletionHandler)handler{
    NSString *queryStr = [NSString stringWithFormat:@"?board=%@&file=%@&xml=1", boardName, fileName];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_DEL_Article query:queryStr method:@"POST" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *deleteTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeDelArticle parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:0 requestInfo:@"delete article"];
                handler(error, models);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:0 requestInfo:@"delete article"];
            handler(error.localizedDescription, nil);
        }
    }];
    [deleteTask resume];
}

- (void)reprintArticleWithFile:(NSString *)fileName from:(NSString *)originBoard to:(NSString *)targetBoard completion:(CompletionHandler)handler {
    NSString *queryStr = [NSString stringWithFormat:@"?board=%@&file=%@&target=%@&xml=1", originBoard, fileName, targetBoard];
    NSMutableURLRequest *request = [self createRequestWithUrl:URL_REPRINT query:queryStr method:@"GET" cookie:self.cookies body:nil];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *reprintTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *convertedData = [weakSelf cleanGB2312:data];
            NSData *refinedData = [weakSelf refineTheData:convertedData];
            YuXinXmlParser *parser = [[YuXinXmlParser alloc] initWithParserType:YuXinXmlParserTypeDelArticle parserData:refinedData];
            [parser startParserWithCompletion:^(NSArray *models, NSString *error) {
                [weakSelf makeLogWithError:error modelsCount:0 requestInfo:@"reprint"];
                handler(error, models);
            }];
        }else {
            [weakSelf makeLogWithError:error.localizedDescription modelsCount:0 requestInfo:@"reprint"];
            handler(error.localizedDescription, nil);
        }
    }];
    [reprintTask resume];
}

#pragma mark - Privite Method

- (NSMutableURLRequest *)createRequestWithUrl:(NSString *)urlStr query:(NSString *)queryStr method:(NSString *)method cookie:(NSString *)cookie body:(NSData *)body {
    NSMutableString *completeUrlStr = [NSMutableString stringWithString:urlStr];
    if (queryStr) {
        [completeUrlStr appendString:queryStr];
    }
    NSURL *url = [NSURL URLWithString:completeUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    if (cookie) {
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    if (body) {
        [request setHTTPBody:body];
    }
    return request;
}

- (void)logTheResponse:(NSData *)data {
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *response = [[NSString alloc] initWithData:data encoding:gb2312];
    NSLog(@"[YuXinSDK]: response1: %@", response);
}

- (NSData *)refineTheData:(NSData *)data {
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *rawStr = [[NSString alloc] initWithData:data encoding:gb2312];
    NSString *targetStr1 = @"";
    NSString *replaceStr1 = @"";
    NSString *targetStr2 = @"gb2312";
    NSString *replaceStr2 = @"utf-8";
    NSString *refinedStr = [rawStr stringByReplacingOccurrencesOfString:targetStr1 withString:replaceStr1];
    refinedStr = [refinedStr stringByReplacingOccurrencesOfString:targetStr2 withString:replaceStr2];
    NSLog(@">>>>>>>>:%@", refinedStr);
    return [refinedStr dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)cleanGB2312:(NSData *)data {
    
    iconv_t cd = iconv_open("gb2312", "gb2312");
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one);
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}

- (void)makeLogWithError:(NSString *)error modelsCount:(NSInteger)count requestInfo:(NSString *)info {
    if (self.shouldLog) {
        if (!error) {
            if (count) {
                NSLog(@"[YuXinSDK]: success to get %zi %@", count, info);
            }else {
                NSLog(@"[YuXinSDK]: success to %@", info);
            }
        }else {
            if (count) {
                NSLog(@"[YuXinSDK]: fail to get %@ with error: %@", info, error);
            }else {
                NSLog(@"[YuXinSDK]: fail to %@ with error: %@", info, error);
            }
            
        }
    }
}

@end
