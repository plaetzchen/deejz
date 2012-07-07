#import "DictionaryParser.h"

#import "DeezerAlbum.h"
#import "DeezerArtist.h"
#import "DeezerComment.h"
#import "DeezerEditorial.h"
#import "DeezerFolder.h"
#import "DeezerPermission.h"
#import "DeezerPlaylist.h"
#import "DeezerRadio.h"
#import "DeezerTrack.h"
#import "DeezerUser.h"
#import "DeezerURL.h"

@implementation DictionaryParser

+ (DeezerItem*)getItemFromDictionary:(NSDictionary*)dictionary {

    DeezerItem* item;
    NSString* type = [dictionary objectForKey:@"type"];
    
    if ([type isEqualToString:@"album"]) {
        item = [[[DeezerAlbum alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"artist"]) {
        item = [[[DeezerArtist alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"comment"]) {
        item = [[[DeezerComment alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"editorial"]) {
        item = [[[DeezerEditorial alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"folder"]) {
        item = [[[DeezerFolder alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"permission"]) {
        item = [[[DeezerPermission alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"playlist"]) {
        item = [[[DeezerPlaylist alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"radio"]) {
        item = [[[DeezerRadio alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"track"]) {
        item = [[[DeezerTrack alloc] initWithDictionary:dictionary] autorelease];
    } else if ([type isEqualToString:@"user"]) {
        item = [[[DeezerUser alloc] initWithDictionary:dictionary] autorelease];
    }
    
    return item;
}


+ (NSArray*)getItemsFromDictionary:(NSDictionary*)dictionary {
    NSArray* dataArray = [dictionary objectForKey:@"data"];
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* subDictionary in dataArray) {
        NSString* type = [subDictionary objectForKey:@"type"];
        
        if ([type isEqualToString:@"album"]) {
            DeezerAlbum* album = [[DeezerAlbum alloc] initWithDictionary:subDictionary];
            [array addObject:album];
            [album release];
        } else if ([type isEqualToString:@"artist"]) {
            DeezerArtist* artist = [[DeezerArtist alloc] initWithDictionary:subDictionary];
            [array addObject:artist];
            [artist release];
        } else if ([type isEqualToString:@"comment"]) {
            DeezerComment* comment = [[DeezerComment alloc] initWithDictionary:subDictionary];
            [array addObject:comment];
            [comment release];
        } else if ([type isEqualToString:@"editorial"]) {
            DeezerEditorial* editorial = [[DeezerEditorial alloc] initWithDictionary:subDictionary];
            [array addObject:editorial];
            [editorial release];
        } else if ([type isEqualToString:@"folder"]) {
            DeezerFolder* folder = [[DeezerFolder alloc] initWithDictionary:subDictionary];
            [array addObject:folder];
            [folder release];
        } else if ([type isEqualToString:@"permission"]) {
            DeezerPermission* permission = [[DeezerPermission alloc] initWithDictionary:subDictionary];
            [array addObject:permission];
            [permission release];
        } else if ([type isEqualToString:@"playlist"]) {
            DeezerPlaylist* playlist = [[DeezerPlaylist alloc] initWithDictionary:subDictionary];
            [array addObject:playlist];
            [playlist release];
        } else if ([type isEqualToString:@"radio"]) {
            DeezerRadio* radio = [[DeezerRadio alloc] initWithDictionary:subDictionary];
            [array addObject:radio];
            [radio release];
        } else if ([type isEqualToString:@"track"]) {
            DeezerTrack* track = [[DeezerTrack alloc] initWithDictionary:subDictionary];
            [array addObject:track];
            [track release];
        } else if ([type isEqualToString:@"user"]) {
            DeezerUser* user = [[DeezerUser alloc] initWithDictionary:subDictionary];
            [array addObject:user];
            [user release];
        }
    }
    
    NSString* prevURL = [dictionary objectForKey:@"prev"];
    if (prevURL) {
        DeezerURL* url = [[DeezerURL alloc] initWithURLString:prevURL andName:@"Previous"];
        [array addObject:url];
        [url release];
    }
    
    NSString* nextURL = [dictionary objectForKey:@"next"];
    if (nextURL) {
        DeezerURL* url = [[DeezerURL alloc] initWithURLString:nextURL andName:@"Next"];
        [array addObject:url];
        [url release];
    }
    
    return array;
}

@end
