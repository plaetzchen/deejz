#import <Foundation/Foundation.h>

@class DeezerOAuthView;

@protocol DeezerOAuthDelegate <NSObject>

@optional
- (void)deezerOAuthSucceededWithToken:(NSString*)token expirationDate:(NSDate*)expirationDate;
- (void)deezerOAuthDidNotSucceed:(BOOL)cancelled;
- (void)deezerOAuth:(DeezerOAuthView*)deezerOAuth didFailWithError:(NSError *)error;

@end
