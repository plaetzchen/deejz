//
//  SenderViewController.m
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import "SenderViewController.h"

#import "SongListCell.h"
#import "DeezerItem.h"
#import "JSONKit.h"
#import "DictionaryParser.h"
#import "DeezerTrack.h"
#import "DeezerAlbum.h"
#import "DeezerArtist.h"
#import "DeezerSession.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "NSString+URLHelper.h"
#import "UIBarButtonItem+CustomImageButton.h"

@implementation SenderViewController
@synthesize theNavBar;
@synthesize theNavItem;
@synthesize signInButton;
@synthesize songTableView,resultArray,selectedKind,selectedItems,gestureInt,currentSongTimer,infoHud,sectionHeader,tableHeader,selectedTrack,currentPartySlug,currentSongId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedItems = [NSMutableArray arrayWithCapacity:10];
        gestureInt = [[GesturesInterpreter alloc] init];
        gestureInt.delegate = self;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.songTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.theNavBar setBackgroundImage:[UIImage imageNamed:@"start_nav_bar"] forBarMetrics:UIBarMetricsDefault];

    self.theNavItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_bar_btn_back"] target:self action:@selector(cancelTapped:)];
    
    if ([[DeezerSession sharedSession] isSessionValid]){
        self.theNavItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_bar_btn_signout"] target:self action:@selector(signInTapped:)];
    }
    else {
        self.theNavItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_bar_btn_signin"] target:self action:@selector(signInTapped:)]; 
    }
    if (!self.tableHeader){
        self.tableHeader = [[VetoCell alloc]init];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VetoCell" owner:self options:nil];
        self.tableHeader = [nib objectAtIndex:0];
        [self.tableHeader setDelegate:self];
    }
    self.songTableView.tableHeaderView = self.tableHeader;
    self.tableHeader.currentSongLabel.text = @"";
    
    
}

- (void)viewWillAppear:(BOOL)animated {
      [gestureInt setDelegate:self];

    
    [[DeezerSession sharedSession] setRequestDelegate:self];
    [[DeezerSession sharedSession] setConnectionDelegate:self];
    
    self.currentSongTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadCurrentSong:) userInfo:nil repeats:YES];
    
    [[DeezerSession sharedSession] searchTrack:@"Daft Punk"];

}

