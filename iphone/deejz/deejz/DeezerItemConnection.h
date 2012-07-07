#import "DeezerItem.h"

typedef enum {
    DeezerItemConnectionType_Albums,
    DeezerItemConnectionType_Artists,
    DeezerItemConnectionType_Charts,
    DeezerItemConnectionType_Comments,
    DeezerItemConnectionType_Fans,
    DeezerItemConnectionType_Friends,
    DeezerItemConnectionType_Folders,
    DeezerItemConnectionType_Genres,
    DeezerItemConnectionType_Items,
    DeezerItemConnectionType_Permissions,
    DeezerItemConnectionType_PersonalSongs,
    DeezerItemConnectionType_Playlists,
    DeezerItemConnectionType_Radio,
    DeezerItemConnectionType_RadioListen,
    DeezerItemConnectionType_Radios,
    DeezerItemConnectionType_Related,
    DeezerItemConnectionType_Selection,
    DeezerItemConnectionType_Top,
    DeezerItemConnectionType_Tracks,
} DeezerItemConnectionType;

@class DeezerItem;

@interface DeezerItemConnection : DeezerItem {
    DeezerItemConnectionType _type;
    
    NSString* _itemRequestName;
    NSString* _itemID;
}

@property (nonatomic, readonly) NSString* requestName;
@property (nonatomic, readonly) NSString* name;

+ (id)DeezerItemConnectionWithType:(DeezerItemConnectionType)type andItem:(DeezerItem*)item;
- (id)initWithType:(DeezerItemConnectionType)type andItem:(DeezerItem*)item;

@end
