#import <Foundation/Foundation.h>

@class DeezerItem;

@interface DictionaryParser : NSObject

+ (DeezerItem*)getItemFromDictionary:(NSDictionary*)dictionary;
+ (NSArray*)getItemsFromDictionary:(NSDictionary*)dictionary;

@end