- (void)reloadCurrentSong:(NSTimeInterval *)ti {
    NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/%@/current_song.json", self.currentPartySlug];
    NSLog(@"URL: %@",theURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *data = JSON;
        if (data.count > 0){
            NSDictionary *song = [data objectAtIndex:0];
            self.currentSongId = [[song objectForKey:@"pk"] intValue];
            NSDictionary *songFields = [song objectForKey:@"fields"];
            self.tableHeader.currentSongLabel.text = [songFields objectForKey:@"title"];
        }
        else {
            self.tableHeader.currentSongLabel.text = @"Nothing";
        }
    } failure:nil];
    [operation start];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[DeezerSession sharedSession] setRequestDelegate:nil];
    [[DeezerSession sharedSession] setConnectionDelegate:nil];
    [gestureInt setDelegate:nil];
    [self.currentSongTimer invalidate];
    self.currentSongTimer = nil;
}
- (void)viewDidUnload
{
    [self setSongTableView:nil];
    [self setSignInButton:nil];
    [self setTheNavBar:nil];
    [self setTheNavItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    return resultArray.count;
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
            
            if ([[resultArray objectAtIndex:indexPath.row] isKindOfClass:[DeezerTrack class]]){
                DeezerTrack *track = [resultArray objectAtIndex:indexPath.row];
                cell.titleLabel.text = track.title;
                cell.artistLabel.text = track.artist.name;
                
                [cell.coverImageView setImageWithURL:[NSURL URLWithString:track.album.image] placeholderImage:[UIImage imageNamed:@"empty_cover"]];
                [cell preparePlayerWithURL:track.preview AndID:track.deezerID];
                if ([cell.deezerId isEqualToString:self.selectedTrack.deezerID]){
                    NSLog(@"Jackpot!");
                    [cell setTheCellSelected:YES];
                }
                else {
                    [cell setTheCellSelected:NO];
                }
            }
                        
            return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}
# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.selectedTrack){
        self.selectedTrack = [self.resultArray objectAtIndex:indexPath.row];
        SongListCell *cell = (SongListCell *)[self.songTableView cellForRowAtIndexPath:indexPath];
        [cell setTheCellSelected:YES];
    }
    else {
        SongListCell *cell = (SongListCell *)[self.songTableView cellForRowAtIndexPath:indexPath];
        if ([cell.deezerId isEqualToString:self.selectedTrack.deezerID]){
            [cell setTheCellSelected:NO];
            self.selectedTrack = nil;
        }
        else {
            [cell setTheCellSelected:YES];
            self.selectedTrack = [self.resultArray objectAtIndex:indexPath.row];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0){
        if (!self.sectionHeader){
            self.sectionHeader = [[SearchCell alloc]init];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
            self.sectionHeader = [nib objectAtIndex:0];
            self.sectionHeader.delegate = self;
        }
        return self.sectionHeader;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 97;
}
- (IBAction)signInTapped:(id)sender {
    if ([[DeezerSession sharedSession] isSessionValid]){
        [[DeezerSession sharedSession] disconnect];
    }
    else {
        [[DeezerSession sharedSession] connectToDeezerWithPermissions:[NSArray arrayWithObjects:@"basic_access",@"manage_library", nil]];
    }
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

# pragma mark SearchCellDeleage

- (void)searchCellDidSelectGenre {
    
    
}

- (void)searchCellSearchFor:(NSString *)string Kind:(NSInteger)kind {
    self.selectedKind = kind;
    switch (kind) {
        case 0:
            [[DeezerSession sharedSession] searchTrack:string];
            infoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            infoHud.mode = MBProgressHUDModeIndeterminate;
            infoHud.labelText = @"Searching";
            break;
        case 1:
            [[DeezerSession sharedSession] searchArtist:string];
            infoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            infoHud.mode = MBProgressHUDModeIndeterminate;
            infoHud.labelText = @"Searching";
        case 2:
            [[DeezerSession sharedSession] searchAlbum:string];
            infoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            infoHud.mode = MBProgressHUDModeIndeterminate;
            infoHud.labelText = @"Searching";
        default:
            break;
    }
    
}

# pragma mark DeezerSessionDelegate

- (void)deezerSessionRequestDidReceiveResponse:(NSData *)data {
    NSDictionary* dictionary = [data objectFromJSONData];
    self.resultArray = [DictionaryParser getItemsFromDictionary:dictionary];
    if (self.resultArray.count > 0){
        [infoHud hide:YES];
    }
    else {
        [infoHud hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"We could'nt find any track or Deezer has some problmes." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [self.songTableView reloadData];
}

- (void)deezerSessionDidConnect {
        self.theNavItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_bar_btn_signout"] target:self action:@selector(signInTapped:)];
}

- (void)deezerSessionDidDisconnect {
    self.theNavItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_bar_btn_signin"] target:self action:@selector(signInTapped:)]; 
}
# pragma mark  GesturesInterpreterDelegate

- (void)gesturesInterpreterDidDetectThrow:(GesturesInterpreter *)aGestureInterpreter {
    [self sendSelectedSongs];
}

- (IBAction)sendButtonTapped:(id)sender {
    [self sendSelectedSongs];
}

- (void)sendSelectedSongs {
    if (self.selectedTrack > 0){
        infoHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        infoHud.mode = MBProgressHUDModeIndeterminate;
        infoHud.labelText = @"Sending";
        NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/%@/add_song/", self.currentPartySlug];
        NSLog(@"URL: %@",theURL);
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:theURL]];
        httpClient.parameterEncoding = AFJSONParameterEncoding;
        AFNetworkActivityIndicatorManager * newactivity = [[AFNetworkActivityIndicatorManager alloc] init]; 
        newactivity.enabled = YES;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithUUID], @"uuid",self.selectedTrack.deezerID,@"deezer_id",[NSString stringWithFormat:@"%@ - %@",self.selectedTrack.artist.name,self.selectedTrack.title],@"title",nil];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:theURL parameters:params];
                
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self showSuccess];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"ERROR %@",error.localizedDescription);
            [self showError];
        }];
        
        [operation start];
    }
}

- (void)showError{
    [infoHud hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Oh noes that doesn't work" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)showSuccess {
    [infoHud hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your song is on the playlist now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)showVetoFail{
    [infoHud hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You already vetoed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)showVetoSuccess {
    [infoHud hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your veto is count" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)showVoteFail{
    [infoHud hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You already voted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)showVoteSuccess {
    [infoHud hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your vote is count" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
}

#pragma mark VetoCellDelegate

- (void)vetoCellDidVoteDislike {
    if (self.currentSongId != 0){
        
        NSString *uuid = [NSString stringWithUUID];
        NSString *stug = self.currentPartySlug;
        NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/%@/song/%d/veto/%@/",stug ,self.currentSongId,uuid];
        
        NSLog(@"URL: %@",theURL);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [self showVetoSuccess];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            [self showVetoFail];
        }];
        [operation start];
    }
}

- (void)vetoCellDidVoteLike {
    if (self.currentSongId != 0){
        NSString *theURL = [NSString stringWithFormat:@"http://deejz.herokuapp.com/party/%@/song/%d/vote/%@/", self.currentPartySlug,self.currentSongId,[NSString stringWithUUID]];
        NSLog(@"URL: %@",theURL);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [self showVetoSuccess];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            [self showVetoFail];
        }];
        [operation start];
    }
}
@end
