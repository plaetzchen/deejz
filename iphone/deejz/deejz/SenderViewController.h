//
//  SenderViewController.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCellDelegate.h"
#import "DeezerSession.h"
#import "MBProgressHUD.h"
#import "SearchCell.h"
#import "VetoCell.h"
#import "DeezerTrack.h"
@interface SenderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SearchCellDelegate,DeezerSessionRequestDelegate,DeezerSessionConnectionDelegate,VetoCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *songTableView;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *signInButton;
@property (atomic) NSInteger selectedKind;
@property (nonatomic,retain) MBProgressHUD *infoHud;
@property (nonatomic, strong) SearchCell *sectionHeader;
@property (nonatomic, strong) VetoCell *tableHeader;
@property (nonatomic, strong) DeezerTrack *selectedTrack;
@property (nonatomic, strong) NSString *currentPartySlug;
@property (nonatomic, strong) NSTimer *currentSongTimer;
@property (strong, nonatomic) IBOutlet UINavigationBar *theNavBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *theNavItem;
@property (atomic) int currentSongId;

- (IBAction)signInTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
- (void)sendSelectedSongs;
@end
