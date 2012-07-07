#import "DeezerUser.h"
#import "UIImageView+AFNetworking.h"
#import "DeezerItemConnection.h"

@implementation DeezerUser

@synthesize name            = _name;
@synthesize lastName        = _lastName;
@synthesize firstname       = _firstname;
@synthesize email           = _email;
@synthesize birthday        = _birthday;
@synthesize inscriptionDate = _inscriptionDate;
@synthesize gender          = _gender;
@synthesize link            = _link;
@synthesize picture         = _picture;
@synthesize country         = _country;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _deezerID =         [[dictionary objectForKey:@"id"] retain];
        _name =             [[dictionary objectForKey:@"name"] retain];
        _lastName =         [[dictionary objectForKey:@"lastname"] retain];
        _firstname =        [[dictionary objectForKey:@"firstname"] retain];
        _email =            [[dictionary objectForKey:@"email"] retain];
        _birthday =         [[dictionary objectForKey:@"birthday"] retain];
        _inscriptionDate =  [[dictionary objectForKey:@"inscription_date"] retain];
        _gender =           [[dictionary objectForKey:@"gender"] retain];
        _link =             [[dictionary objectForKey:@"link"] retain];
        _picture =          [[dictionary objectForKey:@"picture"] retain];
        _country =          [[dictionary objectForKey:@"country"] retain];
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [_lastName release];
    [_firstname release];
    [_email release];
    [_birthday release];
    [_inscriptionDate release];
    [_gender release];
    [_link release];
    [_picture release];
    [_country release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",
            [NSString stringWithFormat:@"DeezerID : %@",        _deezerID],
            [NSString stringWithFormat:@"Name : %@",            _name],
            [NSString stringWithFormat:@"Last Name : %@",       _lastName],
            [NSString stringWithFormat:@"Firstname : %@",       _firstname],
            [NSString stringWithFormat:@"Email : %@",           _email],
            [NSString stringWithFormat:@"Birthday : %@",        [_birthday description]],
            [NSString stringWithFormat:@"Inscription Date : %@",[_inscriptionDate description]],
            [NSString stringWithFormat:@"Gender : %@",          _gender],
            [NSString stringWithFormat:@"Link : %@",            _link],
            [NSString stringWithFormat:@"Country : %@",         _country]];
}

- (NSString*)requestName {
    return @"user";
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
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Albums andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Artists andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Charts andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Friends andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Folders andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Permissions andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_PersonalSongs andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Playlists andItem:self],
            [DeezerItemConnection DeezerItemConnectionWithType:DeezerItemConnectionType_Radios andItem:self],
            nil];
}

@end
