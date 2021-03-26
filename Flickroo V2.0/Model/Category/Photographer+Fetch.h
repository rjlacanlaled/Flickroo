//
//  Photographer+Fetch.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/27/21.
//

#import "Photographer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photographer (Fetch)
+ (NSArray *)fetchAllPhotographers;
@end

NS_ASSUME_NONNULL_END
