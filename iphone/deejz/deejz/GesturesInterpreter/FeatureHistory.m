//
//  FeatureHistory.m
//  Hoccer
//
//  Created by Robert Palmer on 22.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

#import "FeatureHistory.h"
#import "LineFeature.h"

@interface FeatureHistory (Private)

- (void) addPoint: (CGPoint) newPoint toLine: (NSMutableArray *)lineFeatures;
- (NSString *)chartDataFor: (NSArray *)lineFeatures;
- (NSArray *)featuresOnAxis: (NSInteger)axis;

@end

@implementation FeatureHistory

@synthesize  xLineFeatures, yLineFeatures, zLineFeatures;

- (id) init {
	self = [super init];
	if (self != nil) {
		xLineFeatures =[[NSMutableArray alloc] init]; 
		yLineFeatures =[[NSMutableArray alloc] init]; 
		zLineFeatures =[[NSMutableArray alloc] init]; 
		
		starttime = -1;
	}
	return self;
}

- (void)dealloc
{
	[xLineFeatures release];
	[yLineFeatures release];
	[zLineFeatures release];

	[super dealloc];
}

- (void)addAcceleration : (UIAcceleration *)acceleration 
{
	if (starttime == -1) {
		starttime = acceleration.timestamp;
	}

	NSTimeInterval time = (acceleration.timestamp - starttime) * 1000; 
	
	[self addPoint: CGPointMake(time, acceleration.x * 9.81) 
			toLine: xLineFeatures]; 
	
	[self addPoint: CGPointMake(time, acceleration.y * 9.81) 
			toLine: yLineFeatures]; 
	
	[self addPoint: CGPointMake(time, acceleration.z * 9.81) 
			toLine: zLineFeatures]; 
}


- (UIImage *)chart
{
	float length = [[yLineFeatures lastObject] newestPoint].x;
	NSString *minMax = [NSString stringWithFormat: @"0,%f,-30,30", length];
	
	NSMutableString *url = [NSMutableString string];
	[url appendString: @"http://chart.apis.google.com/chart?"];
	[url appendString: @"chs=900x330&cht=lxy&chdl=x|y|z&chco=FF0000,00FF00,0000FF&chg=0,50,1,0"];
	[url appendFormat: @"&chxt=x,y&chxr=0,0,%f|1,-30,30", length];
	[url appendFormat: @"&chds=%@,%@,%@", minMax, minMax, minMax];
	
	[url appendFormat: @"&chd=t:%@|%@|%@", 
			[self chartDataFor: xLineFeatures], 
			[self chartDataFor: yLineFeatures], 
			[self chartDataFor: zLineFeatures]];

	
	NSError *error = nil;
	NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:  NSUTF8StringEncoding]] 
											  options: NSUncachedRead error: &error];
	
	
	return [UIImage imageWithData: imageData];
}

- (void) addPoint: (CGPoint)newPoint toLine: (NSMutableArray *)lineFeatures 
{
	if ([lineFeatures count] == 0) {
		[lineFeatures addObject: [LineFeature lineFeatureWithPoint: newPoint]]; 
	} else if (![[lineFeatures lastObject] addPoint: newPoint]) {
		CGPoint lastPoint = [[lineFeatures lastObject] newestPoint];
		[lineFeatures addObject:[LineFeature lineFeatureWithPoint: lastPoint andPoint: newPoint]]; 
	} 
}



- (NSString *)featurePatternOnAxis: (NSInteger) axis inTimeInterval: (NSTimeInterval) timeInterval
{
	NSArray *lineFeatures = [self featuresOnAxis:axis];
	NSMutableArray *featureTypeArray= [NSMutableArray array];
		
	for (int i = [lineFeatures count]-1; i >= 0 && timeInterval > 0; i--) {
		LineFeature *feature = [lineFeatures objectAtIndex:i];
        NSString *type = [feature type];
        if (type != nil) {
            [featureTypeArray insertObject:type atIndex:0];
        }
		
		timeInterval -= feature.length;
	}
	
	return [featureTypeArray componentsJoinedByString:@""];
}

- (NSArray *)featuresOnAxis: (NSInteger)axis 
{
	switch (axis) {
		case kXAxis:
			return self.xLineFeatures;
			break;
		case kYAxis:
			return self.yLineFeatures;
			break;
		case kZAxis:
			return self.zLineFeatures;
			break;
		default:
			return nil;
	}
}

- (BOOL)hasValueAt: (float)targetValue withVariance: (float)variance onAxis: (NSInteger)axis
{
	LineFeature *newestFeature = [[self featuresOnAxis:axis] lastObject];
	if (newestFeature == nil)
		return NO;
	
	if (fabsf(newestFeature.newestPoint.y - targetValue) < variance)
		return YES;
	
	return NO;
	
}

- (BOOL)wasLowerThan: (float)targetValue onAxis: (NSInteger)axis inLast: (NSTimeInterval) timeInterval
{
	NSArray *lineFeatures = [self featuresOnAxis: axis];
	
	for (int i = [lineFeatures count]-1; i >= 0; i--) {
		LineFeature *lineFeature = [lineFeatures objectAtIndex:i];
		if (lineFeature.newestPoint.y < targetValue || lineFeature.firstPoint.y < targetValue)
			return YES;
		
		timeInterval -= lineFeature.length;
		if (timeInterval < 0)
			return NO;
	}
	
	return NO;
}


- (BOOL)wasHigherThan: (float)targetValue onAxis: (NSInteger)axis inLast: (NSTimeInterval) timeInterval
{
	NSArray *lineFeatures = [self featuresOnAxis: axis];
	
	for (int i = [lineFeatures count]-1; i >= 0; i--) {
		LineFeature *lineFeature = [lineFeatures objectAtIndex:i];
		if (lineFeature.newestPoint.y > targetValue || lineFeature.firstPoint.y > targetValue)
			return YES;
		
		timeInterval -= lineFeature.length;
		if (timeInterval < 0)
			return NO;
	}
	
	return NO;
}


- (NSString *)chartDataFor: (NSArray *)lineFeatures
{
	NSMutableString *xValues = [NSMutableString string];
	NSMutableString *yValues = [NSMutableString string];
	
	for (LineFeature *feature in lineFeatures) {
		CGPoint firstPoint = [feature firstPoint];
		CGPoint lastPoint  = [feature newestPoint];
		
		[xValues appendFormat: @"%2.2f,%2.2f,", firstPoint.x, lastPoint.x];
		[yValues appendFormat: @"%2.2f,%2.2f,", firstPoint.y, lastPoint.y];
	}
	
	[xValues deleteCharactersInRange: NSMakeRange([xValues length]-1, 1)];
	[yValues deleteCharactersInRange: NSMakeRange([yValues length]-1, 1)];
	
	return [NSString stringWithFormat:@"%@|%@", xValues, yValues]; 
}





@end
