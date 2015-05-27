//
//  FeedbackViewController.h
//  WhatAnIdiot
//
//  Created by Chris on 2015-01-10.
//  Copyright (c) 2015 VanCity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DoneCallback)();

@interface FeedbackViewController : UIViewController

- (id)initWithDoneCallback:(DoneCallback)callback;
- (id)initWithScreenshot:(UIImage *)screenshot DoneCallback:(DoneCallback)callback;

- (void)showTextbox;
- (IBAction)onExit;
- (void)onCancel;
- (void)onSubmitFeedback:(NSString *)description WithImage:(UIImage *)image;

- (void)showChrome;
- (void)hideChrome;

- (void)start;
@end
