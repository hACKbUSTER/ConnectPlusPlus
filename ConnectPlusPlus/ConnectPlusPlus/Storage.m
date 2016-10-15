//
//  Storage.m
//  ConnectPlusPlus
//
//  Created by 杨思宇 on 10/15/16.
//  Copyright © 2016 hackbuster. All rights reserved.
//

#import "Storage.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation Storage

+ (NSDate *)lastDate
{
    static NSDate *value = nil;
    if (value == nil)
    {
        value = [NSDate date];
        return nil;
    }
    else
    {
        NSDate *rtn = [NSDate dateWithTimeInterval:0 sinceDate:value];
        value = [NSDate date];
        return rtn;
    }
}

+ (void)saveData:(NSString *)text withImage:(NSString *)image andLongtitude:(float)longtitude andLatitude:(float)latitude andTags:(NSString *)tags
{
    NSNumber *hasImage;
    
    if (text == nil)
    {
        hasImage = @(YES);
        text = @"";
    }
    else
    {
        hasImage = @(NO);
        image = @"";
    }
    
    AVObject *message = [AVObject objectWithClassName:@"Message"];
    [message setObject:hasImage forKey:@"hasImage"];
    [message setObject:text forKey:@"text"];
    [message setObject:image forKey:@"image"];
    [message setObject:[NSNumber numberWithFloat:longtitude] forKey:@"longtitude"];
    [message setObject:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    [message setObject:tags forKey:@"tags"];
    [message saveInBackground];
    NSLog(@"Save data successfully");
}

+ (void)saveImageMessage:(UIImage *)image withFilename:(NSString *)filename andLongtitude:(float)longtitude andLatitude:(float)latitude andTags:(NSArray *)tags
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    AVFile *file = [AVFile fileWithName:filename data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeed, NSError *error) {
        NSLog(@"save image successfully");
        NSString *serialized_tags = [Storage serializeTags:tags];
        [Storage saveData:nil withImage:file.url andLongtitude:longtitude andLatitude:latitude andTags:serialized_tags];
    }];
}

+ (void)saveTextMessage:(NSString *)text withLongtitude:(float)longtitude andLatitude:(float)latitude andTags:(NSArray *)tags
{
    NSString *serialized_tags = [Storage serializeTags:tags];
    [Storage saveData:text withImage:nil andLongtitude:longtitude andLatitude:latitude andTags:serialized_tags];
}

+ (NSString *)serializeTags:(NSArray *)tags
{
    NSString *rtn = @"";
    for (NSString *s in tags)
    {
        NSLog(@"%@", s);
        if ([rtn isEqualToString:@""])
        {
            rtn = [NSString stringWithFormat:@"%@", s];
        }
        else
        {
            rtn = [NSString stringWithFormat:@"%@;%@", rtn, s];
        }
    }
    return rtn;
}

+ (NSArray *)parseTags:(NSString *)serializedTags
{
    return [serializedTags componentsSeparatedByString:@";"];
}

+ (void)getMessages:(ResultBlock)callback
{
    AVQuery *query = [AVQuery queryWithClassName:@"Message"];
    //NSDate *lastDate = [Storage lastDate];
    //NSLog(@"yangsiyu-last-date: %@", lastDate);
    //if (lastDate != nil)
    //{
    //    [query whereKey:@"createdAt" greaterThan:lastDate];
    //}
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray<AVObject *> *res = objects;
        NSMutableArray *rtn = [[NSMutableArray alloc] init];
        NSLog(@"yangsiyu-from-server: %lu", (unsigned long)[res count]);
        for (AVObject *each in res) {
            NSNumber *hasImage = each[@"hasImage"];
            NSString *text = each[@"text"];
            NSString *image = each[@"image"];
            NSNumber *longtitude = each[@"longtitude"];
            NSNumber *latitude = each[@"latitude"];
            NSArray *tags = [Storage parseTags:each[@"tags"]];
            NSDictionary *dict = @{
                @"hasImage": hasImage,
                @"text": text,
                @"image": image,
                @"longtitude": longtitude,
                @"latitude": latitude,
                @"tags": tags
                };
            [rtn addObject:dict];

        }
        callback(rtn);
    }];
}

+ (void)getMessages:(NSDictionary *)lowerLeft withUpperRight:(NSDictionary *)upperRight andTags:(NSArray *)tags andCallback:(ResultBlock)callback
{
    [Storage getMessages:^(NSArray *messages) {
        NSMutableArray *rtn = [[NSMutableArray alloc] init];
        NSLog(@"yangsiyu-before-filter: %lu", (unsigned long)[messages count]);
        for (NSDictionary *message in messages)
        {
            if ([Storage isInRange:message withLowerLeft:lowerLeft andUpperRight:upperRight])
                if ([Storage isSubscribed:message withSubscribedTags:tags] > 0)
            {
                [rtn addObject:message];
            }
        }
        NSLog(@"yangsiyu-after-filter: %lu", (unsigned long)[rtn count]);
        callback(rtn);
    }];
}

+ (BOOL)isInRange:(NSDictionary *)message withLowerLeft:(NSDictionary *)lowerLeft andUpperRight:(NSDictionary *)upperRight
{
    if (message[@"longtitude"] >= lowerLeft[@"longtitude"] && message[@"latitude"] >= lowerLeft[@"latitude"] && message[@"longtitude"] <= upperRight[@"longtitude"] && message[@"latitude"] <= upperRight[@"latitude"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSInteger)isSubscribed:(NSDictionary *)message withSubscribedTags:(NSArray *)subscribedTags
{
    NSArray *tags = message[@"tags"];
    NSInteger rtn = 0;
    for (NSString *tag in tags) {
        for (NSString *subscribedTag in subscribedTags) {
            if ([tag isEqualToString:subscribedTag])
            {
                rtn++;
                break;
            }
        }
    }
    return rtn;
}

@end
