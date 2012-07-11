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
@synthesize theTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (searchSegmentedControl.selectedSegmentIndex == 0){
        [delegate searchCellSearchFor:textField.text Kind:searchSegmentedControl.selectedSegmentIndex];
    }
    return YES;
}

- (IBAction)searchSegmentedControlChanged:(id)sender {
    
    if (searchSegmentedControl.selectedSegmentIndex == 0){
        [self.searchSegmentedControl setImage:[UIImage imageNamed:@"sender_search_sctrl_tracks_active"] forSegmentAtIndex:0];
        [self.searchSegmentedControl setImage:[UIImage imageNamed:@"sender_search_sctrl_genres_inactive"] forSegmentAtIndex:1];
    }
    else {
        [self.searchSegmentedControl setImage:[UIImage imageNamed:@"sender_search_sctrl_tracks_inactive"] forSegmentAtIndex:0];
        [self.searchSegmentedControl setImage:[UIImage imageNamed:@"sender_search_sctrl_genres_active"] forSegmentAtIndex:1];
    }
    
    if (searchSegmentedControl.selectedSegmentIndex == 1){
        [delegate searchCellDidSelectGenre];
    }
}
@end
