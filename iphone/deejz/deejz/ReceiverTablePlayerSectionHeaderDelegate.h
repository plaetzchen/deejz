//
//  ReceiverTablePlayerSectionHeaderDelegate.h
//  deejz
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//


@protocol ReceiverTablePlayerSectionHeaderDelegate
- (void)receiverTablePlayerDidPlayPause;
- (void)receiverTablePlayerDidStop;
- (void)receiverTablePlayerDidFaceBook;
- (void)receiverTablePlayerDidFwd;

@end
