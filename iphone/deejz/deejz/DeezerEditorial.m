#import "DeezerEditorial.h"
#import "DeezerItemConnection.h"

@implementation DeezerEditorial

@synthesize name = _name;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID = [[dictionary objectForKey:@"id"] retain];
        _name = [[dictionary objectForKey:@"name"] retain];
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@\n%@",
            [NSString stringWithFormat:@"DeezerID : %@",_deezerID],
            [NSString stringWithFormat:@"Name : %@",    _name]];
}

- (NSString*)requestName {
    return @"editorial";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    
    [[cell textLabel] setText:_name];
    
    return cell;
}

- (NSArray*)dataForTableView {
    return [NSArray arrayWithObjects:
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Selection andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Charts andItem:self],
            nil];
}

@end
