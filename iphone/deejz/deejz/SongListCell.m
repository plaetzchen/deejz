//
//  SongListCell.m
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import "SongListCell.h"

@implementation SongListCell
@synthesize titleLabel;
@synthesize artistLabel;
@synthesize coverImageView;
@synthesize playPauseButton;
@synthesize previewUrl;
@synthesize deezerId;
@synthesize trackSelected;
@synthesize theBackgroundImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)preparePlayerWithURL:(NSString *)url AndID:(NSString *)theId{
    self.previewUrl = url;
    self.deezerId = theId;
}
- (IBAction)playPauseTapped:(id)sender {
    if ([[DeezerAudioPlayer sharedSession] playerState] == DeezerPlayerState_Playing){
        [[DeezerAudioPlayer sharedSession] stop];
    }
    else {
            [[DeezerAudioPlayer sharedSession] initPlayerForPreviewWithUrl:self.previewUrl andTrackId:self.deezerId];
            [[DeezerAudioPlayer sharedSession] setDelegate:self];
        [[DeezerAudioPlayer sharedSession] play];
    }
}

#pragma mark DeezerAudioPlayerDelegegate

- (void)bufferStateChanged:(BufferState)bufferState {
    
}
- (void)playerStateChanged:(DeezerPlayerState)playerState {
    
    switch (playerState) {
        case DeezerPlayerState_Playing:
            NSLog(@"Playing");
            [self.playPauseButton setImage:[UIImage imageNamed:@"songlist_pause_btn"] forState:UIControlStateNormal];
            break;
        case DeezerPlayerState_Paused:
            NSLog(@"Paused");
            [self.playPauseButton setImage:[UIImage imageNamed:@"songlist_play_btn"] forState:UIControlStateNormal];          
            break;
        case DeezerPlayerState_Stopped:
            NSLog(@"Stopped");
            [self.playPauseButton setImage:[UIImage imageNamed:@"songlist_play_btn"] forState:UIControlStateNormal];       
            break;
        case DeezerPlayerState_Finished:
            NSLog(@"Finished");
            [self.playPauseButton setImage:[UIImage imageNamed:@"songlist_play_btn"] forState:UIControlStateNormal];    
            break;
        case DeezerPlayerState_Ready:
            NSLog(@"Ready");
            [self.playPauseButton setImage:[UIImage imageNamed:@"songlist_play_btn"] forState:UIControlStateNormal];
            break;
        case DeezerPlayerState_Initialized:
            NSLog(@"Itialized");
            break;
        case DeezerPlayerState_WaitingForData:
            NSLog(@"WaitingForData");
            break;
        default:
            break;
    }
}
- (void)bufferProgressChanged:(float)bufferProgress {
    
}
- (void)playerProgressChanged:(float)playerProgress {
    
}

- (void)trackDurationDidChange:(long)trackDuration {
    
}

- (void)setTheCellSelected:(BOOL)selected{
    self.trackSelected = selected;
    if (selected){
        self.theBackgroundImage.image = [UIImage imageNamed:@"songlist_cell_bg_selected"];
    }
    else {
        self.theBackgroundImage.image = [UIImage imageNamed:@"songlist_cell_bg"];
    }

}

@end
