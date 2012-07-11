//
//  ThrowDetector.m
//  Hoccer
//
//  Created by Robert Palmer on 28.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

#import "ThrowDetector.h"
#import "FeatureHistory.h"
#import "NSString+Regexp.h"

@interface ThrowDetector ()
@property (retain) NSDate *lastGesture;
@end

@implementation ThrowDetector
@synthesize lastGesture;


- (BOOL)detect: (FeatureHistory *)featureHistory
{
	if (lastGesture && [lastGesture timeIntervalSinceNow] > -0.5) {
		return NO;
	}
	
	NSString  *yFeaturePattern = [featureHistory featurePatternOnAxis:kYAxis inTimeInterval: 500];
	
	if ([yFeaturePattern endsWith:@"down>"]) {
		
		if  ([featureHistory wasLowerThan: 0 onAxis: kYAxis inLast: 10]) {
			
			if ([featureHistory wasHigherThan: 19 onAxis: kYAxis inLast: 500]) {
				self.lastGesture = [NSDate date];
				return YES;
			}
			
		}
		
	}
	
	return NO;
}

- (void) dealloc
{
	self.lastGesture = nil;
	[super dealloc];
}



@end
