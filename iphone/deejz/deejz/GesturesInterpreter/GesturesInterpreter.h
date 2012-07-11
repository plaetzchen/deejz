//
//  GesturesInterpreter.h
//  Hoccer
//
//  Created by Robert Palmer on 14.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GesturesInterpreterDelegate.h"

@class CatchDetector;
@class ThrowDetector;
@class FeatureHistory;


@interface GesturesInterpreter : NSObject <UIAccelerometerDelegate> {
	CatchDetector *catchDetector;
	ThrowDetector *throwDetector;
	
	FeatureHistory *featureHistory;
	
	NSObject <GesturesInterpreterDelegate> * delegate;
}

@property (retain) IBOutlet NSObject <GesturesInterpreterDelegate> * delegate;

@end
