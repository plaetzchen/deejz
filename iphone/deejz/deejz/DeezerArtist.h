/*
 * http://www.deezer.com/fr/developers/simpleapi/artist
 */

#import "DeezerItem.h"

@interface DeezerArtist : DeezerItem {
    NSString*   _name;      // The artist's name
    NSString*   _link;      // The url of the artist on Deezer
    NSString*   _picture;	// The url of the artist picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'
    int         _nbAlbums;	// The number of artist's albums
    int         _nbFans;     // The number of artist's fans
}

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* link;
@property (nonatomic, readonly) NSString* picture;
@property (nonatomic, readonly) int       nbAlbums;
@property (nonatomic, readonly) int       nbFans;

@end
