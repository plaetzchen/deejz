#import "DeezerComment.h"
#import "DeezerUser.h"

@implementation DeezerComment

@synthesize text = _text;
@synthesize date = _date;
@synthesize author = _author;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID = [[dictionary objectForKey:@"id"] retain];
        _text = [[dictionary objectForKey:@"text"] retain];
        _date = [[dictionary objectForKey:@"date"] retain];
        _author = [[DeezerUser alloc] initWithDictionary:[dictionary objectForKey:@"author"]];
    }
    return self;
}

- (void)dealloc {
    [_text release];
    [_date release];
    [_author release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
            [NSString stringWithFormat:@"DeezerID : %@",_deezerID],
            [NSString stringWithFormat:@"Text : %@",    _text],
            [NSString stringWithFormat:@"Date : %@",    [_date description]],
            [NSString stringWithFormat:@"Creator : %@", [_author name]]];
}

- (NSString*)requestName {
    return @"comment";
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    [[cell textLabel] setText:_text];
    
    return cell;
}

@end
