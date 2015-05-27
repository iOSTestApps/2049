//
//  BuddyBuildSDK.m
//

#import "BuddyBuildSDK.h"
#import "FeedbackViewController.h"
#import "API.h"

@implementation BuddyBuildSDK

id<UIApplicationDelegate> _appDelegate;
bool _isShown = false;
UIViewController* _originalVC;
bool _needToRevertStatusBar = false;

+(void)setup:(id<UIApplicationDelegate>)appDelegate {
    NSString* buildId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUDDYBUILD_BUILD_ID"];
    if (!buildId) {
        NSLog(@"BuddyBuildSDK : Disabled");
        return;
    }

    NSLog(@"BuddyBuildSDK : setup");
    typedef void (^ScreenshotCallback)(NSNotification* note);

    _appDelegate = appDelegate;
    
    ScreenshotCallback callback = ^(NSNotification* note) {
        NSLog(@"You took a screenshot!");
        NSLog(@"%@", note);

        if (_isShown) return;

        _isShown = true;
        FeedbackViewController* vc = [[FeedbackViewController alloc] initWithDoneCallback:^{
            _isShown = false;
            appDelegate.window.rootViewController = _originalVC;

            if (_needToRevertStatusBar) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
            }
        }];

        _originalVC = appDelegate.window.rootViewController;
        appDelegate.window.rootViewController = vc;
        //[[[[UIApplication sharedApplication] delegate] window] addSubview:vc.view];
        //[appDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];

        _needToRevertStatusBar = false;
        if (![UIApplication sharedApplication].isStatusBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            _needToRevertStatusBar = true;
        }

        [vc start];
    };

    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:callback];

    [BuddyBuildSDK findIdentity];
    [[API shared] sendOpenEvent];

}

+ (void)findIdentity {
/*    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.emailToSend forKey:@"teste.email"];
    [defaults synchronize];*/

    NSLog(@"BuddyBuildSDK : findIdentity");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"buddybuild.email"]) {
        NSLog(@"BuddyBuildSDK : No identity, opening safari");
        NSString* endpoint = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUDDYBUILD_ENDPOINT"];
        NSString* url = [NSString stringWithFormat:@"%@/download/identity?app_identifier=%@", endpoint, [[NSBundle mainBundle] bundleIdentifier]];

        NSLog(@"BuddyBuildSDK : url=%@", url);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        });
    }
}

+ (BOOL) handleOpenURL:(NSURL *)url {
    NSLog(@"BuddyBuildSDK : handleOpenURL=%@", [url absoluteString]);
    if ([[url absoluteString] hasPrefix:@"bb-"]) {
        NSString* query = url.query;
        NSLog(@"query = %@", query);
        NSArray* keyvalues = [query componentsSeparatedByString:@"&"];

        NSMutableDictionary* queryDictionary = [NSMutableDictionary dictionary];

        for (NSString* keyvalue in keyvalues) {
            // Doesn't handle \= for example, but likely good enough
            NSArray* parts = [keyvalue componentsSeparatedByString:@"="];
            queryDictionary[parts[0]] = parts[1];
        }

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:queryDictionary[@"email"] forKey:@"buddybuild.email"];
        [defaults synchronize];
        [[API shared] sendOpenEvent];

        return YES;
    }

    return NO;
}

@end
