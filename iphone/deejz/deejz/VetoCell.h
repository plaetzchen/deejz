//
//  VetoCell.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VetoCellDelegate.h"
@interface VetoCell : UIView 

- (IBAction)likePressed:(id)sender;
- (IBAction)dislikeTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *currentSongLabel;
@property (atomic, strong) id <VetoCellDelegate>delegate;
@end
