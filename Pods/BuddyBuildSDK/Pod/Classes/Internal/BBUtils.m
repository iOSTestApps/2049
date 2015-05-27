//
//  BBUtils.m
//  Pods
//
//  Created by Ting Shi on 2/26/15.
//
//

#import "BBUtils.h"

@implementation BBUtils

+ (UIImage*)merge:(UIImage*)baseImage withImage:(UIImage*)overlayImage {
    UIImage *image = nil;
    
    UIGraphicsBeginImageContext(baseImage.size);
    
    [baseImage drawAtPoint:CGPointMake(0, 0)];
    [overlayImage drawInRect:CGRectMake(0, 0, baseImage.size.width, baseImage.size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
