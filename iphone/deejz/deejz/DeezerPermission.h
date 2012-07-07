/*
 * http://www.deezer.com/fr/developers/simpleapi/permissions
 */

#import "DeezerItem.h"

@interface DeezerPermission : DeezerItem {
    //NO ID
    NSString* _permission;
}

@property (nonatomic, retain) NSString* permission;

@end
