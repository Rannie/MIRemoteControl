//
//  UIButton+MIFactory.m
//  MIRemoteControl
//
//  Created by ran on 14-8-21.
//  Copyright (c) 2014年 rannie. All rights reserved.
//

#import "UIButton+MIFactory.h"

@implementation UIButton (MIFactory)

+ (UIButton *)mi_buttonWithIcon:(NSString *)icon pressedIcon:(NSString *)pressedIcon target:(id)target action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:ImageCache(icon) forState:UIControlStateNormal];
    if (pressedIcon) {[btn setImage:ImageCache(pressedIcon) forState:UIControlStateHighlighted];}
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
