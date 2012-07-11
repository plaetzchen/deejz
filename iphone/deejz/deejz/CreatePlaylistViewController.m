//
//  CreatePlaylistViewController.m
//  deejz
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import "CreatePlaylistViewController.h"
#import "ReceiverViewController.h"
#import "DeezerSession.h"
#import "JSONKit.h"
#import "AFNetworking.h"
#import "UIBarButtonItem+CustomImageButton.h"
@interface CreatePlaylistViewController ()

@end

@implementation CreatePlaylistViewController
@synthesize theNavBar;
@synthesize theNavItem;
@synthesize nameTextField,returnedSlug,clManager,currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.clManager = [[CLLocationManager alloc]init];
        [self.clManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [self.clManager setDelegate:self];
        [self.clManager startUpdatingLocation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[DeezerSession sharedSession] setRequestDelegate:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.theNavBar setBackgroundImage:[UIImage imageNamed:@"start_nav_bar"] forBarMetrics:UIBarMetricsDefault];
    
    self.theNavItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_bar_btn_back"] target:self action:@selector(cancelButtonTapped:)];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setTheNavBar:nil];
    [self setTheNavItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[DeezerSession sharedSession] setRequestDelegate:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)createButtonTapped:(id)sender {
    //[[DeezerSession sharedSession] createPlaylistNamed:[nameTextField text] forUser:@"me"];
    NSURL *url = [NSURL URLWithString:@"http://deejz.herokuapp.com/party/create/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    AFNetworkActivityIndicatorManager * newactivity = [[AFNetworkActivityIndicatorManager alloc] init]; 
    newactivity.enabled = YES;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            nameTextField.text, @"name",
                            @"Berlin", @"address", [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude],@"latitude",[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude],@"longitude",
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://deejz.herokuapp.com/party/create/"parameters:params];
    [httpClient release];
    ReceiverViewController *receiverVC = [[ReceiverViewController alloc]initWithNibName:@"ReceiverViewController" bundle:[NSBundle mainBundle]];
    receiverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        receiverVC.partyName = self.nameTextField.text;

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        receiverVC.partyPlaylist = [JSON objectForKey:@"partyslug"];
        [self presentModalViewController:receiverVC animated:YES];
    } failure:nil];
      
    [operation start];
}

# pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [nameTextField resignFirstResponder];
    return YES;
}

# pragma mark DeezerSessionRequestDelegate

- (void)deezerSessionRequestDidReceiveResponse:(NSData *)data {
    JSONDecoder *decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionNone];
    NSDictionary *response = [decoder objectWithData:data];
    ReceiverViewController *receiverVC = [[ReceiverViewController alloc]initWithNibName:@"ReceiverViewController" bundle:[NSBundle mainBundle]];
    receiverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    if ([response objectForKey:@"id"]){
        receiverVC.partyPlaylist = [response objectForKey:@"id"];
        receiverVC.navItem.title = self.nameTextField.text;
        [self presentModalViewController:receiverVC animated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Someting went wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

# pragma mark CLManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}
@end
