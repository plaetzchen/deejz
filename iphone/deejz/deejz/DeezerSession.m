#import "DeezerSession.h"
#import "DeezerUser.h"
#import "JSONKit.h"

#define DEEZER_TOKEN_KEY @"DeezerTokenKey"
#define DEEZER_EXPIRATION_DATE_KEY @"DeezerExpirationDateKey"
#define DEEZER_USER_ID_KEY @"DeezerUserId"

@interface DeezerSession (Token_methods)
- (void)retrieveTokenAndExpirationDate;
- (void)saveToken:(NSString*)token andExpirationDate:(NSDate*)expirationDate forUserId:(NSString*)userId;
- (void)clearTokenAndExpirationDate;
@end

@interface DeezerSession (Requests_methods)
@end

@implementation DeezerSession

@synthesize connectionDelegate = _connectionDelegate;
@synthesize requestDelegate = _requestDelegate;
@synthesize deezerConnect = _deezerConnect;
@synthesize currentUser = _currentUser;

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _deezerConnect = [[DeezerConnect alloc] initWithAppId:kDeezerAppId
                                                  andDelegate:self];
        [self retrieveTokenAndExpirationDate];
    }
    return self;
}

- (void)dealloc {
    [_deezerConnect release];
    [_currentUser release];
    [super dealloc];
}

#pragma mark - Connection
/**************\
|* Connection *|
\**************/

// See http://www.deezer.com/fr/developers/simpleapi/permissions
// for a description of the permissions
- (void)connectToDeezerWithPermissions:(NSArray*)permissionsArray {
    [_deezerConnect authorize:permissionsArray];
}

- (void)disconnect {
    [_deezerConnect logout];
}

- (BOOL)isSessionValid {
    return [_deezerConnect isSessionValid];
}

#pragma mark - Token
// The token needs to be saved on the device
- (void)retrieveTokenAndExpirationDate {
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [_deezerConnect setAccessToken:[standardUserDefaults objectForKey:DEEZER_TOKEN_KEY]];
    [_deezerConnect setExpirationDate:[standardUserDefaults objectForKey:DEEZER_EXPIRATION_DATE_KEY]];
    [_deezerConnect setUserId:[standardUserDefaults objectForKey:DEEZER_USER_ID_KEY]];
}

- (void)saveToken:(NSString*)token andExpirationDate:(NSDate*)expirationDate forUserId:(NSString*)userId {
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:token forKey:DEEZER_TOKEN_KEY];
    [standardUserDefaults setObject:expirationDate forKey:DEEZER_EXPIRATION_DATE_KEY];
    [standardUserDefaults setObject:userId forKey:DEEZER_USER_ID_KEY];
    [standardUserDefaults synchronize];
}

- (void)clearTokenAndExpirationDate {
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:DEEZER_TOKEN_KEY];
    [standardUserDefaults removeObjectForKey:DEEZER_EXPIRATION_DATE_KEY];
    [standardUserDefaults removeObjectForKey:DEEZER_USER_ID_KEY];
    [standardUserDefaults synchronize];
}

#pragma mark - DeezerSessionDelegate

- (void)deezerDidLogin {
    NSLog(@"Deezer did login");
    [self saveToken:[_deezerConnect accessToken] andExpirationDate:[_deezerConnect expirationDate] forUserId:[_deezerConnect userId]];
    if ([_connectionDelegate respondsToSelector:@selector(deezerSessionDidConnect)]) {
        [_connectionDelegate deezerSessionDidConnect];
    }
}

- (void)deezerDidNotLogin:(BOOL)cancelled {
    NSLog(@"Deezer Did not login %@", cancelled ? @"Cancelled" : @"Not Cancelled");
}

- (void)deezerDidLogout {
    NSLog(@"Deezer Did logout");
    [self clearTokenAndExpirationDate];
    if ([_connectionDelegate respondsToSelector:@selector(deezerSessionDidDisconnect)]) {
        [_connectionDelegate deezerSessionDidDisconnect];
    }
}

#pragma mark - Requests
/************\
|* Requests *|
\************/
// See http://www.deezer.com/fr/developers/simpleapi
// for the requests documentation

