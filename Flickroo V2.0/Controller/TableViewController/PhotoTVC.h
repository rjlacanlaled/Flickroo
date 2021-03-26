//
//  PhotoTVC.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/24/21.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoTVC : UITableViewController
@property (strong, nonatomic) NSArray *photos;

- (UIImage *)getThumbnailForPhoto: (Photo *)photo;
- (void)updateRecentlyViewedPhotos;
@end

