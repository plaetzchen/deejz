/*
 * http://www.deezer.com/fr/developers/simpleapi/playlist
 */

#import "DeezerItem.h"

@class DeezerUser;

@interface DeezerPlaylist : DeezerItem {
    NSString*   _title;    // The playlist's title
    NSString*   _link;     // The url of the playlist on Deezer
    NSString*   _picture;  // The url of the playlist's cover. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'
    DeezerUser* _creator;  // The playlist's creator (containing deezerID)
    NSArray*    _tracks;   // The playlist's list of tracks
}

@property (nonatomic, readonly) NSString*   title;
@property (nonatomic, readonly) NSString*   link;
@property (nonatomic, readonly) NSString*   picture;
@property (nonatomic, readonly) DeezerUser* creator;
@property (nonatomic, readonly) NSArray*    tracks;

@end
