//
//  UIColor+Gradient.m
//  OOSideMenu
//
//  Created by OO on 3/24/15.
//  Copyright (c) 2015 comein. All rights reserved.
//

#import "UIColor+Gradient.h"

@implementation UIColor (Gradient)
+(UIImage*)imageWithTopColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor size:(CGSize)size{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, size.width, size.height);
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.colors = @[(id)[topColor CGColor], (id)[bottomColor CGColor]];
    UIGraphicsBeginImageContext(gradient.frame.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [gradient renderInContext:context];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
