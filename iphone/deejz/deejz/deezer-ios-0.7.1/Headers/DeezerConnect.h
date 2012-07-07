#import <Foundation/Foundation.h>
#import "DeezerRequestDelegate.h"
#import "DeezerOAuthDelegate.h"

@protocol DeezerSessionDelegate;
    
@interface DeezerConnect : NSObject <DeezerOAuthDelegate, DeezerRequestDelegate>  {
    NSString*           _appId; 
}

@property (nonatomic, assign)   id<DeezerSessionDelegate>   sessionDelegate;
@property (nonatomic, copy)     NSString*                   accessToken;
@property (nonatomic, copy)     NSString*                   appId;
@property (nonatomic, copy)     NSString*                   userId;
@property (nonatomic, retain)   NSDate*                     expirationDate;


- (id)initWithAppId:(NSString *)appId andDelegate:(id<DeezerSessionDelegate>)delegate;

- (void)authorize:(NSArray *)permissions;

- (void)logout;

- (BOOL)isSessionValid;


////////////
//Requests
////////////

/**
 * Create a DeezerRequest
 * @param servicePath
 *          The request URL, ex: @"user/me"
 *
 * @param params
 *          The parameter(s) of the request. May be nil, if there is no parameter.
 *
 * @param httpMethod
 *          The type of http method (GET, POST, DELETE).
 *          Check-out enum type HttpMethod into DeezerRequestDelegate.h.
 *
 * @param responseFormat
 *          The output format type (JSON, XML...)
 *          Check-out enum type ResponseFormat into DeezerRequestDelegate.h.
 *
 * @param delegate
 *          Callback interface for notifying the application when the request is finished.
 *          (succeeded or failed).
 *
 * @return DeezerRequest*
 *          A pointer to DeezerRequest object.
 */
- (DeezerRequest*)createRequestWithServicePath:(NSString*)servicePath
                                        params:(NSDictionary*)params
                                    httpMethod:(HttpMethod)httpMethod
                                responseFormat:(ResponseFormat)responseFormat
                                      delegate:(id<DeezerRequestDelegate>)delegate;

/*
 * Same as above with responseFormat set to JSON
 */
- (DeezerRequest*)createRequestWithServicePath:(NSString*)servicePath
                                        params:(NSDictionary*)params
                                    httpMethod:(HttpMethod)httpMethod
                                      delegate:(id<DeezerRequestDelegate>)delegate;
/*
 * Same as above with httpMethod set to GET
 */
- (DeezerRequest*)createRequestWithServicePath:(NSString*)servicePath
                                        params:(NSDictionary*)params
                                      delegate:(id<DeezerRequestDelegate>)delegate;


/**
 * Create a DeezerRequest
 * @param requestURL
 *          The request URL
 *
 * @param params
 *          The parameter(s) of the request. May be nil, if there is no parameter.
 *
 * @param httpMethod
 *          The type of http method (GET, POST, DELETE).
 *          Check-out enum type HttpMethod into DeezerRequestDelegate.h.
 *
 * @param responseFormat
 *          The output format type (JSON, XML...)
 *          Check-out enum type ResponseFormat into DeezerRequestDelegate.h.
 *
 * @param delegate
 *          Callback interface for notifying the application when the request is finished.
 *          (succeeded or failed).
 *
 * @return DeezerRequest*
 *          A pointer to DeezerRequest object.
 */
- (DeezerRequest*)createRequestWithUrl:(NSString*)url
                                params:(NSDictionary*)params
                            httpMethod:(HttpMethod)httpMethod
                        responseFormat:(ResponseFormat)responseFormat
                              delegate:(id<DeezerRequestDelegate>)delegate;

/*
 * Same as above with responseFormat set to JSON
 */
- (DeezerRequest*)createRequestWithUrl:(NSString*)url
                                params:(NSDictionary*)params
                            httpMethod:(HttpMethod)httpMethod
                              delegate:(id<DeezerRequestDelegate>)delegate;

/*
 * Same as above with httpMethod set to GET
 */
- (DeezerRequest*)createRequestWithUrl:(NSString*)url
                                params:(NSDictionary*)params
                              delegate:(id<DeezerRequestDelegate>)delegate;

/**
 * Use this method to launch a synchronous request.
 * @param syncRequest
 *          The request to launch.
 *
 */
- (void)launchSyncRequest:(DeezerRequest*)request;

/**
 * Use this method to launch an ASynchronous request.
 * @param syncRequest
 *          The request to launch.
 *
 */
- (void)launchAsyncRequest:(DeezerRequest*)request;

/**
 * Cancel  an asyn request
 * @param syncRequest
 *          The request to cancel.
 *
 */
- (void)cancel:(DeezerRequest*)request;

@end

////////////////////////////////////////////////////////////////////////////////

/**
 * Your application should implement this delegate to receive session callbacks.
 */
@protocol DeezerSessionDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in.
 * Token and expiration date are automatically set to the DeezerConnect object
 */
- (void)deezerDidLogin;

/**
 * Called when the user dismissed the OAuthView without logging in.
 */
- (void)deezerDidNotLogin:(BOOL)cancelled;

/**
 * Called when the user logged out.
 */
- (void)deezerDidLogout;


@end
