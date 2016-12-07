//
//  FlickPhoto.m
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "FlickrPhoto.h"

@interface FlickrPhoto ()

@property (assign) NSUInteger farm;
@property (copy) NSString *server;
@property (copy) NSString *ID;
@property (copy) NSString *secret;

@end

@implementation FlickrPhoto
+ (NSArray *)photosFromJSONArray:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray new];
    for(NSDictionary *dictionary in array) {
        FlickrPhoto *photo = [FlickrPhoto newFromJSONDictionary:dictionary];
        if(photo == nil) {
            continue;
        }
        [result addObject:photo];
    }
    return result;
}

+ (instancetype)newFromJSONDictionary:(NSDictionary *)dictionary {
    NSString *ID = dictionary[@"id"];
    NSString *server = dictionary[@"server"];
    NSString *secret = dictionary[@"secret"];
    NSUInteger farm = [dictionary[@"farm"] integerValue];
    return [[self alloc] initWithID:ID farm:farm server:server secret:secret];
}

- (instancetype)initWithID:(NSString *)ID farm:(NSUInteger)farm server:(NSString *)server secret:(NSString *)secret {
    self = [super init];
    if(self) {
        self.ID = ID;
        self.farm = farm;
        self.server = server;
        self.secret = secret;
    }
    return self;
}

- (NSURL *)imageURL {
    NSString *stringURL = [NSString stringWithFormat:@"https://farm%lu.static.flickr.com/%@/%@_%@.jpg", self.farm, self.server, self.ID, self.secret];
    return [NSURL URLWithString:stringURL];
}

@end
