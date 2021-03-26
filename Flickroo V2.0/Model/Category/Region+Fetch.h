//
//  Region+Fetch.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/24/21.
//

#import "Region.h"

NS_ASSUME_NONNULL_BEGIN

@interface Region (Fetch)
+ (Region *)regionForFlickrPhotoWithInfo: (NSDictionary *)photoDictionary;
+ (NSArray *)fetchAllRegion;
+ (void)regionForFlickrPhotosWithInfoArray: (NSArray *)photoDictionaryArray;
@end

NS_ASSUME_NONNULL_END
