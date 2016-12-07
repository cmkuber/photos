//
//  PhotoCell.h
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhoto;
@interface PhotoCell : UICollectionViewCell

- (void)configureWithPhoto:(FlickrPhoto *)photo;

@end
