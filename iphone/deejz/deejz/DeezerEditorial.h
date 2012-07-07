/*
 * http://www.deezer.com/fr/developers/simpleapi/editorial
 */

#import "DeezerItem.h"

@interface DeezerEditorial : DeezerItem {
    NSString* _name;     // The editorial's name
}

@property (nonatomic, readonly) NSString* name;

@end
