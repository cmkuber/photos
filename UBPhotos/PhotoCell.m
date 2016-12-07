//
//  PhotoCell.m
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "PhotoCell.h"
#import "FlickrPhoto.h"
#import <Haneke/Haneke.h>

@interface PhotoCell ()
@property (nonatomic, readwrite, strong, nullable) IBOutlet UIImageView *imageView;
@end

@implementation PhotoCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
}

- (void)configureWithPhoto:(FlickrPhoto *)photo {
    [self.backgroundView setClipsToBounds:NO];
    self.backgroundView.layer.borderWidth = 2.0;
    self.backgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    if(photo == nil) {
        self.imageView.image = nil;
    } else {
        [self.imageView hnk_setImageFromURL:photo.imageURL placeholder:nil];
    }
}

@end
