//
//  Photo+Create.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "Photo.h"

@interface Photo (Create)
+ (Photo *)createNewPhotoUsingPhotoDictionary: (NSDictionary *)photoDictionary;
@end
