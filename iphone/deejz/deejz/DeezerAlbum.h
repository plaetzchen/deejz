/*
 * http://www.deezer.com/fr/developers/simpleapi/album
 */

#import "DeezerItem.h"

@class DeezerArtist;

@interface DeezerAlbum : DeezerItem {
    NSString*       _title;     // The album's title
    NSString*       _link;      // The url of the album on Deezer
    NSString*       _cover;     // The url of the album's cover. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'
    DeezerArtist*   _artist;    // The album's artist 
    NSArray*        _tracks;    // List of album's tracks
}

@property (nonatomic, readonly) NSString*       title;
@property (nonatomic, readonly) NSString*       link;
@property (nonatomic, readonly) NSString*       cover;
@property (nonatomic, readonly) DeezerArtist*   artist;
@property (nonatomic, readonly) NSArray*        tracks;

@end
