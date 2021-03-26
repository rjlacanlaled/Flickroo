//
//  AppDelegate.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

