//
//  ReceiverViewController.m
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import "ReceiverViewController.h"
#import "DeezerSession.h"
#import "DeezerPlaylist.h"
#import "AFNetworking.h"
#import "SongListCell.h"
#import "DeezerTrack.h"
#import "DeezerAlbum.h"
#import "DeezerArtist.h"
#import "DeezerUser.h"
#import "ReceiverTableHeaderView.h"
#import "ReceiverTablePlayerSectionHeader.h"
#import "JSONKit.h"
#import "UIBarButtonItem+CustomImageButton.h"

@implementation ReceiverViewController
@synthesize theNavBar;
@synthesize playListTable,currentSongTimer,partyPlaylist,thePlaylist,infoHud,sectionHeader,headerView,navItem,durationOfCurrentSong,upcomingSong,upcomingSongStreamInfo;
@synthesize playlistTimer;
@synthesize partyName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
   
    if (!self.headerView){
        self.headerView = [[ReceiverTableHeaderView alloc]init];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceiverTableHeaderView" owner:self options:nil];
        headerView = [nib objectAtIndex:0];
    }
    [headerView setUpForArtist:@"" title:@"" andDuration:0];
    
    self.playListTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.theNavBar setBackgroundImage:[UIImage imageNamed:@"start_nav_bar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_bar_btn_back"] target:self action:@selector(cancelButtonTapped:)];
    
    self.playListTable.tableHeaderView = headerView;
    self.navItem.title = self.partyName;
    
    self.currentSongTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadCurrentSong:) userInfo:nil repeats:YES];
    
    }

- (void)reloadCurrentSong:(NSTimeInterval *)ti {
    NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/%@/current_song.json", self.partyPlaylist];
    NSLog(@"URL: %@",theURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *data = JSON;
        if (data.count > 0){
            NSDictionary *song = [data objectAtIndex:0];
            NSDictionary *songFields = [song objectForKey:@"fields"];
            if ([[songFields objectForKey:@"vetoed"] boolValue]){
                [self receiverTablePlayerDidFwd];
            }
        }
    } failure:nil];
    [operation start];
}


- (void)viewDidAppear:(BOOL)animated {
    NSString *string = [NSString stringWithFormat:@"http://api.deezer.com/2.0/user/%@/charts",[[[DeezerSession sharedSession] deezerConnect] userId]];
     [[DeezerSession sharedSession] requestWithURLString:string];
    [[DeezerSession sharedSession] setRequestDelegate:self];
    
}

- (void)refresh {
    [self.playListTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.playlistTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(lookupPlaylist) userInfo:nil repeats:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[DeezerAudioPlayer sharedSession] stop];
    [[DeezerAudioPlayer sharedSession] setDelegate:nil];
    [[DeezerSession sharedSession] setConnectionDelegate:nil];
    [[DeezerSession sharedSession] setRequestDelegate:nil];
    
}

- (void)viewDidUnload
{
    [self setPlayListTable:nil];
    [self setTheNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.thePlaylist.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *songListCelllIdentifier = @"SongListCell";
    
    SongListCell *cell = (SongListCell *)[tableView dequeueReusableCellWithIdentifier:songListCelllIdentifier];
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SongListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    NSDictionary *track = [self.thePlaylist objectAtIndex:indexPath.row];
    NSString *string = [track objectForKey:@"title"];
    NSArray *strings = [string componentsSeparatedByString:@" - "];
    cell.titleLabel.text = [strings objectAtIndex:1];
    cell.artistLabel.text = [strings objectAtIndex:0];
    cell.playPauseButton.hidden = YES;
    
    return cell;
    
}
# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0){
        if (!self.sectionHeader){
            self.sectionHeader = [[ReceiverTablePlayerSectionHeader alloc]init];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceiverTablePlayerSectionHeader" owner:self options:nil];
            self.sectionHeader = [nib objectAtIndex:0];
            self.sectionHeader.delegate = self;
        }
        return self.sectionHeader;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 57;
}

- (void)lookupPlaylist {

    NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/%@/playlist.json",self.partyPlaylist];
    NSLog(@"URL: %@",theURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.thePlaylist) {
            self.thePlaylist = [NSMutableArray arrayWithCapacity:10];
        }
        else {
            [self.thePlaylist removeAllObjects];
        }
        NSArray *objects = JSON;
        for (NSDictionary *playlistobject in objects){
            [self.thePlaylist addObject:[playlistobject objectForKey:@"fields"]];
        }
        [self refresh];
    } failure:nil];
    [operation start];

}

#pragma mark ReceiverTablePlayerSectionHeaderDelegate

