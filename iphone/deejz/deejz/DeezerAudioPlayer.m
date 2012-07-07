#import "DeezerAudioPlayer.h"
#import "PlayerFactory.h"
#import "DeezerSession.h"

@implementation DeezerAudioPlayer

@synthesize delegate = _delegate;

- (id)init {
    if (self = [super init]) {
        _deezerPlayer = [[PlayerFactory createPlayerWithNetworkType:NetWork_WIFI_AND_3G
                                          andBufferProgressInterval:10.f] retain];
        [_deezerPlayer setPlayerDelegate:self];
        [_deezerPlayer setBufferDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [_deezerPlayer release];
    [super dealloc];
}

- (void)initPlayerForTrackWithDeezerId:(NSString*)trackid stream:(NSString*)stream forUserWithToken:(NSString*)token andId:(NSString*)userId {
    [_deezerPlayer preparePlayerForTrackWithDeezerId:trackid stream:stream andDeezerConnect:[[DeezerSession sharedSession] deezerConnect]];
}

- (void)initPlayerForPreviewWithUrl:(NSString*)url andTrackId:(NSString*)trackId {
    [_deezerPlayer preparePlayerForPreviewWithURL:url trackID:trackId andDeezerConnect:[[DeezerSession sharedSession] deezerConnect]];
}

- (void)initPlayerForRadioWithDeezerId:(NSString*)trackid stream:(NSString*)stream {
    [_deezerPlayer preparePlayerForTrackWithDeezerId:trackid stream:stream andDeezerConnect:[[DeezerSession sharedSession] deezerConnect]];
}


- (DeezerPlayerState)playerState {
    return [_deezerPlayer getCurrentPlayerState];
}

- (long)trackDuration {
    return [_deezerPlayer trackDuration];
}

- (float)progress {
    return [_deezerPlayer playerProgress];
}

- (void)setProgress:(CGFloat)progress {
    [_deezerPlayer setPlayerProgress:progress];
}

- (void)play {
    [_deezerPlayer play];
}

- (void)pause {
    [_deezerPlayer pause];
}

- (void)stop {
    [_deezerPlayer stop];
}

- (int)timePosition {
    return [_deezerPlayer playerTimePosition];
}

#pragma mark - PlayerDelegate

- (void)player:(PlayerFactory*)player stateChanged:(DeezerPlayerState)playerState {
   if ([_delegate respondsToSelector:@selector(playerStateChanged:)]) {
        [_delegate playerStateChanged:playerState];
    }
}

- (void)player:(PlayerFactory*)player timeChanged:(long)time {
    //NSLog(@"[Debug][DeezerAudioPlayer] player progress -> %lu", progress);
//    if ([_delegate respondsToSelector:@selector(playProgressChanged:)]) {
//        [_delegate playerProgressChanged:playerProgress];
//    }
}

- (void)player:(PlayerFactory*)player didFailWithError:(NSError*)error {
    //NSLog(@"[Debug][DeezerAudioPlayer] player didFailWithError -> error %@", error);
}

#pragma mark - BufferDelegate

- (void)bufferStateChanged:(BufferState)bufferState {
    if ([_delegate respondsToSelector:@selector(buffer:stateChanged:)]) {
        [_delegate bufferStateChanged:bufferState];
    }
    if (bufferState == BufferState_Started) {
        [_deezerPlayer play];
    }
    else if (bufferState == BufferState_Stopped) {
    }
}

- (void)bufferProgressChanged:(float)bufferProgress {
    if ([_delegate respondsToSelector:@selector(bufferProgressChanged:)]) {
        [_delegate bufferProgressChanged:bufferProgress];
    }
}

- (void)bufferDidFailWithError:(NSError*)error {
//    NSLog(@"[Debug][DeezerAudioPlayer] bufferDidFailWithError -> error %@", error);
}

- (void)trackDurationDidChange:(long)trackDuration {
    if ([_delegate respondsToSelector:@selector(trackDurationDidChange:)]) {
        [_delegate trackDurationDidChange:trackDuration];
    }
}

////////////////////////////////////////////
////        SINGLETON
///////////////////////////////////////////

#pragma mark - Singleton methods

static DeezerAudioPlayer* _sharedSessionManager = nil;

+ (DeezerAudioPlayer*)sharedSession {
    if (_sharedSessionManager == nil) {
        _sharedSessionManager = [[super allocWithZone:NULL] init];
    }
    return _sharedSessionManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedSession] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
