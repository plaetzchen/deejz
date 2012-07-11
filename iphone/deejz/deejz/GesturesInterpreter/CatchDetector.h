//
//  CatchDetector.h
//  Hoccer
//
//  Created by Robert Palmer on 23.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeatureHistory.h"


@interface CatchDetector : NSObject {
	NSDate *lastGesture;
}

- (BOOL)detect: (FeatureHistory *)featureHistory;

@end