- (void)requestWithURLString:(NSString*)urlString {
    NSLog(@"Request - URL : %@", urlString);
    DeezerRequest* request = [_deezerConnect createRequestWithUrl:urlString
                                                           params:nil
                                                       httpMethod:HttpMethod_GET
                                                   responseFormat:ResponseFormat_JSON
                                                         delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

- (void)requestItemNamed:(NSString*)itemName {
    NSLog(@"Request - ServicePath : %@", itemName);
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:itemName
                                                                   params:nil
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

- (void)requestItemType:(NSString*)itemType withDeezerID:(NSString*)deezerID {
    NSString* servicePath = [NSString stringWithFormat:@"%@/%@", itemType, deezerID];
    NSLog(@"Request - ServicePath : %@", servicePath);
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:servicePath
                                                                   params:nil
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

- (void)requestConnectionType:(NSString*)connectionType forItemType:(NSString*)itemType withDeezerID:(NSString*)deezerID {
    NSString* servicePath = [NSString stringWithFormat:@"%@/%@/%@", itemType, deezerID, connectionType];
    NSLog(@"Request - ServicePath : %@", servicePath);
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:servicePath
                                                                   params:nil 
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

- (void)requestTrack:(NSString*)deezerID {
    [self requestItemType:@"track" withDeezerID:deezerID];
}

- (void)requestRadioForListening:(NSString*)radioId {
    NSString* servicePath = [NSString stringWithFormat:@"%@/%@/%@", @"radio", radioId, @"tracks"];
    NSDictionary* params = [NSDictionary dictionaryWithObject:@"true" forKey:@"next"];
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:servicePath
                                                                   params:params
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

- (void)requestEditorials {
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:@"editorial"
                                                                   params:nil 
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

- (void)requestRadios {
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:@"radio"
                                                                   params:nil 
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

#pragma mark - Search requests
/**********\
|* Search *|
\**********/
// See http://www.deezer.com/fr/developers/simpleapi/search
// for the search documentation

- (void)searchArtist:(NSString*)artistName {
    NSString* servicePath = @"search/artist";
    NSDictionary* param = [NSDictionary dictionaryWithObject:artistName forKey:@"q"];
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:servicePath
                                                                   params:param 
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

- (void)searchAlbum:(NSString*)albumName {
    NSString* servicePath = @"search/album";
    NSDictionary* param = [NSDictionary dictionaryWithObject:albumName forKey:@"q"];
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:servicePath
                                                                   params:param
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

- (void)searchTrack:(NSString*)trackName {
    NSString* servicePath = @"search";
    NSDictionary* param = [NSDictionary dictionaryWithObject:trackName forKey:@"q"];
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:servicePath
                                                                   params:param 
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

#pragma mark - Action requests
/***********\
|* Actions *|
\***********/

#pragma mark -> POST
/* POST */
// See http://www.deezer.com/fr/developers/simpleapi/actions-post
- (void)postActionOnItem:(NSString*)itemName withId:(NSString*)itemId actionName:(NSString*)actionName andParams:(NSDictionary*)params {
    NSArray* array = [NSArray arrayWithObjects:itemName, itemId, actionName, nil];
    NSString* servicePath = [array componentsJoinedByString:@"/"];
    NSLog(@"POST Request : %@ - %@", servicePath, params);
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:servicePath
                                                                   params:params
                                                               httpMethod:HttpMethod_POST
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

#pragma mark --> Folder
- (void)renameFolder:(NSString*)folderId newTitle:(NSString*)newTitle {
    NSDictionary* params = [NSDictionary dictionaryWithObject:newTitle forKey:@"title"];
    [self postActionOnItem:@"folder"
                    withId:folderId
                actionName:nil
                 andParams:params];
}

- (void)addPlaylist:(NSString*)playlistId toFolder:(NSString*)folderId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:playlistId forKey:@"playlist_id"];
    [self postActionOnItem:@"folder"
                    withId:folderId
                actionName:@"items"
                 andParams:params];
}

- (void)addAlbum:(NSString*)albumId toFolder:(NSString*)folderId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:albumId forKey:@"album_id"];
    [self postActionOnItem:@"folder"
                    withId:folderId
                actionName:@"items"
                 andParams:params];
}

#pragma mark Playlist
- (void)renamePlaylist:(NSString*)playlistId newTitle:(NSString*)newTitle {
    NSDictionary* params = [NSDictionary dictionaryWithObject:newTitle forKey:@"title"];
    [self postActionOnItem:@"playlist"
                    withId:playlistId
                actionName:nil
                 andParams:params];
}

- (void)addComment:(NSString*)comment toPlaylist:(NSString*)playlistId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:comment forKey:@"comment"];
    [self postActionOnItem:@"playlist"
                    withId:playlistId
                actionName:@"comments"
                 andParams:params];
}

- (void)addTrack:(NSString*)trackId toPlaylist:(NSString*)playlistId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:trackId forKey:@"songs"];
    [self postActionOnItem:@"playlist"
                    withId:playlistId
                actionName:@"tracks"
                 andParams:params];
}

- (void)addTracks:(NSArray*)tracksIds toPlaylist:(NSString*)playlistId {
    NSString* tracksIdsString = [tracksIds componentsJoinedByString:@","];
    NSDictionary* params = [NSDictionary dictionaryWithObject:tracksIdsString forKey:@"songs"];
    [self postActionOnItem:@"playlist"
                    withId:playlistId
                actionName:@"tracks"
                 andParams:params];
}

- (void)reorderTracks:(NSArray*)tracksIds inPlaylist:(NSString*)playlistId {
    NSString* tracksIdsString = [tracksIds componentsJoinedByString:@","];
    NSDictionary* params = [NSDictionary dictionaryWithObject:tracksIdsString forKey:@"order"];
    [self postActionOnItem:@"playlist"
                    withId:playlistId
                actionName:@"tracks"
                 andParams:params];
}

#pragma mark User
// User
- (void)addFavoriteAlbum:(NSString*)albumId toUser:(NSString*)userId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:albumId forKey:@"album_id"];
    [self postActionOnItem:@"user"
                    withId:userId
                actionName:@"albums"
                 andParams:params];
}

- (void)addFavoriteArtist:(NSString*)artistId toUser:(NSString*)userId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:artistId forKey:@"artist_id"];
    [self postActionOnItem:@"user"
                    withId:userId
                actionName:@"artists"
                 andParams:params];
}

