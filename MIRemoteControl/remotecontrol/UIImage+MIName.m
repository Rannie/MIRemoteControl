//
//  UIImage+MIName.m
//  MIRemoteControl
//
//  Created by ran on 14-8-21.
//  Copyright (c) 2014年 rannie. All rights reserved.
//

#import "UIImage+MIName.h"

@implementation UIImage (MIName)

+ (UIImage *)mi_imageMatchSizeWithName:(NSString *)imageName
{
    if (IPHONE_5OR5S)       //iphone5,5s
    {
        imageName = [imageName stringByDeletingPathExtension];
        imageName = [imageName stringByAppendingString:@"_ip5"];
        imageName = [imageName stringByAppendingPathExtension:@"png"];
    }
    
    return [UIImage imageNamed:imageName];
}

@end
