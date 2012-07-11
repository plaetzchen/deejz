//
//  UIBarButtonItem+BackButton.h
//  deejz
//
//  Created by Philip Brechler on 08.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomImageButton)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;


@end
