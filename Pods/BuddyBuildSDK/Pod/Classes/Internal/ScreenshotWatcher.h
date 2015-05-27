//
//  ScreenshotWatcher.h
//  Pods
//
//  Created by Chris on 2015-01-20.
//
//

#import <Foundation/Foundation.h>

typedef void (^FoundScreenshotCallback)(UIImage* screenshotImage);

@interface ScreenshotWatcher : NSObject
+ (void)watch:(NSDate*)afterTime callback:(FoundScreenshotCallback)callback;
@end