//
//  UIBarButtonItem+BackButton.m
//  deejz
//
//  Created by Philip Brechler on 08.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import "UIBarButtonItem+CustomImageButton.h"

@implementation UIBarButtonItem (CustomImageButton)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
