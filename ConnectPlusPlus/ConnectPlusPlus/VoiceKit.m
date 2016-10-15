//
//  VoiceKit.m
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "VoiceKit.h"
#import <iflyMSC/iflyMSC.h>

static const NSString* kIFlyAppId = @"58027389";

@interface VoiceKit() <IFlySpeechRecognizerDelegate>

@property (nonatomic, strong) IFlySpeechUnderstander *speechRecognizer;

@end

@implementation VoiceKit

+ (VoiceKit *)sharedInstance
{
    static VoiceKit *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[VoiceKit alloc] init];
    });
    
    return sInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
//        [self initService];
    }
    return self;
}

/**
 * 初始化服务
 **/
- (void)initService
{
    //设置讯飞appid
    NSString *appid = [NSString stringWithFormat:@"appid=%@",kIFlyAppId];
    [IFlySpeechUtility createUtility:appid];
    //讯飞代理
    _speechRecognizer = [IFlySpeechUnderstander sharedInstance];
    _speechRecognizer.delegate = self;
    //以下三个参数不设置会出现不能登录的错误
    [_speechRecognizer setParameter:@"iat" forKey:@"domain"];
    [_speechRecognizer setParameter:@"json" forKey:@"rst"];
    [_speechRecognizer setParameter:@"2.0" forKey:@"nlp_version"];
    [_speechRecognizer setParameter:[IFlySpeechConstant SAMPLE_RATE_8K] forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //去除标点符号
    [_speechRecognizer setParameter:@"0" forKey:@"asr_ptt"];
}

- (void)startListening
{
    [_speechRecognizer startListening];
}

- (void)endListening
{
    [_speechRecognizer stopListening];
}

- (void)cancelListening
{
    [_speechRecognizer cancel];
}

- (void) onError:(IFlySpeechError *) errorCode
{
    NSLog(@"Ifly error %d",errorCode.errorCode);
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSLog(@"fuck!%@",results);
    if ([results count] > 0) {
        NSString *jsonStr = ((NSDictionary *)results[0]).allKeys[0];
        
        NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *iFlyDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
        
        if (self.successBlock) {
            self.successBlock([iFlyDic objectForKey:@"text"]);
        }
    }
}

- (void) onVolumeChanged: (int)volume
{
    NSLog(@"fuck!%d",volume);
    if (self.volumeChangeBlock) {
        self.volumeChangeBlock(volume);
    }
}
@end
