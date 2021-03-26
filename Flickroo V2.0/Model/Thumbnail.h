//
//  Thumbnail.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface Thumbnail : NSObject <NSCoding>
@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSData *thumbnail;
@end
