//
//  VetoCell.m
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import "VetoCell.h"

@implementation VetoCell
@synthesize currentSongLabel,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)likePressed:(id)sender {
    [delegate vetoCellDidVoteLike];
}

- (IBAction)dislikeTapped:(id)sender {
    [delegate vetoCellDidVoteDislike];
}
@end
