//
//  ViewController.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeezerSession.h"

@interface StartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DeezerSessionConnectionDelegate>

@property (strong, nonatomic) IBOutlet UITableView *partiesTable;
@property (atomic) BOOL loggedIn;
- (IBAction)createPartyTapped:(id)sender;

@end
