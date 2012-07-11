//
//  CreatePlaylistViewController.h
//  deejz
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeezerSession.h"
#import <CoreLocation/CoreLocation.h>

@interface CreatePlaylistViewController : UIViewController <UITextFieldDelegate, DeezerSessionRequestDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) NSString *returnedSlug;
@property (strong, nonatomic) CLLocationManager *clManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) IBOutlet UINavigationBar *theNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *theNavItem;

- (IBAction)cancelButtonTapped:(id)sender;

- (IBAction)createButtonTapped:(id)sender;

@end
