//
//  GesturesInterpretedDelegate.h
//  Hoccer
//
//  Created by Robert Palmer on 14.09.09.
//  Copyright 2009 ART+COM. All rights reserved.
//

@class GesturesInterpreter;

@protocol GesturesInterpreterDelegate <NSObject>

@optional
- (void)gesturesInterpreterDidDetectCatch: (GesturesInterpreter *)aGestureInterpreter;
- (void)gesturesInterpreterDidDetectThrow: (GesturesInterpreter *)aGestureInterpreter;

@end
