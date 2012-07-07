#import "DeezerRadio.h"
#import "DeezerItemConnection.h"
#import "UIImageView+AFNetworking.h"

@implementation DeezerRadio

@synthesize title = _title;
@synthesize description = _description;
@synthesize picture = _picture;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID = [[dictionary objectForKey:@"id"] retain];
        _title = [[dictionary objectForKey:@"title"] retain];
        _description = [[dictionary objectForKey:@"description"] retain];
        _picture = [[dictionary objectForKey:@"picture"] retain];
    }
    return self;
}

- (void)dealloc {
    [_title release];
    [_description release];
    [_picture release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
            [NSString stringWithFormat:@"DeezerID : %@",    _deezerID],
            [NSString stringWithFormat:@"Title : %@",       _title],
            [NSString stringWithFormat:@"Description : %@", _description],
            [NSString stringWithFormat:@"Picture : %@",     _picture]];
}

- (NSString*)requestName {
    return @"radio";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    
    [[cell imageView] setImageWithURL:[NSURL URLWithString:_picture] placeholderImage:[UIImage imageNamed:@"defaultCover.jpg"]];
    [[cell textLabel] setText:_title];
    
    return cell;
}

- (NSString*)image {
    return _picture;
}

- (NSArray*)dataForTableView {
    return [NSArray arrayWithObjects:
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Genres andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Top andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Tracks andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_RadioListen andItem:self],
            nil];
}

@end
