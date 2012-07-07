#import <Foundation/Foundation.h>

@class PlayerFactory;

typedef enum {
	DeezerPlayerState_Initialized       = 0,
    DeezerPlayerState_Ready             = 1,
	DeezerPlayerState_Playing           = 2,
	DeezerPlayerState_Paused            = 3,
    DeezerPlayerState_WaitingForData    = 4,
    DeezerPlayerState_Finished          = 5,
    DeezerPlayerState_Stopped           = 6,
} DeezerPlayerState;


@protocol PlayerDelegate <NSObject>

@optional

- (void)player:(PlayerFactory*)player stateChanged:(DeezerPlayerState)playerState;
- (void)player:(PlayerFactory*)player timeChanged:(long)time;
- (void)player:(PlayerFactory*)player didFailWithError:(NSError*)error;

@end



