//
//  ViewController.m
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import "StartViewController.h"
#import "ReceiverViewController.h"
#import "SenderViewController.h"
#import "DeezerSession.h"
#import "CreatePlaylistViewController.h"
#import "AFNetworking.h"
#import "StartListCell.h"
@implementation StartViewController
@synthesize joinImage;
@synthesize tableMask;
@synthesize noPartiesImageView;
@synthesize theNavBar;
@synthesize partiesTable,loggedIn,availableParties,clManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clManager = [[CLLocationManager alloc]init];
    [self.clManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.clManager setDelegate:self];
    [self.clManager startUpdatingLocation];
    self.availableParties = [NSMutableArray arrayWithCapacity:5];
    [self.theNavBar setBackgroundImage:[UIImage imageNamed:@"start_nav_bar"] forBarMetrics:UIBarMetricsDefault];
    self.partiesTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_background"]];
    self.partiesTable.hidden = TRUE;
    self.noPartiesImageView.hidden =FALSE;
    self.joinImage.hidden = TRUE;
    self.tableMask.hidden = TRUE;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setPartiesTable:nil];
    [self setTheNavBar:nil];
    [self setNoPartiesImageView:nil];
    [self setJoinImage:nil];
    [self setTableMask:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.clManager setDelegate:self];
    [[DeezerSession sharedSession] setConnectionDelegate:self];
    [self setLoggedIn:[[DeezerSession sharedSession] isSessionValid]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.clManager setDelegate:nil];
    [[DeezerSession sharedSession] setConnectionDelegate:nil];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableParties.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *startListCellIdentifier = @"StartListCell";
    
    StartListCell *cell = (StartListCell *)[tableView dequeueReusableCellWithIdentifier:startListCellIdentifier];
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StartListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *party = [self.availableParties objectAtIndex:indexPath.row];
    cell.partyNameLabel.text = [party objectForKey:@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SenderViewController *senderVC = [[SenderViewController alloc]initWithNibName:@"SenderViewController" bundle:[NSBundle mainBundle]];
    senderVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    senderVC.currentPartySlug = [[self.availableParties objectAtIndex:indexPath.row] objectForKey:@"slug"];
    [self presentModalViewController:senderVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (IBAction)createPartyTapped:(id)sender {
    if (self.loggedIn){
        CreatePlaylistViewController *createVC = [[CreatePlaylistViewController alloc]initWithNibName:@"CreatePlaylistViewController" bundle:[NSBundle mainBundle]];
        [self presentModalViewController:createVC animated:YES];
    }
    else {
        [[DeezerSession sharedSession] connectToDeezerWithPermissions:[NSArray arrayWithObjects:@"basic_access",@"manage_library", nil]];
    }
}

- (void)deezerSessionDidConnect {
    [self setLoggedIn:YES];
    CreatePlaylistViewController *createVC = [[CreatePlaylistViewController alloc]initWithNibName:@"CreatePlaylistViewController" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:createVC animated:YES];

}

- (void)deezerSessionDidDisconnect {
    [self  setLoggedIn:NO];
}

- (void)deezerSessionConnectionDidFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"There was an error: %@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

# pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/near/%f/%f/",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    NSLog(@"URL: %@",theURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.availableParties removeAllObjects];
        NSArray *parties = JSON;
        for (NSDictionary *party in parties){
            NSDictionary *fields = [party objectForKey:@"fields"];
            [self.availableParties addObject:fields];
        }
        [self refresh];
    } failure:nil];
    [operation start];
}


- (void)refresh {
    if (self.availableParties.count > 0){
        self.partiesTable.hidden = FALSE;
        self.noPartiesImageView.hidden =TRUE;
        self.joinImage.hidden = FALSE;
        self.tableMask.hidden = FALSE;
    }
    else {
        self.partiesTable.hidden = TRUE;
        self.noPartiesImageView.hidden =FALSE;
        self.joinImage.hidden = TRUE;
        self.tableMask.hidden = TRUE;
    }
    [self.partiesTable reloadData];
}
@end
