//
//  FeatureHistory.h
//  Hoccer
//
//  Created by Robert Palmer on 22.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kXAxis 0
#define kYAxis 1
#define kZAxis 2

@interface FeatureHistory : NSObject {

	NSMutableArray *xLineFeatures;
	NSMutableArray *yLineFeatures;
	NSMutableArray *zLineFeatures;
	
	double starttime;
}

@property (readonly) NSMutableArray *xLineFeatures, *yLineFeatures, *zLineFeatures;

- (void)addAcceleration : (UIAcceleration *)acceleration;

- (UIImage *)chart;
- (NSString *)featurePatternOnAxis: (NSInteger)axis inTimeInterval: (NSTimeInterval)timeInterval;
- (BOOL)hasValueAt: (float)targetValue withVariance: (float)variance onAxis: (NSInteger)axis;
- (BOOL)wasLowerThan: (float)targetValue onAxis: (NSInteger)axis inLast: (NSTimeInterval) milliseconds;
- (BOOL)wasHigherThan: (float)targetValue onAxis: (NSInteger)axis inLast: (NSTimeInterval) milliseconds;

@end
