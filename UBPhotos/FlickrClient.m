//
//  FlickrClient.m
//  UBPhotos
//
//  Created by Christian Kienle on 06/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "FlickrClient.h"
#import "FlickrResponse.h"
#import "NSURLSession+FlickrClient.h"

@interface FlickrClient ()

@property (strong) NSURLSession *session;
@property (strong) NSURLSessionDataTask *requestPhotosTask;
@property (copy) NSString *APIKey;

@end



@implementation NSError (FlickrClient)

- (BOOL)representsCancellation {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorCancelled;
}

@end

@implementation FlickrClient

- (instancetype)initWithAPIKey:(NSString *)APIKey {
    NSParameterAssert(APIKey != nil);
    self = [super init];
    if (self) {
        self.APIKey = APIKey;
        self.session = [NSURLSession newFlickClientSession];
    }
    return self;
}

- (instancetype)init {
    NSString *reason = [NSString stringWithFormat:@"-[%@ %@] Invalid. Use %@ instead and provide a proper API key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd), NSStringFromSelector(@selector(initWithAPIKey:))];
    @throw [NSException exceptionWithName:NSGenericException reason:reason userInfo:nil];
}

- (void)requestPhotosFor:(NSString *)searchText
                    page:(NSUInteger)page
           photosPerPage:(NSUInteger)photosPerPage
       completionHandler:(FlickClientCompletionHandler)completionHandler {
    NSParameterAssert(page > 0);
    NSParameterAssert(photosPerPage > 0);
    NSParameterAssert(searchText != nil);
    NSParameterAssert(searchText.length > 0);
    
    [self.requestPhotosTask cancel];
    self.requestPhotosTask = nil;
    
    NSURLComponents *components = [NSURLComponents new];
    components.host = @"api.flickr.com";
    components.path = @"/services/rest/";
    components.scheme = @"https";
    NSURLQueryItem *photosPerPageItem = [NSURLQueryItem queryItemWithName:@"per_page" value:[NSString stringWithFormat:@"%lu", photosPerPage]];
    NSURLQueryItem *pageItem = [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%lu", page]];
    NSURLQueryItem *searchTextItem = [NSURLQueryItem queryItemWithName:@"text" value:searchText];
    NSURLQueryItem *methodItem = [NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"];
    NSURLQueryItem *apiKeyItem = [NSURLQueryItem queryItemWithName:@"api_key" value:self.APIKey];
    NSURLQueryItem *formatItem = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    NSURLQueryItem *noCallbackItem = [NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"];
    components.queryItems = @[photosPerPageItem, pageItem, searchTextItem, methodItem, apiKeyItem, formatItem, noCallbackItem];
    NSURL *URL = components.URL;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.session.configuration.timeoutIntervalForRequest];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            if([error representsCancellation]) { // ignore cancellations (room for improvements)
                return;
            }
            // TODO: proper Error Handling
            completionHandler(nil);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSIndexSet *acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        if([acceptableStatusCodes containsIndex:httpResponse.statusCode] == NO) {
            // TODO: proper Error Handling
            completionHandler(nil);
            return;
        }
        if(data == nil) {
            // TODO: proper Error Handling
            completionHandler(nil);
            return;
        }
        NSError *JSONError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
        if(jsonObject == nil) {
            // TODO: proper Error Handling
            completionHandler(nil);
            return;
        }
        if([jsonObject isKindOfClass:[NSDictionary class]] == NO) {
            // TODO: proper Error Handling
            completionHandler(nil);
            return;
        }
        FlickrResponse *flickrResponse = [FlickrResponse newFromJSONDictionary:jsonObject];
        completionHandler(flickrResponse);
    }];
    self.requestPhotosTask = task;
    [self.requestPhotosTask resume];
}

@end



