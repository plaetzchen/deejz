#import "DeezerItem.h"

@interface DeezerURL : DeezerItem {
    NSString* _urlString;
    NSString* _name;
}

@property (nonatomic, copy) NSString* urlString;

- (id)initWithURLString:(NSString*)urlString andName:(NSString*)name;

@end
