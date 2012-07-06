#import <Foundation/Foundation.h>

#import "PlayerDelegate.h"
#import "BufferDelegate.h"

typedef enum {
	Network_WIFI_ONLY,
    NetWork_WIFI_AND_3G,
} Network;

@class DeezerConnect;
@interface PlayerFactory : NSObject {
    id<PlayerDelegate>  _playerDelegate;
    id<BufferDelegate>  _bufferDelegate;
    
    NSString*           _trackId;
    NSString*           _trackStream;    
}

@property (nonatomic, assign) id<PlayerDelegate>  playerDelegate;
@property (nonatomic, assign) id<BufferDelegate>  bufferDelegate;

@property (nonatomic, retain) NSString*         trackId;
@property (nonatomic, retain) NSString*         trackStream;

@property (nonatomic, assign) float playerProgress;
@property (nonatomic, readonly) long playerTimePosition;
@property (nonatomic, readonly) long trackDuration;

+ (PlayerFactory*)createPlayer;
+ (PlayerFactory*)createPlayerWithNetworkType:(Network)network andBufferProgressInterval:(float)progressInterval;


- (void)preparePlayerForTrackWithDeezerId:(NSString*)trackid
                                   stream:(NSString*)stream
                         andDeezerConnect:(DeezerConnect*)dzConnect;


- (void)preparePlayerForPreviewWithURL:(NSString*)urlString
                               trackID:(NSString*)trackID
                      andDeezerConnect:(DeezerConnect*)dzConnect;

- (DeezerPlayerState)getCurrentPlayerState;

- (void)play;
- (void)pause;
- (void)stop;

@end
