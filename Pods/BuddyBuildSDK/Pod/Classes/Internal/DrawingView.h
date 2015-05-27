//
//  DrawingView.h
//  WhatAnIdiot
//
//  Created by Chris on 2015-01-10.
//  Copyright (c) 2015 VanCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackViewController.h"

@interface DrawingView : UIView
- (void)reset;
@property(strong) FeedbackViewController* parent;
@end
