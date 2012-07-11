//
//  ReceiverTableHeaderView.h
//  deejz
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverTableHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (atomic) int duration;
- (void)setUpForArtist:(NSString *)artist title:(NSString *)title andDuration:(int)time;
- (void)updateTime:(int)time;

@end
