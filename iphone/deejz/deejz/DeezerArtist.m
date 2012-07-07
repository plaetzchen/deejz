#import "DeezerArtist.h"
#import "UIImageView+AFNetworking.h"
#import "DeezerItemConnection.h"

@implementation DeezerArtist

@synthesize name = _name;
@synthesize link = _link;
@synthesize picture = _picture;
@synthesize nbAlbums = _nbAlbums;
@synthesize nbFans = _nbFans;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID = [[dictionary objectForKey:@"id"] retain];
        _name = [[dictionary objectForKey:@"name"] retain];
        _link = [[dictionary objectForKey:@"link"] retain];
        _picture = [[dictionary objectForKey:@"picture"] retain];
        _nbAlbums = [[dictionary objectForKey:@"nb_album"] intValue];
        _nbFans = [[dictionary objectForKey:@"nb_fan"] intValue];
    }
    return self;
}

- (void)dealloc {
    //[_deezerID release];
    [_name release];
    [_link release];
    [_picture release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
            [NSString stringWithFormat:@"DeezerID : %@",_deezerID],
            [NSString stringWithFormat:@"Name : %@",    _name],
            [NSString stringWithFormat:@"Link : %@",    _link],
            [NSString stringWithFormat:@"%i albums",    _nbAlbums],
            [NSString stringWithFormat:@"%i fans",      _nbFans]];
}

- (NSString*)requestName {
    return @"artist";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    
    [[cell imageView] setImageWithURL:[NSURL URLWithString:_picture] placeholderImage:[UIImage imageNamed:@"defaultAvatar.jpg"]];
    [[cell textLabel] setText:_name];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSString*)image {
    return _picture;
}

- (NSArray*)dataForTableView {
    return [NSArray arrayWithObjects:
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Top andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Radio andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Albums andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Comments andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Fans andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Related andItem:self],
            nil];
}

@end
