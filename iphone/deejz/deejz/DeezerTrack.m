#import "DeezerTrack.h"
#import "UIImageView+AFNetworking.h"
#import "DeezerArtist.h"
#import "DeezerAlbum.h"
#import "AudioPlayerController.h"

@implementation DeezerTrack

@synthesize readable = _readable;
@synthesize title = _title;
@synthesize link = _link;
@synthesize duration = _duration;
@synthesize rank = _rank;
@synthesize preview = _preview;
@synthesize artist = _artist;
@synthesize album = _album;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID = [[dictionary objectForKey:@"id"] retain];
        _readable = [[dictionary objectForKey:@"readable"] boolValue];
        _title = [[dictionary objectForKey:@"title"] retain];
        _link = [[dictionary objectForKey:@"link"] retain];
        _duration = [[dictionary objectForKey:@"duration"] intValue];
        _rank = [[dictionary objectForKey:@"rank"] intValue];
        _preview = [[dictionary objectForKey:@"preview"] retain];
        _artist = [[DeezerArtist alloc] initWithDictionary:[dictionary objectForKey:@"artist"]];
        _album = [[DeezerAlbum alloc] initWithDictionary:[dictionary objectForKey:@"album"]];
    }
    return self;
}

- (void)dealloc {
    [_title release];
    [_link release];
    [_preview release];
    [_artist release];
    [_album release];
    [super dealloc];
}

- (NSString*)requestName {
    return @"track";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    
    [[cell textLabel] setText:_title];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (UIViewController*)viewController {
    if ([_deezerID isKindOfClass:[NSString class]]) {
        AudioPlayerController* audioPlayerController = [[[AudioPlayerController alloc] initWithTrackId:_deezerID
                                                                                                 title:_title
                                                                                            artistName:[_artist name]  
                                                                                              andCover:[_album cover]] autorelease];
        return audioPlayerController;
    }
    
    return nil;
}

@end
