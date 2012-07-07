#import "DeezerItem.h"

@implementation DeezerItem

@synthesize deezerID = _deezerID;
@synthesize connections = _connections;

@synthesize requestName;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    return self;
}

- (void)dealloc {
    [_deezerID release];
    [_connections release];
    [super dealloc];
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    NSString* cellID = [NSString stringWithFormat:@"%@_cell_identifier", NSStringFromClass([self class])];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    return cell;
}


- (NSString*)image {
    return nil;
}

- (NSArray*)dataForTableView {
    return nil;
}

@end
