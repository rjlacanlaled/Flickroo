//
//  Photographer+Create.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "Photographer+Create.h"
#import "FlickrFetcher.h"
#import "FilePath.h"

#define SAVE_FILE_PATH @"photographer_.plist"

@implementation Photographer (Create)

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (Photographer *)photographerWithFlickrInfo: (NSDictionary *)photoDictionary {
    Photographer *photographer;
    NSMutableArray *photographerArray;
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    
    bool exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!exist) {
        // If no record yet, create first record
        photographerArray = [[NSMutableArray alloc] init];
        
        // Create the record with the values
        photographer = [Photographer createNewPhotographerUsingPhotoDictionary:photoDictionary];
        [photographerArray addObject:photographer];
        
        // Save in file
        [NSKeyedArchiver archiveRootObject:photographerArray toFile:path];
    } else {
        
        // Retrieve the records
        photographerArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        for (Photographer *photographerInArchiver in photographerArray) {
            if ([photographerInArchiver.photogID isEqualToString:[photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER_ID]]) {
                return photographerInArchiver;
            }
        }
        
        // If record does not exist, create a new one
        photographer = [Photographer createNewPhotographerUsingPhotoDictionary:photoDictionary];
        [photographerArray addObject:photographer];
        
        // Save in file
        [NSKeyedArchiver archiveRootObject:photographerArray toFile:path];
    }
    
    return photographer;
}

+ (Photographer *)createNewPhotographerUsingPhotoDictionary: (NSDictionary *)photoDictionary {
    Photographer *photographer = [[Photographer alloc] init];
    photographer.photogID = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER_ID];
    photographer.name = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER_NAME];
    NSMutableSet *photosSet = [[NSMutableSet alloc] init];
    [photosSet addObject:[photoDictionary valueForKeyPath:FLICKR_PHOTO_ID]];
    return photographer;
}

@end
