//
//  ReceiverTablePlayerSectionHeader.h
//  deejz
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiverTablePlayerSectionHeaderDelegate.h"

@interface ReceiverTablePlayerSectionHeader : UIView
- (IBAction)fwdTapped:(id)sender;
- (IBAction)pausePlayTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)facebookTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *pausePlayButton;
@property (strong, atomic) id<ReceiverTablePlayerSectionHeaderDelegate>delegate;
@property (atomic)BOOL playing;

@end
