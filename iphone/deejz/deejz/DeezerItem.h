/*
 * DeezerItem is a superclass for every object you can request on the Deezer API.
 * They all are defined by a DeezerId.
 */

#import <Foundation/Foundation.h>

@interface DeezerItem : NSObject {
    NSString*   _deezerID;
    NSArray*    _connections;
}

@property (nonatomic, readonly) NSString*   deezerID;
@property (nonatomic, readonly) NSArray*    connections;

@property (nonatomic, readonly) NSString*   requestName;

- (id)initWithDictionary:(NSDictionary*)dictionary;

- (UITableViewCell*)cellForTableView:(UITableView*)tableView;
- (NSString*)image;
- (NSArray*)dataForTableView;

@end
