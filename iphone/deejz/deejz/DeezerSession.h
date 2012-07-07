#import <Foundation/Foundation.h>
#import "DeezerConnect.h"

#define kDeezerAppId @"103901"

#define kDeezerPermissions nil

@class DeezerUser;

@protocol DeezerSessionConnectionDelegate;
@protocol DeezerSessionRequestDelegate;

@interface DeezerSession : NSObject <DeezerSessionDelegate, DeezerRequestDelegate>

@property (nonatomic, assign)   id<DeezerSessionConnectionDelegate> connectionDelegate;
@property (nonatomic, assign)   id<DeezerSessionRequestDelegate>    requestDelegate;
@property (nonatomic, readonly) DeezerConnect* deezerConnect;
@property (nonatomic, retain)   DeezerUser* currentUser;

+ (DeezerSession*)sharedSession;

#pragma mark - Connection
- (void)connectToDeezerWithPermissions:(NSArray*)permissionsArray;
- (void)disconnect;
- (BOOL)isSessionValid;

#pragma mark - Requests
/************\
|* Requests *|
\************/

- (void)requestWithURLString:(NSString*)urlString;
- (void)requestItemNamed:(NSString*)itemName;
- (void)requestItemType:(NSString*)itemType withDeezerID:(NSString*)deezerID;
- (void)requestConnectionType:(NSString*)connectionType forItemType:(NSString*)itemType withDeezerID:(NSString*)deezerID;

- (void)requestTrack:(NSString*)deezerID;
- (void)requestRadioForListening:(NSString*)radioId;
- (void)requestEditorials;
- (void)requestRadios;

#pragma mark - Search requests
/**********\
|* Search *|
\**********/

- (void)searchArtist:(NSString*)artistName;
- (void)searchAlbum:(NSString*)albumName;
- (void)searchTrack:(NSString*)trackName;

#pragma mark - Action requests
/***********\
|* Actions *|
\***********/

#pragma mark POST
/* POST */

#pragma mark Folder
- (void)renameFolder:(NSString*)folderId newTitle:(NSString*)newTitle;
- (void)addPlaylist:(NSString*)playlistId toFolder:(NSString*)folderId;
- (void)addAlbum:(NSString*)albumId toFolder:(NSString*)folderId;

#pragma mark Playlist
- (void)renamePlaylist:(NSString*)playlistId newTitle:(NSString*)newTitle;
- (void)addComment:(NSString*)comment toPlaylist:(NSString*)playlistId;
- (void)addTrack:(NSString*)trackId toPlaylist:(NSString*)playlistId;
- (void)addTracks:(NSArray*)tracksIds toPlaylist:(NSString*)playlistId;
- (void)reorderTracks:(NSArray*)tracksIds inPlaylist:(NSString*)playlistId;

#pragma mark User
- (void)addFavoriteAlbum:(NSString*)albumId toUser:(NSString*)userId;
- (void)addFavoriteArtist:(NSString*)artistId toUser:(NSString*)userId;
- (void)createFolderNamed:(NSString*)folderName forUser:(NSString*)userId;
- (void)createPlaylistNamed:(NSString*)playlistName forUser:(NSString*)userId;
//- (void)uploadSong??

#pragma mark DELETE
/* DELETE */

#pragma mark Folder
- (void)deleteFolder:(NSString*)folderId;
- (void)removePlaylist:(NSString*)playlistId fromFolder:(NSString*)folderId;
- (void)removeAlbum:(NSString*)albumId fromFolder:(NSString*)folderId;

#pragma mark Playlist
- (void)deletePlaylist:(NSString*)playlistId;
- (void)removeTrack:(NSString*)trackId fromPlaylist:(NSString*)playlistId;
- (void)removeTracks:(NSArray*)tracksIds fromPlaylist:(NSString*)playlistId;

#pragma mark User
- (void)removeFavoriteAlbum:(NSString*)albumId forUser:(NSString*)userId;
- (void)removeFavoriteArtist:(NSString*)artistId forUser:(NSString*)userId;

@end


@protocol DeezerSessionConnectionDelegate <NSObject>

@optional
- (void)deezerSessionDidConnect;
- (void)deezerSessionConnectionDidFailWithError:(NSError*)error;
- (void)deezerSessionDidDisconnect;

@end


@protocol DeezerSessionRequestDelegate <NSObject>

@optional
- (void)deezerSessionRequestDidReceiveResponse:(NSData*)data;
- (void)deezerSessionRequestDidFailWithError:(NSError*)error;

@end