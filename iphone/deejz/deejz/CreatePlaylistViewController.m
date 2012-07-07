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

@interface CreatePlaylistViewController ()

@end

@implementation CreatePlaylistViewController
@synthesize nameTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)createButtonTapped:(id)sender {
    [[DeezerSession sharedSession] createPlaylistNamed:[nameTextField text] forUser:@"me"];
    
    ReceiverViewController *receiverVC = [[ReceiverViewController alloc]initWithNibName:@"ReceiverViewController" bundle:[NSBundle mainBundle]];
    receiverVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:receiverVC animated:YES];

}

# pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [nameTextField resignFirstResponder];
    return YES;
}
@end
