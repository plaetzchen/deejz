//
//  ReceiverViewController.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeezerPlaylist.h"
#import "DeezerSession.h"
#import "DeezerAudioPlayer.h"
#import "DeezerTrack.h"
#import "MBProgressHUD.h"
#import "ReceiverTablePlayerSectionHeaderDelegate.h"
#import "ReceiverTablePlayerSectionHeader.h"
#import "ReceiverTableHeaderView.h"

@interface ReceiverViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ReceiverTablePlayerSectionHeaderDelegate,DeezerSessionRequestDelegate,DeezerAudioPlayerDelegate>
- (IBAction)cancelButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *playListTable;
@property (strong, nonatomic) NSTimer *currentSongTimer;
@property (strong, nonatomic) NSString *partyPlaylist;
@property (strong, nonatomic) NSMutableArray *thePlaylist;
@property (strong, nonatomic) MBProgressHUD *infoHud;
@property (strong, nonatomic) IBOutlet UINavigationBar *theNavBar;
@property (strong, nonatomic) ReceiverTablePlayerSectionHeader *sectionHeader;
@property (strong, nonatomic) ReceiverTableHeaderView *headerView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (atomic) int durationOfCurrentSong;
@property (strong, nonatomic) DeezerTrack *upcomingSong;
@property (strong, nonatomic) NSDictionary *upcomingSongStreamInfo;
@property (strong, nonatomic) NSTimer *playlistTimer;
@property (strong, nonatomic) NSString *partyName;
- (void)lookupPlaylist;
@end
