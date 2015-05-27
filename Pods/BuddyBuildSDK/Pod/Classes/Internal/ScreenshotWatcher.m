//
//  ScreenshotWatcher.m
//  Pods
//
//  Created by Chris on 2015-01-20.
//
//

#import "ScreenshotWatcher.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ScreenshotWatcher

+ (void)watch:(NSDate*)afterTime callback:(FoundScreenshotCallback)callback {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self findScreenshot:afterTime callback:^(UIImage *screenshotImage) {
            NSLog(@"screenshotImage = %@", screenshotImage);

            if (screenshotImage != nil) {
                NSLog(@"Got one");
                callback(screenshotImage);
            }
            else {
                [self watch:afterTime callback:callback];
            }
        }];
    });
}

+ (void)findScreenshot:(NSDate*)afterTime callback:(FoundScreenshotCallback)callback {

    typedef void (^AssetEnumerationCallback)(ALAssetsGroup *group, BOOL *stop);

    AssetEnumerationCallback cb = ^(ALAssetsGroup *group, BOOL *stop) {
        if (nil != group) {
            // be sure to filter the group so you only get photos
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];

            @try {
                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets - 1]
                                        options:0
                                     usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                         if (nil != result) {
                                             NSDate * date = [result valueForProperty:ALAssetPropertyDate];

                                             // Was the asset date later than the comparison time?
                                             if ([date compare:afterTime] == NSOrderedDescending) {
                                                 ALAssetRepresentation *repr = [result defaultRepresentation];
                                                 // this is the most recent saved photo
                                                 UIImage *img = [UIImage imageWithCGImage:[repr fullResolutionImage]];

                                                 callback(img);
                                             }
                                             else {
                                                 callback(nil);
                                             }

                                             *stop = YES;
                                         }
                                     }];

            }
            @catch (NSException *exception) {
                NSLog(@"exception = %@", exception);
                callback(nil);
            }
            @finally {

            }
            }

            *stop = NO;
        };


        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                     usingBlock: cb
                                   failureBlock:^(NSError *error) {
                                       NSLog(@"error: %@", error);
                                   }];




}

@end
