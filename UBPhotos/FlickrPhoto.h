//
//  FlickrPhoto.h
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhoto : NSObject

+ (NSArray *)photosFromJSONArray:(NSArray *)array;
+ (instancetype)newFromJSONDictionary:(NSDictionary *)dictionary;
@property (readonly) NSURL *imageURL;

@end
