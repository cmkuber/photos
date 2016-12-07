//
//  FlickrResponse.m
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "FlickrResponse.h"
#import "FlickrPhoto.h"

@interface FlickrResponse ()

@property (readwrite) NSUInteger page;
@property (readwrite) NSUInteger numberOfPages;
@property (readwrite) NSUInteger numberOfPhotosPerPage;
@property (readwrite) NSUInteger totalNumberOfPhotos;
@property (readwrite, copy) NSArray *photos;

@end

@implementation FlickrResponse
+ (instancetype)newFromJSONDictionary:(NSDictionary *)dictionary {
    NSDictionary *rawPhotos = dictionary[@"photos"];
    if(rawPhotos == nil || [rawPhotos isKindOfClass:[NSDictionary class]] == NO) {
        return nil;
    }
    NSNumber *rawPage = rawPhotos[@"page"];
    if(rawPage == nil || [rawPage respondsToSelector:@selector(integerValue)] == NO) {
        return nil;
    }
    NSUInteger page = rawPage.integerValue;
    
    NSString *rawPages = rawPhotos[@"pages"];
    if(rawPages == nil || [rawPages respondsToSelector:@selector(integerValue)] == NO) {
        return nil;
    }
    NSUInteger pages = [rawPages integerValue];
    
    NSNumber *rawPerPage = rawPhotos[@"perpage"];
    if(rawPerPage == nil || [rawPerPage respondsToSelector:@selector(integerValue)] == NO) {
        return nil;
    }
    NSInteger perPage = rawPerPage.integerValue;
    
    NSArray *rawPhoto = rawPhotos[@"photo"];
    if(rawPhoto == nil || [rawPhoto isKindOfClass:[NSArray class]] == NO) {
        return nil;
    }
    NSArray *photos = [FlickrPhoto photosFromJSONArray: rawPhoto];
    
    NSString *rawTotal = rawPhotos[@"total"];
    if(rawTotal == nil || [rawTotal respondsToSelector:@selector(integerValue)] == NO) {
        return nil;
    }
    NSUInteger total = [rawTotal integerValue];
    
    return [[self alloc] initWithPage:page
                        numberOfPages:pages
                numberOfPhotosPerPage:perPage
                  totalNumberOfPhotos:total photos:photos];
}

// There is a bug in the Flickr API which causes the following assumption not to be true
// everytime:
// If page < numberOfPages then photos.count should be numberOfPhotosPerPage
- (instancetype)initWithPage:(NSUInteger)page
               numberOfPages:(NSUInteger)numberOfPages
       numberOfPhotosPerPage:(NSUInteger)numberOfPhotosPerPage
         totalNumberOfPhotos:(NSUInteger)totalNumberOfPhotos
                      photos:(NSArray *)photos {
    self = [super init];
    if(self) {
        _page = page;
        _numberOfPages = numberOfPages;
        _numberOfPhotosPerPage = numberOfPhotosPerPage;
        _totalNumberOfPhotos = totalNumberOfPhotos;
        _photos = [photos copy];
    }
    return self;
}
@end
