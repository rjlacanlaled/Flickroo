//
//  Region+Create.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "Region.h"

NS_ASSUME_NONNULL_BEGIN


#define DEFAULT_REGION_NAME @"Unknown Region"

@interface Region (Create)
+ (Region *)createNewRegionFromPhotoDictionary: (NSDictionary *)photoDictionary;
@end

NS_ASSUME_NONNULL_END
