//
//  UIButton+MIFactory.h
//  MIRemoteControl
//
//  Created by ran on 14-8-21.
//  Copyright (c) 2014年 rannie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MIFactory)

+ (UIButton *)mi_buttonWithIcon:(NSString *)icon pressedIcon:(NSString *)pressedIcon target:(id)target action:(SEL)selector;

@end
