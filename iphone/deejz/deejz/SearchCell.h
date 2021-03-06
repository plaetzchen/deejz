//
//  SearchCell.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCellDelegate.h"

@interface SearchCell : UIView <UITextFieldDelegate>

@property (atomic, strong) id <SearchCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *theTextField;

- (IBAction)searchSegmentedControlChanged:(id)sender;

@end
