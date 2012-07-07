#import "DeezerURL.h"

@implementation DeezerURL

@synthesize urlString = _urlString;

- (id)initWithURLString:(NSString*)urlString andName:(NSString*)name {
    if (self = [super init]) {
        _urlString = [urlString copy];
        _name = [name copy];
    }
    return self;
}

- (void)dealloc {
    [_urlString release];
    [_name release];
    [super dealloc];
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [[cell textLabel] setText:_name];
    
    return cell;
}

- (UIViewController*)viewController {
    return nil;
}

@end