- (void)receiverTablePlayerDidPlayPause {
    if (self.partyPlaylist){
        if ([[DeezerAudioPlayer sharedSession] playerState] == DeezerPlayerState_Initialized){
            NSDictionary *track = [thePlaylist objectAtIndex:0];
            [[DeezerSession sharedSession] requestTrack:[track objectForKey:@"deezer_id"]];
        }
        else if ([[DeezerAudioPlayer sharedSession] playerState] == DeezerPlayerState_Playing){
            [[DeezerAudioPlayer sharedSession] pause];
            
        }
        else if ([[DeezerAudioPlayer sharedSession] playerState] == DeezerPlayerState_Paused){
            [[DeezerAudioPlayer sharedSession] play];
        }
        
    }
}

- (void)receiverTablePlayerDidStop {
    
}
- (void)receiverTablePlayerDidFaceBook {
    
}
- (void)receiverTablePlayerDidFwd {
    NSLog(@"Loading next song");
    
    [self lookupPlaylist];
    
    NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/%@/next_song.json",self.partyPlaylist];
    NSLog(@"URL: %@",theURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *track = [[JSON objectAtIndex:0] objectForKey:@"fields"];
        [[DeezerSession sharedSession] requestTrack:[track objectForKey:@"deezer_id"]];
        
    } failure:nil];
    [operation start];

}

#pragma mark DeezerSessionRequestDelegate 

- (void)deezerSessionRequestDidReceiveResponse:(NSData *)data {
    
    if (!self.upcomingSong){
        NSDictionary* dict = [data objectFromJSONData];
        
        DeezerTrack* track = [[DeezerTrack alloc] initWithDictionary:dict];
        
        NSString* stream = [dict objectForKey:@"stream"];
        
        if ([track isReadable] && [stream isKindOfClass:[NSString class]]) {
            [self.headerView setUpForArtist:track.artist.name title:track.title andDuration:track.duration];
            self.durationOfCurrentSong = track.duration;
            [[DeezerAudioPlayer sharedSession] setDelegate:self];
            [[DeezerAudioPlayer sharedSession] initPlayerForTrackWithDeezerId:[track deezerID]
                                                                       stream:stream
                                                             forUserWithToken:[[[DeezerSession sharedSession] deezerConnect] accessToken]
                                                                        andId:[[[DeezerSession sharedSession] deezerConnect] userId]];
        }
    }
    else {
        NSDictionary* dict = [data objectFromJSONData];
        
        DeezerTrack* track = [[DeezerTrack alloc] initWithDictionary:dict];
        
        self.upcomingSong = track;
        self.upcomingSongStreamInfo = dict;
    }
}

# pragma mark DeezerAudioPlayerDelegate

- (void)playerStateChanged:(DeezerPlayerState)playerState {
    switch (playerState) {
        case DeezerPlayerState_Playing:
            NSLog(@"Playing");
            break;
        case DeezerPlayerState_Paused:
            NSLog(@"Paused");
            break;
        case DeezerPlayerState_Stopped:
            NSLog(@"Stopped");
            break;
        case DeezerPlayerState_Finished:
            if (self.upcomingSong){
                NSString* stream = [self.upcomingSongStreamInfo objectForKey:@"stream"];
                
                if ([self.upcomingSong isReadable] && [stream isKindOfClass:[NSString class]]) {
                    [self.headerView setUpForArtist:self.upcomingSong.artist.name title:self.upcomingSong.title andDuration:self.upcomingSong.duration];
                    self.durationOfCurrentSong = self.upcomingSong.duration;
                    [[DeezerAudioPlayer sharedSession] setDelegate:self];
                    [[DeezerAudioPlayer sharedSession] initPlayerForTrackWithDeezerId:[self.upcomingSong deezerID]
                                                                               stream:stream
                                                                     forUserWithToken:[[[DeezerSession sharedSession] deezerConnect] accessToken]
                                                                                andId:[[[DeezerSession sharedSession] deezerConnect] userId]];
                    self.upcomingSong = nil;
                }
            }
            NSLog(@"Finished");
        case DeezerPlayerState_Ready:
            NSLog(@"Ready");
            break;
        case DeezerPlayerState_Initialized:
            NSLog(@"Itialized");
            break;
        case DeezerPlayerState_WaitingForData:
            NSLog(@"WaitingForData");
            break;
        default:
            break;
    }
}

- (void)playerProgressChanged:(float)playerProgress {
    [self.headerView updateTime:playerProgress];
    if (durationOfCurrentSong - 2 < playerProgress){
        NSLog(@"Loading next song");
        
        [self lookupPlaylist];
        
        NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/%@/next_song.json",self.partyPlaylist];
        NSLog(@"URL: %@",theURL);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *track = [[JSON objectAtIndex:0] objectForKey:@"fields"];
            [[DeezerSession sharedSession] requestTrack:[track objectForKey:@"deezer_id"]];
        
        } failure:nil];
        [operation start];
        
    }
}

- (void)bufferProgressChanged:(float)bufferProgress{ 
    
}
- (void)trackDurationDidChange:(long)trackDuration{
    
}

- (void)bufferStateChanged:(BufferState)bufferState {
    
}


@end
