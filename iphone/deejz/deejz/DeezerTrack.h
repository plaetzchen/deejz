/*
 * http://www.deezer.com/fr/developers/simpleapi/track
 */

#import "DeezerItem.h"

@class DeezerArtist;
@class DeezerAlbum;

@interface DeezerTrack : DeezerItem {
    BOOL            _readable;  // YES if the track is readable in the player for the current user
    NSString*       _title;     // The track's title
    NSString*       _link;      // The url of the track on Deezer
    int             _duration;  // The track's duration in seconds
    int             _rank;      // The track's Deezer rank
    NSString*       _preview;   // The url of track's preview file. This file contains the first 30 seconds of the track
    DeezerArtist*   _artist;    // The track's artist
    DeezerAlbum*    _album;     // The track's album
}

@property (nonatomic, getter = isReadable) BOOL readable;
@property (nonatomic, readonly) NSString*       title;
@property (nonatomic, readonly) NSString*       link;
@property (nonatomic, readonly) int             duration;
@property (nonatomic, readonly) int             rank;
@property (nonatomic, readonly) NSString*       preview;
@property (nonatomic, readonly) DeezerArtist*   artist;
@property (nonatomic, readonly) DeezerAlbum*    album;

@end
