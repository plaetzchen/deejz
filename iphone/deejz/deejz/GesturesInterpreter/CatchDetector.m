//
//  CatchDetector.m
//  Hoccer
//
//  Created by Robert Palmer on 23.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

#import "CatchDetector.h"
#import "NSString+Regexp.h"

@interface CatchDetector ()
@property (retain) NSDate *lastGesture;
@end

@implementation CatchDetector
@synthesize lastGesture;

- (BOOL)detect: (FeatureHistory *)featureHistory
{
	if (lastGesture && [lastGesture timeIntervalSinceNow] > -0.3) {
		return NO;
	}

	
	if ([featureHistory hasValueAt:-9.81 withVariance:2 onAxis:kYAxis]) {
		if ([featureHistory wasHigherThan:-2 onAxis:kYAxis inLast:400]) {
			NSString *featurePattern = [featureHistory featurePatternOnAxis:kYAxis inTimeInterval:400];
			
			if ([featurePattern startsWith: @"<down>"] || [featurePattern startsWith:@"<fastdown>"]) {
				if ([featurePattern endsWith: @"<flat>"] || [featurePattern endsWith: @"<up>"]) {
					self.lastGesture = [NSDate date];  
					return YES;
				}
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
