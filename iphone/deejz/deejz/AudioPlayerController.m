#import "AudioPlayerController.h"
#import "UIImageView+AFNetworking.h"
#import "JSONKit.h"
#import "DeezerTrack.h"
#import "DeezerArtist.h"
#import "DeezerAudioPlayer.h"

#define kPlay_image_normal          [UIImage imageNamed:@"Player_Play_Normal.png"]
#define kPlay_image_highlighted     [UIImage imageNamed:@"Player_Play_Highlighted.png"]
#define kPause_image_normal         [UIImage imageNamed:@"Player_Pause_Normal.png"]
#define kPause_image_highlighted    [UIImage imageNamed:@"Player_Pause_Highlighted.png"]

@interface AudioPlayerController ()
- (void)setTrack:(DeezerTrack*)track;
- (void)updatePlayPauseButton;
@end

@implementation AudioPlayerController

- (id)initWithTrackId:(NSString*)trackID title:(NSString*)title artistName:(NSString*)artistName andCover:(NSString*)cover {
    NSString* nibName;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        nibName = @"AudioPlayerController_iPhone";
    } else {
        nibName = @"AudioPlayerController_iPad";
    }
    self = [super initWithNibName:nibName bundle:nil];
    
    if (self) {
        _trackID = [trackID copy];
        _trackName = [title copy];
        _artistName = [artistName copy];
        _cover = [cover copy];
        _btnActionIsPlay = NO;
    }
    
    return self;
}

- (void)dealloc {
    [_coverImageView release];
    [_nameLabel release];
    [_artistNameLabel release];
    [_playButton release];
    [_progressSliderView release];
    
    [_trackID release];
    [_trackName release];
    [_artistName release];
    [_cover release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_nameLabel setText:_trackName];
    [_artistNameLabel setText:_artistName];
    [_coverImageView setImageWithURL:[NSURL URLWithString:_cover]];
    [_progressSliderView setDelegate:self];
    [self updatePlayPauseButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[DeezerSession sharedSession] setRequestDelegate:self];
    [[DeezerSession sharedSession] requestTrack:_trackID];
    
    [[DeezerAudioPlayer sharedSession] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DeezerAudioPlayer sharedSession] setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;

}

- (void)setTrack:(DeezerTrack*)track {
    [_nameLabel setText:[track title]];
    [_artistNameLabel setText:[[track artist] name]];
}


#pragma mark - DeezerSessionRequestDelegate

- (void)deezerSessionRequestDidReceiveResponse:(NSData *)data {
    NSDictionary* dictionary = [data objectFromJSONData];

    DeezerTrack* track = [[DeezerTrack alloc] initWithDictionary:dictionary];
    [self setTrack:track];
    
    NSString* stream = [dictionary objectForKey:@"stream"];
    
    if ([track isReadable] && [stream isKindOfClass:[NSString class]]) {
        [[DeezerAudioPlayer sharedSession] initPlayerForTrackWithDeezerId:[track deezerID]
                                                                   stream:stream
                                                         forUserWithToken:[[[DeezerSession sharedSession] deezerConnect] accessToken]
                                                                    andId:[[[DeezerSession sharedSession] deezerConnect] userId]];
    } else {
        [[DeezerAudioPlayer sharedSession] initPlayerForPreviewWithUrl:[track preview]
                                                            andTrackId:[track deezerID]];
    }
    [track release];
}

- (void)deezerSessionRequestDidFailWithError:(NSError*)error {
    NSLog(@"Request failed : %@", [error description]);
}

#pragma mark - Player

- (IBAction)onPlayButtonPushed:(id)sender {
    _playerState = [[DeezerAudioPlayer sharedSession] playerState];
    switch (_playerState) {
        case DeezerPlayerState_Initialized:
            break;
        case DeezerPlayerState_Ready:
            break;
        case DeezerPlayerState_Playing:
            [[DeezerAudioPlayer sharedSession] pause];
            break;
        case DeezerPlayerState_Paused:
            [[DeezerAudioPlayer sharedSession] play];
            break;
        case DeezerPlayerState_WaitingForData:
            break;
        case DeezerPlayerState_Stopped:
            break;
        case DeezerPlayerState_Finished:
            break;
    }
}

#pragma mark - DeezerAudioPlayerDelegate

- (void)bufferStateChanged:(BufferState)bufferState {
    [_progressSliderView setDuration:[[DeezerAudioPlayer sharedSession] trackDuration]];
}

- (void)playerStateChanged:(DeezerPlayerState)playerState {
    switch (playerState) {
        case DeezerPlayerState_Initialized :
            break;
        case DeezerPlayerState_Ready :
            break;
        case DeezerPlayerState_Playing :
            _btnActionIsPlay = NO;
            [_progressSliderView startTimer];
            break;
        case DeezerPlayerState_Paused :
            [_progressSliderView pauseTimer];
            _btnActionIsPlay = YES;
            break;
        case DeezerPlayerState_WaitingForData :
            break;
        case DeezerPlayerState_Stopped :
        case DeezerPlayerState_Finished :
            [_progressSliderView pauseTimer];
            _btnActionIsPlay = YES;
            break;
            break;
    }
    [self updatePlayPauseButton];
}

#pragma mark - DeezerAudioPlayerDelegate

- (void)bufferProgressChanged:(float)bufferProgress {
    [_progressSliderView setBufferProgress:bufferProgress];
    [_progressSliderView setDuration:[[DeezerAudioPlayer sharedSession] trackDuration]];
}

- (void)playerProgressChanged:(float)playerProgress {
    DeezerAudioPlayer* player = [DeezerAudioPlayer sharedSession];
    
    [_progressSliderView setDuration:[player trackDuration]];
    [_progressSliderView setPlayProgress:(playerProgress / [player trackDuration])];
}

- (void)trackDurationDidChange:(long)trackDuration {
    [_progressSliderView setDuration:trackDuration];
}

#pragma mark - Play/Pause btn

//
// Change image to Pause.
//
- (void)activatePauseButton {
	[_playButton setImage:kPause_image_normal forState:UIControlStateNormal];
	[_playButton setImage:kPause_image_highlighted forState:UIControlStateHighlighted];
}


//
// Change image to Play.
//
- (void)activatePlayButton {
	[_playButton setImage:kPlay_image_normal forState:UIControlStateNormal];
	[_playButton setImage:kPlay_image_highlighted forState:UIControlStateHighlighted];
}


- (void)updatePlayPauseButton {
    if (_btnActionIsPlay) {
        [self activatePlayButton];
    }
    else {
        [self activatePauseButton];
    }
}

#pragma mark - PlayerAndBufferSliderDelegate

- (void)changePlayProgress:(float)progress {
    [[DeezerAudioPlayer sharedSession] setProgress:progress];
}

@end
