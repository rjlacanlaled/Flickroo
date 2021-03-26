//
//  Photo+Create.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "Photo+Create.h"
#import "Photographer+Create.h"
#import "FlickrFetcher.h"

@implementation Photo (Create)

+ (Photo *)createNewPhotoUsingPhotoDictionary: (NSDictionary *)photoDictionary {
    Photo *photo = [[Photo alloc] init];
    photo.photoID = [photoDictionary valueForKeyPath:FLICKR_PHOTO_ID];
    photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
    photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
    photo.thumbnailURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
    photo.uploadDate = [photoDictionary valueForKeyPath:FLICKR_PHOTO_UPLOAD_DATE];
    photo.photographer = [Photographer photographerWithFlickrInfo:photoDictionary];
    return photo;
}


@end
