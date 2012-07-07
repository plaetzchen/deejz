/*
 * http://www.deezer.com/fr/developers/simpleapi/folder
 */

#import "DeezerItem.h"

@class DeezerUser;

@interface DeezerFolder : DeezerItem {
    NSString*   _title;     // The folder's title
    DeezerUser* _creator;   // The folder's creator
}

@property (nonatomic, readonly) NSString*   title;
@property (nonatomic, readonly) DeezerUser* creator;

@end
