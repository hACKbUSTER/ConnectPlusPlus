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
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray<AVObject *> *res = objects;
        NSMutableArray *rtn = [[NSMutableArray alloc] init];
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

+ (void)getMessages:(NSDictionary *)lowerLeft withUpperRight:(NSDictionary *)upperRight andCallback:(ResultBlock)callback
{
    [Storage getMessages:^(NSArray *messages) {
        NSMutableArray *rtn = [[NSMutableArray alloc] init];
        for (NSDictionary *message in messages)
        {
            if (message[@"longtitude"] >= lowerLeft[@"longtitude"] && message[@"latitude"] >= lowerLeft[@"latitude"] && message[@"longtitude"] <= upperRight[@"longtitude"] && message[@"latitude"] <= upperRight[@"latitude"])
            {
                [rtn addObject:message];
            }
        }
        callback(rtn);
    }];
}

@end
