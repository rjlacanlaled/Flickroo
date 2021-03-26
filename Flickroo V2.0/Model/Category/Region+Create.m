//
//  Region+Create.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "Region+Create.h"
#import "FlickrFetcher.h"


@implementation Region (Create)

+ (Region *)createNewRegionFromPhotoDictionary: (NSDictionary *)photoDictionary {
    Region *region = [[Region alloc] init];
    NSMutableSet *photosSet = [[NSMutableSet alloc] init];
    NSMutableSet *photographerSet = [[NSMutableSet alloc] init];
    
    // Update photo and photographer set
    [photosSet addObject:[photoDictionary valueForKeyPath:REGION_PHOTO_ID]];
    [photographerSet addObject:[photoDictionary valueForKeyPath:REGION_OWNER_ID]];
    
    
    //Check for null region name
    region.name = [photoDictionary valueForKeyPath:REGION_NAME];

    if (region.name == NULL) {
        return nil;
    }
    
    // Add remaining properties
    region.photoIDs = photosSet;
    region.photographerIDs = photographerSet;
    region.uniquePhotographerCount = [region.photographerIDs count];
    return region;
}
    
@end
