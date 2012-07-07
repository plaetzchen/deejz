/*
 * http://www.deezer.com/fr/developers/simpleapi/radio
 */
 
#import "DeezerItem.h"

@interface DeezerRadio : DeezerItem {
    NSString* _title;       // The radio title
    NSString* _description; // The radio title ????
    NSString* _picture;     // The url of the radio picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'
}

@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* description;
@property (nonatomic, readonly) NSString* picture;

@end
