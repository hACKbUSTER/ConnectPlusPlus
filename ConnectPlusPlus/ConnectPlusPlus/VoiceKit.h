//
//  VoiceKit.h
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock)(id object);
typedef void (^volumeChangeBlock)(int volume);

@interface VoiceKit : NSObject

@property (nonatomic, strong) successBlock successBlock;
@property (nonatomic, strong) volumeChangeBlock volumeChangeBlock;

+ (VoiceKit *)sharedInstance;

- (void)startListening;
- (void)endListening;
- (void)cancelListening;


@end