- (void)createFolderNamed:(NSString*)folderName forUser:(NSString*)userId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:folderName forKey:@"title"];
    [self postActionOnItem:@"user"
                    withId:userId
                actionName:@"folders"
                 andParams:params];
}

- (void)createPlaylistNamed:(NSString*)playlistName forUser:(NSString*)userId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:playlistName forKey:@"title"];
    [self postActionOnItem:@"user"
                    withId:userId
                actionName:@"playlists"
                 andParams:params];
}

#pragma mark DELETE
/* DELETE */
// See http://www.deezer.com/fr/developers/simpleapi/actions-delete

- (void)deleteActionOnItem:(NSString*)itemName withId:(NSString*)itemId actionName:(NSString*)actionName andParams:(NSDictionary*)params {
    NSArray* array = [NSArray arrayWithObjects:itemName, itemId, actionName, nil];
    NSString* servicePath = [array componentsJoinedByString:@"/"];
    NSLog(@"DELETE Request : %@ - %@", servicePath, params);
    DeezerRequest* request = [_deezerConnect createRequestWithServicePath:servicePath
                                                                   params:params
                                                               httpMethod:HttpMethod_DELETE
                                                                 delegate:self];
    [_deezerConnect launchAsyncRequest:request];
}

#pragma mark Folder
// Folder
- (void)deleteFolder:(NSString*)folderId {
    [self deleteActionOnItem:@"folder"
                      withId:folderId
                  actionName:nil
                   andParams:nil];
}

- (void)removePlaylist:(NSString*)playlistId fromFolder:(NSString*)folderId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:playlistId forKey:@"playlist_id"];
    [self deleteActionOnItem:@"folder"
                      withId:folderId
                  actionName:@"items"
                   andParams:params];
}

- (void)removeAlbum:(NSString*)albumId fromFolder:(NSString*)folderId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:albumId forKey:@"album_id"];
    [self deleteActionOnItem:@"folder"
                      withId:folderId
                  actionName:@"items"
                   andParams:params];
}

#pragma mark Playlist
// Playlist
- (void)deletePlaylist:(NSString*)playlistId {
    [self deleteActionOnItem:@"playlist"
                      withId:playlistId
                  actionName:nil
                   andParams:nil];
}

- (void)removeTrack:(NSString*)trackId fromPlaylist:(NSString*)playlistId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:trackId forKey:@"songs"];
    [self deleteActionOnItem:@"playlist"
                      withId:playlistId
                  actionName:@"tracks"
                   andParams:params];
}

- (void)removeTracks:(NSArray*)tracksIds fromPlaylist:(NSString*)playlistId {
    NSString* tracksIdsString = [tracksIds componentsJoinedByString:@","];
    NSDictionary* params = [NSDictionary dictionaryWithObject:tracksIdsString forKey:@"songs"];
    [self deleteActionOnItem:@"playlist"
                      withId:playlistId
                  actionName:@"tracks"
                   andParams:params];
}

#pragma mark User
// User
- (void)removeFavoriteAlbum:(NSString*)albumId forUser:(NSString*)userId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:albumId forKey:@"album_id"];
    [self deleteActionOnItem:@"user"
                      withId:userId
                  actionName:@"albums"
                   andParams:params];
}

- (void)removeFavoriteArtist:(NSString*)artistId forUser:(NSString*)userId {
    NSDictionary* params = [NSDictionary dictionaryWithObject:artistId forKey:@"artist_id"];
    [self deleteActionOnItem:@"user"
                      withId:userId
                  actionName:@"artists"
                   andParams:params];
}

#pragma mark - DeezerRequestDelegate

- (void)request:(DeezerRequest *)request didReceiveResponse:(NSData *)data {
    NSLog(@"Response = %@", [data objectFromJSONData]);
    if ([_requestDelegate respondsToSelector:@selector(deezerSessionRequestDidReceiveResponse:)]) {
        [_requestDelegate deezerSessionRequestDidReceiveResponse:data];
    }
}

- (void)request:(DeezerRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Request did fail with error : %@", [error description]);
    if ([_requestDelegate respondsToSelector:@selector(deezerSessionRequestDidFailWithError:)]) {
        [_requestDelegate deezerSessionRequestDidFailWithError:error];
    }
}


#pragma mark - Singleton methods

static DeezerSession* _sharedSessionManager = nil;

+ (DeezerSession*)sharedSession {
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
