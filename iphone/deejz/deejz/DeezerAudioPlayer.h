#import <Foundation/Foundation.h>
#import "PlayerFactory.h"

@protocol DeezerAudioPlayerDelegate;

@interface DeezerAudioPlayer : NSObject<PlayerDelegate, BufferDelegate> {
    PlayerFactory*                  _deezerPlayer;
    id<DeezerAudioPlayerDelegate>	_delegate;
}

@property (nonatomic, assign) id<DeezerAudioPlayerDelegate> delegate;
@property (nonatomic, readonly) DeezerPlayerState playerState;
@property (nonatomic, readonly) long trackDuration;
@property (nonatomic, assign)   float progress;

+ (DeezerAudioPlayer*)sharedSession;

- (void)initPlayerForTrackWithDeezerId:(NSString*)trackid stream:(NSString*)stream forUserWithToken:(NSString*)token andId:(NSString*)userId ;
- (void)initPlayerForPreviewWithUrl:(NSString*)url andTrackId:(NSString*)trackId;
- (void)initPlayerForRadioWithDeezerId:(NSString*)trackid stream:(NSString*)stream;

- (void)play;
- (void)pause;
- (void)stop;

- (int)timePosition;

@end


@protocol DeezerAudioPlayerDelegate <NSObject>
- (void)bufferStateChanged:(BufferState)bufferState;
- (void)playerStateChanged:(DeezerPlayerState)playerState;
- (void)bufferProgressChanged:(float)bufferProgress;
- (void)playerProgressChanged:(float)playerProgress;

- (void)trackDurationDidChange:(long)trackDuration;

@end