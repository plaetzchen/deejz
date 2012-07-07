#import <UIKit/UIKit.h>
#import "DeezerSession.h"
#import "DeezerAudioPlayer.h"
#import "PlayerAndBufferSlider.h"

@interface AudioPlayerController : UIViewController <DeezerSessionRequestDelegate, DeezerAudioPlayerDelegate, PlayerAndBufferSliderDelegate> {
    IBOutlet UIImageView*   _coverImageView;
    IBOutlet UILabel*       _nameLabel;
    IBOutlet UILabel*       _artistNameLabel;
    IBOutlet UIButton*      _playButton;
    IBOutlet PlayerAndBufferSlider* _progressSliderView;

    NSString*           _trackID;
    NSString*           _trackName;
    NSString*           _artistName;
    NSString*           _cover;
    DeezerPlayerState   _playerState;
    BOOL                _btnActionIsPlay;
}

- (id)initWithTrackId:(NSString*)trackID title:(NSString*)title artistName:(NSString*)artistName andCover:(NSString*)cover;
- (IBAction)onPlayButtonPushed:(id)sender;

@end
