//
//  ReceiverTableHeaderView.m
//  deejz
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import "ReceiverTableHeaderView.h"

@implementation ReceiverTableHeaderView
@synthesize artistLabel;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize progressView;
@synthesize duration;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setUpForArtist:(NSString *)artist title:(NSString *)title andDuration:(int)time {
    self.artistLabel.text = artist;
    self.titleLabel.text = title;
    self.timeLabel.text = [self getTimeStringFromSeconds:time];
    self.duration = time;
    [self.progressView setProgress:0];
}


- (void)updateTime:(int)time {
    CGFloat timePostion = (CGFloat)time / (CGFloat)self.duration;
    
    [self.progressView setProgress:timePostion];
    self.timeLabel.text = [NSString stringWithFormat:@"%@//%@",[self getTimeStringFromSeconds:time],[self getTimeStringFromSeconds:self.duration]];
}

- (NSString*)getTimeStringFromSeconds:(UInt32)seconds {
    if (seconds == 0) {
        return @"--:--";
    }
    UInt32 minutes = seconds / 60;
    seconds -= (minutes * 60);
    return [NSString stringWithFormat:@"%d:%.2d", minutes, seconds];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
