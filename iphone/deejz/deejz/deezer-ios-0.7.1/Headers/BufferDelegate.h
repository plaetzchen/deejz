#import <Foundation/Foundation.h>

typedef enum {
	BufferState_Started,
	BufferState_Paused,
	BufferState_Stopped,
	BufferState_Ended,
} BufferState;


@protocol BufferDelegate <NSObject>

@optional

- (void)bufferStateChanged:(BufferState)bufferState;
- (void)bufferProgressChanged:(float)bufferProgress;
- (void)bufferDidFailWithError:(NSError*)error;

@end