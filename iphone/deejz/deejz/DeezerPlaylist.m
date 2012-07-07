#import "DeezerPlaylist.h"
#import "UIImageView+AFNetworking.h"
#import "DeezerUser.h"
#import "DictionaryParser.h"
#import "DeezerItemConnection.h"

@implementation DeezerPlaylist

@synthesize title = _title;
@synthesize link = _link;
@synthesize picture = _picture;
@synthesize creator = _creator;
@synthesize tracks = _tracks;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID = [[dictionary objectForKey:@"id"] retain];
        _title = [[dictionary objectForKey:@"title"] retain];
        _link = [[dictionary objectForKey:@"link"] retain];
        _picture = [[dictionary objectForKey:@"picture"] retain];
        _creator = [[DeezerUser alloc] initWithDictionary:[dictionary objectForKey:@"creator"]];
        _tracks = [[DictionaryParser getItemsFromDictionary:[dictionary objectForKey:@"tracks"]] retain];
    }
    return self;
}

- (void)dealloc {
    [_title release];
    [_link release];
    [_picture release];
    [_creator release];
    [_tracks release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",
            [NSString stringWithFormat:@"DeezerID : %@",        _deezerID],
            [NSString stringWithFormat:@"Title : %@",           _title],
            [NSString stringWithFormat:@"Link : %@",            _link],
            [NSString stringWithFormat:@"Picture : %@",         _picture],
            [NSString stringWithFormat:@"Creator : %@",         [_creator name]]];
}

- (NSString*)requestName {
    return @"playlist";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    
    [[cell imageView] setImageWithURL:[NSURL URLWithString:_picture] placeholderImage:[UIImage imageNamed:@"defaultCover.jpg"]];
    [[cell textLabel] setText:_title];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSString*)image {
    return _picture;
}

- (NSArray*)dataForTableView {
    NSMutableArray* array = [NSMutableArray arrayWithArray:_tracks];
    [array addObject:[DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Comments andItem:self]];
    [array addObject:[DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Fans andItem:self]];
    [array addObject:[DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Tracks andItem:self]];
    return array;
}

@end
