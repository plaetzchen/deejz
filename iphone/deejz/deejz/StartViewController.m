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

@implementation StartViewController
@synthesize partiesTable,loggedIn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setPartiesTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    [[DeezerSession sharedSession] setConnectionDelegate:self];
    [self setLoggedIn:[[DeezerSession sharedSession] isSessionValid]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DeezerSession sharedSession] setConnectionDelegate:nil];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PartyListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = @"Test";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SenderViewController *senderVC = [[SenderViewController alloc]initWithNibName:@"SenderViewController" bundle:[NSBundle mainBundle]];
    senderVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:senderVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)createPartyTapped:(id)sender {
    if (self.loggedIn){
        ReceiverViewController *receiverVC = [[ReceiverViewController alloc]initWithNibName:@"ReceiverViewController" bundle:[NSBundle mainBundle]];
        receiverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:receiverVC animated:YES];
    }
    else {
        [[DeezerSession sharedSession] connectToDeezerWithPermissions:[NSArray arrayWithObjects:@"basic_access",@"manage_library", nil]];
    }
}

- (void)deezerSessionDidConnect {
    [self setLoggedIn:YES];
    ReceiverViewController *receiverVC = [[ReceiverViewController alloc]initWithNibName:@"ReceiverViewController" bundle:[NSBundle mainBundle]];
    receiverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:receiverVC animated:YES];
}

- (void)deezerSessionDidDisconnect {
    [self  setLoggedIn:NO];
}

- (void)deezerSessionConnectionDidFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"There was an error: %@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
