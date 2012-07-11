//
//  ReceiverTablePlayerSectionHeader.m
//  deejz
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import "ReceiverTablePlayerSectionHeader.h"

@implementation ReceiverTablePlayerSectionHeader
@synthesize pausePlayButton,delegate,playing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.playing = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)fwdTapped:(id)sender {
    [delegate receiverTablePlayerDidFwd];
}

- (IBAction)pausePlayTapped:(id)sender {
    if (self.playing){
        [self.pausePlayButton setBackgroundImage:[UIImage imageNamed:@"playlist_ctrl_btn_play.png"] forState:UIControlStateNormal];
        self.playing = NO;
    }else {
        [self.pausePlayButton setBackgroundImage:[UIImage imageNamed:@"playlist_ctrl_btn_pause.png"] forState:UIControlStateNormal];
        self.playing = YES;
    }
    [delegate receiverTablePlayerDidPlayPause];
}

- (IBAction)stopTapped:(id)sender {
    [delegate receiverTablePlayerDidStop];
}
- (IBAction)facebookTapped:(id)sender {
    [delegate receiverTablePlayerDidFaceBook];
}
@end
