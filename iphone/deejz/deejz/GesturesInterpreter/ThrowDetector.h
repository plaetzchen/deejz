//
//  ThrowDetector.h
//  Hoccer
//
//  Created by Robert Palmer on 28.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FeatureHistory;

@interface ThrowDetector : NSObject {
	NSDate *lastGesture;
}

- (BOOL)detect: (FeatureHistory *)featureHistory;

@end
