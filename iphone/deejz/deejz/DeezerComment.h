/*
 * http://www.deezer.com/fr/developers/simpleapi/comment
 */

#import "DeezerItem.h"

@class DeezerUser;

@interface DeezerComment : DeezerItem {
    NSString*   _text;     // The content of the comment
    NSDate*     _date;     // The date the comment was posted
    DeezerUser* _author;  // The comment's creator (DeezerUser object containing : id, name, link, picture)
}

@property (nonatomic, readonly) NSString*   text;
@property (nonatomic, readonly) NSDate*     date;
@property (nonatomic, readonly) DeezerUser* author;

@end
