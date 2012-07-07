#import "DeezerAlbum.h"
#import "UIImageView+AFNetworking.h"
#import "DeezerArtist.h"
#import "DeezerTrack.h"
#import "DictionaryParser.h"
#import "DeezerItemConnection.h"

@implementation DeezerAlbum

@synthesize title    = _title;
@synthesize link     = _link;
@synthesize cover    = _cover;
@synthesize artist   = _artist;
@synthesize tracks   = _tracks;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID = [[dictionary objectForKey:@"id"] retain];
        _title = [[dictionary objectForKey:@"title"] retain];
        _link = [[dictionary objectForKey:@"link"] retain];
        _cover = [[dictionary objectForKey:@"cover"] retain];
        _artist = [[DeezerArtist alloc] initWithDictionary:[dictionary objectForKey:@"artist"]];
        _tracks = [[DictionaryParser getItemsFromDictionary:[dictionary objectForKey:@"tracks"]] retain];
    }
    return self;
}

- (void)dealloc {
    [_title release];
    [_link release];
    [_cover release];
    [_artist release];
    [_tracks release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
            [NSString stringWithFormat:@"DeezerID : %@",_deezerID],
            [NSString stringWithFormat:@"Title : %@",   _title],
            [NSString stringWithFormat:@"Link : %@",    _link],
            [NSString stringWithFormat:@"Artist : %@",  [_artist name]]];
}

- (NSString*)requestName {
    return @"album";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
 
    [[cell imageView] setImageWithURL:[NSURL URLWithString:_cover] placeholderImage:[UIImage imageNamed:@"defaultCover.jpg"]];
    [[cell textLabel] setText:_title];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSString*)image {
    return _cover;
}

- (NSArray*)dataForTableView {
    NSMutableArray* array = [NSMutableArray arrayWithArray:_tracks];
    [array addObject:[DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Comments andItem:self]];
    [array addObject:[DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Fans andItem:self]];
    [array addObject:[DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Tracks andItem:self]];
    return array;
}

@end
