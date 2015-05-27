//
//  API.m
//  Pods
//
//  Created by Ting Shi on 2015-02-25.
//
//

#import "API.h"
#import "BuddyBuildSDK.h"

@implementation API


+ (id)shared {
    static API *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString*)base64encodeImage:(UIImage*)image {
    return [UIImageJPEGRepresentation(image, 0.7) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (void)sendOpenEvent{

    NSError *error;

    NSString* endpoint = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUDDYBUILD_ENDPOINT"];
    NSString* buildId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUDDYBUILD_BUILD_ID"];
    NSString* appId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUDDYBUILD_APP_ID"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* email = [defaults objectForKey:@"buddybuild.email"];

    if (!email) {
        return;
    }
    NSLog(@"endpoint = %@", endpoint);
    NSLog(@"buildId = %@", buildId);
    NSLog(@"appId = %@", appId);


    NSString* urlString = [NSString stringWithFormat:@"%@%@", endpoint, @"/api/sdk/open-event"];

    NSLog(@"urlString=%@", urlString);

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [request setHTTPMethod:@"POST"];

    NSDictionary *parameters = @{
                                 @"app_id": appId,
                                 @"build_id": buildId,
                                 @"email": email
                                 };

    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];

    NSLog(@"Sending http request : %@", parameters);
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"back from http request");
    }];
    
    [postDataTask resume];
}


- (void)sendFeedback:(NSString *)description WithImage:(UIImage *)image DoneCallback:(DoneCallback)callback{
    NSLog(@"sendFeedback : %@", description);
    NSString *imageData = [self base64encodeImage:image];

    NSError *error;

    NSString* endpoint = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUDDYBUILD_ENDPOINT"];
    NSString* buildId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUDDYBUILD_BUILD_ID"];
    NSString* appId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUDDYBUILD_APP_ID"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* email = [defaults objectForKey:@"buddybuild.email"];
    NSLog(@"endpoint = %@", endpoint);
    NSLog(@"buildId = %@", buildId);
    NSLog(@"appId = %@", appId);


    NSString* urlString = [NSString stringWithFormat:@"%@%@", endpoint, @"/api/feedback"];

    NSLog(@"urlString=%@", urlString);

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [request setHTTPMethod:@"POST"];

    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:description forKey:@"description"];
    [parameters setObject:imageData forKey:@"screenshot_data"];

    if (appId != nil) {
        [parameters setObject:appId forKey:@"app_id"];
    }

    if (buildId != nil) {
        [parameters setObject:buildId forKey:@"build_id"];
    }

    if (email != nil) {
        [parameters setObject:email forKey:@"email"];
    }


    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];

    NSLog(@"Sending http request : %@", parameters);
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"back from http request");
        callback();
    }];
    
    [postDataTask resume];
}
@end
