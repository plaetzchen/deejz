//
//  StartListCell.m
//  deejz
//
//  Created by Philip Brechler on 08.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import "StartListCell.h"

@implementation StartListCell
@synthesize partyNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
