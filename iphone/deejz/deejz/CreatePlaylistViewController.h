//
//  CreatePlaylistViewController.h
//  deejz
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Call a Nerd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePlaylistViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)cancelButtonTapped:(id)sender;

- (IBAction)createButtonTapped:(id)sender;
@end