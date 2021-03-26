//
//  Photo+Delete.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/27/21.
//

#import "Photo.h"

@interface Photo (Delete)
+ (BOOL)deletePhoto: (Photo *)photo;
+ (void)deletePhotosWithDaysOld: (float)daysOld;
@end

