//
//  ReceiverViewController.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverViewController : UIViewController
- (IBAction)cancelButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *playListTable;

@end
