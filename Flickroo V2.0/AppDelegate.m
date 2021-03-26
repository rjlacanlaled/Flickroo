//
//  AppDelegate.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import "AppDelegate.h"
#import "FlickrFetcher.h"
#import "Photo.h"
#import "Region.h"
#import "Photographer.h"
#import "Photo+Create.h"
#import "Photo+FlickrFetch.h"
#import "Region+Create.h"
#import "Region+Fetch.h"
#import <BackgroundTasks/BackgroundTasks.h>

@interface AppDelegate () <NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSString *lastPhotoToDownload;
@end


@implementation AppDelegate

#define TIME_OUT_INTERVAL_FOR_REQUEST 30.0

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.kooapps.flickroo"];
        config.timeoutIntervalForRequest = TIME_OUT_INTERVAL_FOR_REQUEST;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}


#define REGION_TASK_DESCRIPTION @"region"
#define PHOTOS_TASK_DESCRIPTION @"photos"

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    
    if ([downloadTask.taskDescription isEqualToString:PHOTOS_TASK_DESCRIPTION]) {
        NSArray *photos = [self getArrayOfPhotosFromData: [NSData dataWithContentsOfURL:location]];
        [self downloadRegionDataUsingPhotos: photos];
        [Photo loadPhotos:photos];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlickrUpdate"
                                                            object:nil];
    }
    
    if ([downloadTask.taskDescription isEqualToString:REGION_TASK_DESCRIPTION]) {
        NSData *regionData = [NSData dataWithContentsOfURL:location];
        NSDictionary *regionDict = [NSJSONSerialization JSONObjectWithData:regionData options:0 error:NULL];
        [self loadRegionDataToSavedFileUsingData: [NSData dataWithContentsOfURL:location]];
        [self checkIfTimeToSendNotificationWithRegionDictionary: regionDict];
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchFlickrPhotos) name:@"FetchPhotos" object:nil];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Flickroo_V2_0"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


#pragma mark - Helper Methods

// Get the filepath for fetching and saving on plist
- (NSString *)filepathWithFilename:(NSString*)filename {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                      objectAtIndex:0];
    path = [path stringByAppendingPathComponent:filename];
    return path;
}

- (void)downloadDataWithURL: (NSURL *)url withTaskDescription: (NSString *)taskDescription  {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    task.taskDescription = taskDescription;
    [task resume];
}

- (void)fetchFlickrPhotos {
    NSLog(@"Fetching......");
    [self downloadDataWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos] withTaskDescription:PHOTOS_TASK_DESCRIPTION];
}

- (void)downloadRegionDataUsingPhotos: (NSArray *)photos {
    for ( NSDictionary *photo in photos) {
        [self downloadDataWithURL:[FlickrFetcher URLforDetailedInfoForPhotoID:[photo valueForKey:FLICKR_PHOTO_ID]] withTaskDescription:REGION_TASK_DESCRIPTION];
    }
    self.lastPhotoToDownload = [photos.lastObject valueForKeyPath:FLICKR_PHOTO_ID];
}

- (void)loadRegionDataToSavedFileUsingData: (NSData *)regionData {
    NSDictionary *regionDictionary = [NSJSONSerialization JSONObjectWithData:regionData options:0 error:NULL];
    
    // Save data to the file if it doesn't exist already
    [Region regionForFlickrPhotoWithInfo:regionDictionary];
}

- (NSArray *)getArrayOfPhotosFromData: (NSData *)photosData {
    NSDictionary *photoDictionary = [NSJSONSerialization JSONObjectWithData:photosData options:0 error:NULL];
    return [photoDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

- (void)checkIfTimeToSendNotificationWithRegionDictionary: (NSDictionary *)regionDict {
    if ([[regionDict valueForKeyPath:REGION_PHOTO_ID] isEqualToString:self.lastPhotoToDownload]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegionUpdate" object:nil];
        self.lastPhotoToDownload = nil;
    }
}

@end
