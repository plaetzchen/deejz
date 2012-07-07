//
//  SenderViewController.m
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import "SenderViewController.h"
#import "SearchCell.h"
#import "VetoCell.h"
#import "SongListCell.h"
#import "DeezerItem.h"
#import "JSONKit.h"
#import "DictionaryParser.h"
#import "DeezerTrack.h"
#import "DeezerAlbum.h"
#import "DeezerArtist.h"
#import "UIImageView+AFNetworking.h"

@implementation SenderViewController
@synthesize songTableView,resultArray,selectedKind,selectedItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedItems = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [[DeezerSession sharedSession] setRequestDelegate:self];
}
- (void)viewDidUnload
{
    [self setSongTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
        case 2:
            return resultArray.count;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Search";
            break;
        case 1:
            return @"Veto";
        case 2:
            return @"Songs";
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            static NSString *searchCellIdentifier = @"SearchCell";
            
            SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            } 
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            break;
        }
        case 1:{
            static NSString *vetoCellIdentifier = @"VetoCell";
            
            VetoCell *cell = (VetoCell *)[tableView dequeueReusableCellWithIdentifier:vetoCellIdentifier];
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VetoCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            } 
            return cell;
            break;
        }
        default:{
            static NSString *songListCelllIdentifier = @"SongListCell";
            
            SongListCell *cell = (SongListCell *)[tableView dequeueReusableCellWithIdentifier:songListCelllIdentifier];
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SongListCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            NSLog(@"Class: %@",NSStringFromClass([[resultArray objectAtIndex:indexPath.row] class]));
            
            if ([[resultArray objectAtIndex:indexPath.row] isKindOfClass:[DeezerTrack class]]){
                DeezerTrack *track = [resultArray objectAtIndex:indexPath.row];
                cell.titleLabel.text = track.title;
                cell.artistLabel.text = track.artist.name;
                [cell.coverImageView setImageWithURL:[NSURL URLWithString:track.album.image] placeholderImage:[UIImage imageNamed:@"empty_cover"]];
                [cell preparePlayerWithURL:track.preview AndID:track.deezerID];
            }
            else if ([[resultArray objectAtIndex:indexPath.row] isKindOfClass:[DeezerAlbum class]]){
                DeezerAlbum *album = [resultArray objectAtIndex:indexPath.row];
                cell.titleLabel.text = album.title;
                cell.artistLabel.text = album.artist.name;
            }
            else if ([[resultArray objectAtIndex:indexPath.row] isKindOfClass:[DeezerArtist class]]){
                DeezerArtist *artist = [resultArray objectAtIndex:indexPath.row];
                cell.titleLabel.text = artist.name;
                cell.artistLabel.text = @"";
            }
                        
            return cell;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 88;
            break;
        case 1:
            return 44;
        default:
            return 72;
            break;
    }
}
# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2){
        if (![self.selectedItems containsObject:[resultArray objectAtIndex:indexPath.row]]){
            [self.selectedItems addObject:[resultArray objectAtIndex:indexPath.row]];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            [self.selectedItems removeObject:[resultArray objectAtIndex:indexPath.row]];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (IBAction)signInTapped:(id)sender {
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
            break;
        case 1:
            [[DeezerSession sharedSession] searchArtist:string];
        case 2:
            [[DeezerSession sharedSession] searchAlbum:string];
        default:
            break;
    }
    
}

# pragma mark DeezerSessionDelegate

- (void)deezerSessionRequestDidReceiveResponse:(NSData *)data {
    NSDictionary* dictionary = [data objectFromJSONData];
    self.resultArray = [DictionaryParser getItemsFromDictionary:dictionary];
    [self.songTableView reloadData];
}

@end
