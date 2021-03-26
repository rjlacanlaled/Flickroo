//
//  FlickrFetcher.h
//
//  Created for Stanford CS193p Fall 2013.
//  Copyright 2013 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

// key paths to photos or places at top-level of Flickr results
#define FLICKR_RESULTS_PHOTOS @"photos.photo"
#define FLICKR_RESULTS_PLACES @"places.place"

// keys (paths) to values in a photo dictionary
#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_OWNER @"ownername"
#define FLICKR_PHOTO_UPLOAD_DATE @"dateupload" // in seconds since 1970
#define FLICKR_PHOTO_PLACE_ID @"place_id"
#define FLICKR_PHOTO_OWNER_NAME @"ownername"
#define FLICKR_PHOTO_OWNER_ID @"owner"
#define FLICKR_PHOTO_OWNER_PHOTOS @"photos"

// keys (paths) to values in a places dictionary (from TopPlaces)
#define FLICKR_PLACE_NAME @"_content"
#define FLICKR_PLACE_ID @"place_id"

// keys applicable to all types of Flickr dictionaries
#define FLICKR_LATITUDE @"latitude"
#define FLICKR_LONGITUDE @"longitude"
#define FLICKR_TAGS @"tags"

// keys for Location dictionarys
#define REGION_PHOTO_ID @"photo.id"
#define REGION_NAME @"photo.location.region._content"
#define REGION_OWNER_ID @"photo.owner.nsid"

typedef enum {
    FlickrPhotoFormatSquare = 1,    // thumbnail
    FlickrPhotoFormatLarge = 2,     // normal size
    FlickrPhotoFormatOriginal = 64  // high resolution
} FlickrPhotoFormat;

@interface FlickrFetcher : NSObject

+ (NSURL *)URLforTopPlaces;

+ (NSURL *)URLforPhotosInPlace:(id)flickrPlaceId maxResults:(int)maxResults;

+ (NSURL *)URLforPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

+ (NSURL *)URLforRecentGeoreferencedPhotos;

+ (NSURL *)URLforInformationAboutPlace:(id)flickrPlaceId;

+ (NSString *)extractNameOfPlace:(id)placeId fromPlaceInformation:(NSDictionary *)place;
+ (NSString *)extractRegionNameFromPlaceInformation:(NSDictionary *)placeInformation;

+ (NSURL *)URLforPhotosAtLat:(NSNumber*)latitude andLong:(NSNumber*)longitude;
+ (NSURL *)URLforPhotoDetails:(id)photoID;
+ (NSURL *)URLforLocationDetailsForPhotoID:(NSString *)photoID;
+ (NSURL *)URLforDetailedInfoForPhotoID: (NSString *)photoID;
@end
