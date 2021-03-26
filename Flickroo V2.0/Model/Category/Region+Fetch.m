//
//  Region+Fetch.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/24/21.
//

#import "Region+Fetch.h"
#import "Region+Create.h"
#import "FlickrFetcher.h"
#import "FilePath.h"

#define SAVE_FILE_PATH @"region_.plist"

@implementation Region (Fetch)

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (Region *)regionForFlickrPhotoWithInfo: (NSDictionary *)photoDictionary {
    Region *region = nil;
    NSMutableArray *regionArray;
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];

    bool exist = [[NSFileManager defaultManager] fileExistsAtPath:path];

    if (!exist) {
        // Create an initial array holder
        regionArray = [[NSMutableArray alloc] init];
        
        // Create the first record to be saved
        region = [Region createNewRegionFromPhotoDictionary:photoDictionary];
        
        // Save in file
        if (region) {
            [regionArray addObject:region];
            [NSKeyedArchiver archiveRootObject:regionArray toFile:path];
        }
    } else {
        // Fetch all records
        regionArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        for (Region *regionInArchiver in regionArray) {
            if ([regionInArchiver.name isEqualToString:[photoDictionary valueForKeyPath:REGION_NAME]]) {
                NSMutableSet *photosSet = [regionInArchiver.photoIDs mutableCopy];
                NSMutableSet *photographerSet = [regionInArchiver.photographerIDs mutableCopy];
                
                // Update values
                [photosSet addObject:[photoDictionary valueForKeyPath:REGION_PHOTO_ID]];
                [photographerSet addObject:[photoDictionary valueForKeyPath:REGION_OWNER_ID]];
                regionInArchiver.photoIDs = photosSet;
                regionInArchiver.photographerIDs = photographerSet;
                regionInArchiver.uniquePhotographerCount = [regionInArchiver.photographerIDs count];
 
                // Save new values in file
                [NSKeyedArchiver archiveRootObject:regionArray toFile:path];
                return regionInArchiver;
            }
        }
        
        // If not record exists create the object
        region = [Region createNewRegionFromPhotoDictionary:photoDictionary];
        
        if (region) {
            [regionArray addObject:region];
        }
        
        // Save to file
        [NSKeyedArchiver archiveRootObject:regionArray toFile:path];
    }
    
    return region;
}

+ (void)regionForFlickrPhotosWithInfoArray: (NSArray *)photoDictionaryArray {
    Region *region = nil;
    NSMutableArray *regionArray;
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];

    bool exist = [[NSFileManager defaultManager] fileExistsAtPath:path];

    if (!exist) {
        // Create an initial array holder
        regionArray = [[NSMutableArray alloc] init];
        
        // Create the first record to be saved
        region = [Region createNewRegionFromPhotoDictionary:photoDictionaryArray.firstObject];
        
        // Save in file
        if (region) {
            [regionArray addObject:region];
        }
        [NSKeyedArchiver archiveRootObject:regionArray toFile:path];
    }
    // Fetch all records
    regionArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    for (NSDictionary *photoDictionary in photoDictionaryArray) {
        region = [Region createNewRegionFromPhotoDictionary:photoDictionary];
        if ([regionArray containsObject:region]) {
            region = [regionArray objectAtIndex:[regionArray indexOfObject:region]];
            NSMutableSet *photosSet = [region.photoIDs mutableCopy];
            NSMutableSet *photographerSet = [region.photographerIDs mutableCopy];
                
            // Update values
            [photosSet addObject:[photoDictionary valueForKeyPath:REGION_PHOTO_ID]];
            [photographerSet addObject:[photoDictionary valueForKeyPath:REGION_OWNER_ID]];
            region.photoIDs = photosSet;
            region.photographerIDs = photographerSet;
            region.uniquePhotographerCount = [region.photographerIDs count];
            [regionArray replaceObjectAtIndex:[regionArray indexOfObject:region] withObject:region];
        } else {
            if (region) {
                [regionArray addObject:region];
            }
        }
    }
    [NSKeyedArchiver archiveRootObject:regionArray toFile:path];
}

+ (NSArray *)fetchAllRegion {
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
