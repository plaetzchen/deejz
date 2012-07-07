//
//  SearchCell.m
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

@synthesize delegate;
@synthesize searchSegmentedControl;

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (searchSegmentedControl.selectedSegmentIndex == 0){
        [delegate searchCellSearchFor:textField.text Kind:searchSegmentedControl.selectedSegmentIndex];
    }
    return YES;
}

- (IBAction)searchSegmentedControlChanged:(id)sender {
    if (searchSegmentedControl.selectedSegmentIndex == 1){
        [delegate searchCellDidSelectGenre];
    }
}
@end
