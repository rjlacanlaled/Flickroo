//
//  Thumbnail+Fetch.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/24/21.
//

#import "Thumbnail.h"

NS_ASSUME_NONNULL_BEGIN

@interface Thumbnail (Fetch)
+ (Thumbnail *)fetchThumbnailWithPhotoID: (NSString *)photoID;
+ (Thumbnail *)createNewThumbnailForPhotoID: (NSString *)photoID withData: (NSData *)thumbnailData;
@end

NS_ASSUME_NONNULL_END
