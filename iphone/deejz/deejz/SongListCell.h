//
//  SongListCell.h
//  djeez
//
//  Created by Philip Brechler on 07.07.12.
//  Copyright (c) 2012 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeezerAudioPlayer.h"

@interface SongListCell : UITableViewCell <DeezerAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) NSString *previewUrl;
@property (strong, nonatomic) NSString *deezerId;
@property (atomic) BOOL trackSelected;
@property (strong, nonatomic) IBOutlet UIImageView *theBackgroundImage;

- (IBAction)playPauseTapped:(id)sender;
- (void)setTheCellSelected:(BOOL)selected;
- (void)preparePlayerWithURL:(NSString *)url AndID:(NSString *)theId;

@end
