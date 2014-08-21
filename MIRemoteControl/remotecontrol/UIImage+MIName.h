//
//  UIImage+MIName.h
//  MIRemoteControl
//
//  Created by ran on 14-8-21.
//  Copyright (c) 2014年 rannie. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IPHONE_5OR5S (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON )

@interface UIImage (MIName)

+ (UIImage *)mi_imageMatchSizeWithName:(NSString *)imageName;

@end
