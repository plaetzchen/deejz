#import "DeezerItemConnection.h"
#import "DeezerItem.h"

@implementation DeezerItemConnection

@synthesize requestName;
@synthesize name;

+ (id)DeezerItemConnectionWithType:(DeezerItemConnectionType)type andItem:(DeezerItem*)item {
    return [[[self alloc] initWithType:type andItem:item] autorelease];
}

- (id)initWithType:(DeezerItemConnectionType)type andItem:(DeezerItem*)item {
    if (self = [super init]) {
        _type = type;
        _itemRequestName = [[item requestName] copy];
        _itemID  =[[item deezerID] copy];
    }
    return self;
}

- (void)dealloc {
    [_itemRequestName release];
    [_itemID release];
    [super dealloc];
}

- (NSString*)requestName {
    switch (_type) {
        case DeezerItemConnectionType_Albums :
            return @"albums";
            break;
        case DeezerItemConnectionType_Artists :
            return @"artists";
            break;
        case DeezerItemConnectionType_Charts :
            return @"charts";
            break;
        case DeezerItemConnectionType_Comments :
            return @"comments";
            break;
        case DeezerItemConnectionType_Fans :
            return @"fans";
            break;
        case DeezerItemConnectionType_Friends :
            return @"friends";
            break;
        case DeezerItemConnectionType_Folders :
            return @"folders";
            break;
        case DeezerItemConnectionType_Genres :
            return @"genres";
            break;
        case DeezerItemConnectionType_Items :
            return @"items";
            break;
        case DeezerItemConnectionType_Permissions :
            return @"permissions";
            break;
        case DeezerItemConnectionType_PersonalSongs :
            return @"personal_songs";
            break;
        case DeezerItemConnectionType_Playlists :
            return @"playlists";
            break;
        case DeezerItemConnectionType_Radio :
            return @"radio";
            break;
        case DeezerItemConnectionType_RadioListen :
            return @"listen";
            break;
        case DeezerItemConnectionType_Radios :
            return @"radios";
            break;
        case DeezerItemConnectionType_Related :
            return @"related";
            break;
        case DeezerItemConnectionType_Selection :
            return @"selection";
            break;
        case DeezerItemConnectionType_Top :
            return @"top";
            break;
        case DeezerItemConnectionType_Tracks :
            return @"tracks";
            break;
    }
    return nil;
}

- (NSString*)name {
    return [[self requestName] capitalizedString];
}

- (UITableViewCell*)cellForTableView:(UITableView *)tableView {
    UITableViewCell* cell = [super cellForTableView:tableView];
    [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [[cell textLabel] setText:[self name]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


@end
