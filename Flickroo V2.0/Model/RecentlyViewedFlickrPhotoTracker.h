//
//  RecentlyViewedFlickrPhotoTracker.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/26/21.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

#define PHOTO_VIEWED @"photoViewed"
#define DATE_VIEWED @"dateViewed"
#define PHOTO_ID @"photoID"

@interface RecentlyViewedFlickrPhotoTracker : NSObject

+ (void)trackRecentlyViewedPhoto: (Photo *)photo;
+ (NSArray *)recentlyViewedFlickrPhotosWithLimit: (NSInteger)limit;
+ (void)trackRecentlyCachedPhoto: (NSString *)imagePath;
@end

