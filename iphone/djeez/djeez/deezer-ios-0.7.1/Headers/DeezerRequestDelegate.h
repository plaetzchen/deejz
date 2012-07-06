#import <Foundation/Foundation.h>

@class DeezerRequest;

/**
 * Enum to describe the request's response format.
 */
typedef enum {
	ResponseFormat_JSON  = 0,
	ResponseFormat_JSONP = 1,
	ResponseFormat_XML   = 2,
	ResponseFormat_PHP   = 3
} ResponseFormat;

/**
 * Enum to describe the http request's type.
 */
typedef enum {
	HttpMethod_GET      = 0,
	HttpMethod_POST     = 1,
	HttpMethod_DELETE   = 2,
} HttpMethod;



@protocol DeezerRequestDelegate <NSObject>

@required
- (void)request:(DeezerRequest *)request didReceiveResponse:(NSData *)response;
- (void)request:(DeezerRequest *)request didFailWithError:(NSError *)error;

@optional
- (void)requestDidStartLoading:(DeezerRequest *)request;

@end
