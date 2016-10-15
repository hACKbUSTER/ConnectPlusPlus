//
//  AVIMLocationMessage.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 1/12/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import "AVIMTypedMessage.h"

/**
 *  Location Message.
 */
@interface AVIMLocationMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>

/**
 *  Latitude. Should be 0~90.
 */
@property(nonatomic, readonly)float latitude;

/**
 *  Longitude, Should be 0~360.
 */
@property(nonatomic, readonly)float longitude;

/*!
 创建位置消息。
 @param text － 消息文本.
 @param latitude － 纬度
 @param longitude － 经度
 @param attributes － 用户附加属性
 */
+ (instancetype)messageWithText:(NSString *)text
                       latitude:(float)latitude
                      longitude:(float)longitude
                     attributes:(NSDictionary *)attributes;
@end
