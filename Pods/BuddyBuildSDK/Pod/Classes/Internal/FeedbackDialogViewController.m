//
//  FeedbackDialogViewController.m
//  WhatAnIdiot
//
//  Created by Chris on 2015-01-10.
//  Copyright (c) 2015 VanCity. All rights reserved.
//

#import "FeedbackDialogViewController.h"
#import "API.h"

@interface FeedbackDialogViewController ()

@end

@implementation FeedbackDialogViewController

UIImage *_image;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setImage:(UIImage *) image {
    _image = image;
    self.imageView.image = image;
}

- (IBAction)onDone {
    [self.parent onSubmitFeedback:self.textView.text WithImage:_image];
}

- (IBAction)onCancel {
    [self.parent onCancel];
}

@end
