//
//  Photo.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import "Photo.h"

@implementation Photo


#define PHOTO_ID_KEY @"photoID"
#define PHOTO_TITLE_KEY @"title"
#define PHOTO_SUBTITLE_KEY @"subtitle"
#define PHOTO_IMAGE_URL_KEY @"imageURL"
#define PHOTO_UPLOAD_DATE_KEY @"uploadDate"
#define PHOTO_OWNER_KEY @"photographer"
#define PHOTO_THUMBNAIL_URL_KEY @"thumbnailURL"

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.photoID forKey:PHOTO_ID_KEY];
    [coder encodeObject:self.title forKey:PHOTO_TITLE_KEY];
    [coder encodeObject:self.subtitle forKey:PHOTO_SUBTITLE_KEY];
    [coder encodeObject:self.imageURL forKey:PHOTO_IMAGE_URL_KEY];
    [coder encodeObject:self.thumbnailURL forKey:PHOTO_THUMBNAIL_URL_KEY];
    [coder encodeObject:self.uploadDate forKey:PHOTO_UPLOAD_DATE_KEY];
    [coder encodeObject:self.photographer forKey:PHOTO_OWNER_KEY];
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    
    if(self) {
        self.photoID = [coder decodeObjectForKey:PHOTO_ID_KEY];
        self.title = [coder decodeObjectForKey:PHOTO_TITLE_KEY];
        self.subtitle = [coder decodeObjectForKey:PHOTO_SUBTITLE_KEY];
        self.imageURL = [coder decodeObjectForKey:PHOTO_IMAGE_URL_KEY];
        self.thumbnailURL = [coder decodeObjectForKey:PHOTO_THUMBNAIL_URL_KEY];
        self.uploadDate = [coder decodeObjectForKey:PHOTO_UPLOAD_DATE_KEY];
        self.photographer = [coder decodeObjectForKey:PHOTO_OWNER_KEY];
    }
    
    return self;
}

@end
