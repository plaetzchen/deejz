#import "DeezerFolder.h"
#import "DeezerUser.h"
#import "DeezerItemConnection.h"

@implementation DeezerFolder

@synthesize title = _title;
@synthesize creator = _creator;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID = [[dictionary objectForKey:@"id"] retain];
        _title = [[dictionary objectForKey:@"title"] retain];
        _creator = [[DeezerUser alloc] initWithDictionary:[dictionary objectForKey:@"creator"]];
    }
    return self;
}

- (void)dealloc {
    [_title release];
    [_creator release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@",
            [NSString stringWithFormat:@"DeezerID : %@", _deezerID],
            [NSString stringWithFormat:@"Name : %@", _title],
            [NSString stringWithFormat:@"Creator : %@", [_creator name]]];
}

- (NSString*)requestName {
    return @"folder";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    [[cell textLabel] setText:_title];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (NSArray*)dataForTableView {
    return [NSArray arrayWithObjects:
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Items andItem:self],
            nil];
}

@end
