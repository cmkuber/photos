//
//  FlickrCoordinator.m
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "FlickrCoordinator.h"
#import "FlickrClient.h"
#import "FlickrResponse.h"

@interface FlickrCoordinator ()

@property (strong) FlickrClient *client;
@property (strong) FlickrResponse *initialResponse;
@property (assign) NSUInteger photosPerPage;
@property (strong) NSMutableDictionary *responseByPage;
@property (copy) NSString *searchText;

@end

@implementation FlickrCoordinator

- (instancetype)init {
    self = [super init];
    if(self) {
        self.client = [[FlickrClient alloc] initWithAPIKey:@"27b33dcbde3c89078933128db5449045"];
        self.responseByPage = [NSMutableDictionary new];
    }
    return self;
}

- (void)searchFor:(NSString *)searchText photosPerPage:(NSUInteger)photosPerPage {
    self.searchText = searchText;
    self.responseByPage = [NSMutableDictionary new];
    self.photosPerPage = photosPerPage;
    self.initialResponse = nil;
    __weak typeof(self)weakSelf = self;
    [self.client requestPhotosFor:searchText page:1 photosPerPage:photosPerPage completionHandler:^(FlickrResponse *response) {
        if(response == nil) {
            [self.delegate flickrCoordinator:weakSelf didFailToLoadPhotosForPage:1];
            return;
        }
        weakSelf.initialResponse = response;
        weakSelf.responseByPage[@(1)] = response;
        [weakSelf.delegate flickrCoordinator:weakSelf didLoadPhotosForPage:1];
    }];
}

- (NSUInteger)numberOfPhotos {
    return self.initialResponse != nil ? self.initialResponse.totalNumberOfPhotos : 0;
}

- (nullable FlickrPhoto *)photoAtIndex:(NSUInteger)index forPage:(NSUInteger)page {
    FlickrResponse *localResponse = self.responseByPage[@(page)];
    if(localResponse == nil) {
        __weak typeof(self)weakSelf = self;
        [self.client requestPhotosFor:self.searchText page:page photosPerPage:self.photosPerPage completionHandler:^(FlickrResponse *response) {
            if(response == nil) {
                [weakSelf.delegate flickrCoordinator:weakSelf didFailToLoadPhotosForPage:1];
                return;
            }
            weakSelf.responseByPage[@(page)] = response;
            [weakSelf.delegate flickrCoordinator:weakSelf didLoadPhotosForPage:page];
        }];
        return nil;
    }
    NSArray *photos = localResponse.photos;
    // There is a bug in the Flickr-API which causes the count of the response to be off by 1.
    if(index >= photos.count) {
        return nil;
    }
    FlickrPhoto *photo = photos[index];
    return photo;
}

@end
