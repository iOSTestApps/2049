//
//  FeedbackViewController.m
//  WhatAnIdiot
//
//  Created by Chris on 2015-01-10.
//  Copyright (c) 2015 VanCity. All rights reserved.
//

#import "FeedbackViewController.h"
#import "DrawingView.h"
#import "FeedbackDialogViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ScreenshotWatcher.h"
#import "BBUtils.h"
#import "API.h"

@interface FeedbackViewController ()
@property (strong) IBOutlet UIImageView* imageView;
@property (strong) IBOutlet DrawingView* drawingView;
@property (strong) IBOutlet UILabel* titleLabel;
@property (strong) IBOutlet UILabel* loadingLabel;
@property (strong) IBOutlet UIView* veil;
@property (strong) IBOutlet UIView* headerView;
@property (strong) FeedbackDialogViewController* feedbackDialog;
@property (strong) IBOutlet UIActivityIndicatorView* progress;
@property (strong) UIImage *screenshot;
@property (copy) DoneCallback doneCallback;
@property (strong) IBOutlet UIActivityIndicatorView* submitting;
@property (strong) IBOutlet UILabel* submittingLabel;
@end

@implementation FeedbackViewController

- (id)initWithDoneCallback:(DoneCallback)callback {
    self = [self init];

    if (self) {
        self.doneCallback = callback;
    }

    return self;
}

- (id)initWithScreenshot:(UIImage *)screenshot DoneCallback:(DoneCallback)callback {
    self = [self init];

    if (self) {
        self.screenshot = screenshot;
        self.doneCallback = callback;
    }

    return self;
}

/*- (void)animateProgress {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        float currentProgress = [self.progress progress];
        currentProgress += 1.0f/30.0f;
        [self.progress setProgress:currentProgress animated:YES];

        if ([self.progress progress] < 1.0f) {
            [self animateProgress];
        }
        else {

        }
    });
}*/

- (void)hideProgress {
    self.progress.hidden = YES;
    self.loadingLabel.hidden = YES;
}

- (void)start {
    self.drawingView.parent = self;

    //[self.progress setProgress:0];
    //[self animateProgress];

    // Find a time 3 seconds ago, and assume the screenshot was taken after that
    NSDate* now = [NSDate date];
    NSDate* afterTime = [now dateByAddingTimeInterval:-3];

    if (self.screenshot == nil) {
        [ScreenshotWatcher watch:afterTime callback:^(UIImage *screenshotImage) {
            self.imageView.image = screenshotImage;
            // we only need the first (most recent) photo -- stop the enumeration
            [self hideProgress];
        }];
    } else {
        self.imageView.image = self.screenshot;
        [self hideProgress];
    }
}

- (void)showTextbox {
    FeedbackDialogViewController* vc = [[FeedbackDialogViewController alloc] init];
    self.feedbackDialog = vc;
    vc.parent = self;
    CGRect mainWindowFrame = self.view.frame;
    vc.view.frame = CGRectMake((mainWindowFrame.size.width-300)/2, -50, 300, 217);
    vc.view.layer.cornerRadius = 5.0;
    vc.view.layer.masksToBounds = YES;

    UIGraphicsBeginImageContext(self.drawingView.bounds.size);
    [self.drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    vc.textView.text = @"";
    [vc.textView becomeFirstResponder];
    UIImage *mergedImg = [BBUtils merge:self.imageView.image withImage:img];
    [vc setImage:mergedImg];
    [self.view addSubview:vc.view];

    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                        vc.view.frame = CGRectMake((mainWindowFrame.size.width-300)/2, 30, 300, 217);
                     }
                     completion:nil];

    self.veil.hidden = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)onSubmitFeedback:(NSString *)description WithImage:(UIImage *)image {
    [self.feedbackDialog.view removeFromSuperview];

    self.submittingLabel.hidden = NO;
    self.submitting.hidden = NO;

    [[API shared] sendFeedback:description WithImage:image DoneCallback:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.submittingLabel.text = @"Submission Complete!";
            self.submitting.hidden = YES;
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onExit) userInfo:nil repeats:NO];
        });
    }];
}

- (void)onCancel {
    [self.feedbackDialog.view removeFromSuperview];
    self.veil.hidden = YES;
    [self.drawingView reset];
}

- (IBAction)onExit {
    [self.view removeFromSuperview];
    if (self.doneCallback) {
        self.doneCallback();
        self.doneCallback = nil; // make sure no double-calls.
    }
}

- (void)showChrome {
    self.headerView.hidden = NO;
}

- (void)hideChrome {
    self.headerView.hidden = YES;
}

@end
