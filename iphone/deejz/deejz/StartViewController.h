//
//  ViewController.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeezerSession.h"
#import <CoreLocation/CoreLocation.h>

@interface StartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DeezerSessionConnectionDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *noPartiesImageView;
@property (strong, nonatomic) IBOutlet UITableView *partiesTable;
@property (strong, nonatomic) NSMutableArray *availableParties;
@property (strong, nonatomic) IBOutlet UINavigationBar *theNavBar;
@property (strong, nonatomic) CLLocationManager *clManager;
@property (strong, nonatomic) IBOutlet UIImageView *joinImage;
@property (strong, nonatomic) IBOutlet UIImageView *tableMask;

@property (atomic) BOOL loggedIn;
- (IBAction)createPartyTapped:(id)sender;

@end
