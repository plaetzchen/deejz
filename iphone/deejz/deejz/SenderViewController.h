//
//  SenderViewController.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCellDelegate.h"
#import "DeezerSession.h"

@interface SenderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SearchCellDelegate,DeezerSessionRequestDelegate>

@property (strong, nonatomic) IBOutlet UITableView *songTableView;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (atomic) NSInteger selectedKind;

- (IBAction)signInTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

@end
