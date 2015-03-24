//
//  UIColor+Gradient.h
//  OOSideMenu
//
//  Created by OO on 3/24/15.
//  Copyright (c) 2015 comein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Gradient)
+(UIImage*)imageWithTopColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor size:(CGSize)size;
@end
