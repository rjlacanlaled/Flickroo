//
//  Photographer+Create.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "Photographer.h"

@interface Photographer (Create)
+ (Photographer *)photographerWithFlickrInfo: (NSDictionary *)photoDictionary;
@end
