//
//  Photo+FlickrFetch.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "Photo.h"
#import "Photo+Create.h"

@interface Photo (FlickrFetch)

+ (void)loadPhotos: (NSArray *) photos;
+ (Photo *)photoWithFlickrInfo: (NSDictionary *)photoDictionary;
+ (NSArray *)fetchAllPhotos;

@end

