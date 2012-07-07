#import "DeezerPermission.h"

@implementation DeezerPermission

@synthesize permission = _permission;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _permission = [[dictionary objectForKey:@"permission"] retain];
    }
    return self;
}

- (void)dealloc {
    [_permission release];
    [super dealloc];
}

- (NSString*)requestName {
    return @"permission";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    
    [[cell textLabel] setText:_permission];
    
    return cell;
}

@end
