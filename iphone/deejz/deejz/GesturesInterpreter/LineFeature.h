//
//  LineFeature.h
//  Hoccer
//
//  Created by Robert Palmer on 21.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LineFeature : NSObject {
	NSMutableArray *points;
}

@property (readonly) float slope;
@property (readonly) float length;
@property (readonly) float yIntersection;
@property (readonly) CGPoint center;
@property (readonly) NSString *type;


@property (readonly) CGPoint newestPoint;
@property (readonly) CGPoint firstPoint;

+ (LineFeature *)lineFeatureWithPoint: (CGPoint)point;
+ (LineFeature *)lineFeatureWithPoint: (CGPoint)pointA  andPoint: (CGPoint)pointB;

- (id)initWithPoint: (CGPoint)point;
- (BOOL)addPoint: (CGPoint)point;

- (BOOL)isValid: (CGPoint) point;

- (BOOL)isFlat;
- (BOOL)isDescending;
- (BOOL)isAscending;


@end
