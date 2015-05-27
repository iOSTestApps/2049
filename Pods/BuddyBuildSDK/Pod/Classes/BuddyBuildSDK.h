//
//  BuddyBuildSDK.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

@interface BuddyBuildSDK : NSObject

+ (void)setup:(id<UIApplicationDelegate>)appDelegate;
+ (BOOL)handleOpenURL:(NSURL *)url;

@end
