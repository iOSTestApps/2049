//
//  FeedbackDialogViewController.h
//  WhatAnIdiot
//
//  Created by Chris on 2015-01-10.
//  Copyright (c) 2015 VanCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackViewController.h"

@interface FeedbackDialogViewController : UIViewController
@property (strong) IBOutlet UITextView* textView;
@property (strong) IBOutlet UIImageView* imageView;
@property (strong) FeedbackViewController* parent;

- (void)setImage:(UIImage *) image;

@end
