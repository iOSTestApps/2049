//
//  API.h
//  Pods
//
//  Created by Ting Shi on 2015-02-25.
//
//

#import <Foundation/Foundation.h>

typedef void (^DoneCallback)();

@interface API : NSObject

+ (id)shared;

- (void)sendFeedback:(NSString *)description WithImage:(UIImage *)image DoneCallback:(DoneCallback)callback;
- (void)sendOpenEvent;
@end
