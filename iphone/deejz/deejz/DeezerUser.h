/*
 * http://www.deezer.com/fr/developers/simpleapi/user
 */

#import "DeezerItem.h"

@interface DeezerUser : DeezerItem {
    NSString*   _name;              // The user's Deezer nickname
    NSString*   _lastName;          // The user's last name
    NSString*   _firstname;         // The user's first name
    NSString*   _email;             // The user's email
    NSDate*     _birthday;          // The user's birthday
    NSDate*     _inscriptionDate;   // The user's inscription date
    NSString*   _gender;            // The user's gender : F or M
    NSString*   _link;              // The url of the profil for the user on Deezer
    NSString*   _picture;           // The url of the user's profil picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'
    NSString*   _country;           // The user's country
}

@property (nonatomic, readonly) NSString*   name;
@property (nonatomic, readonly) NSString*   lastName;
@property (nonatomic, readonly) NSString*   firstname;
@property (nonatomic, readonly) NSString*   email;
@property (nonatomic, readonly) NSDate*     birthday;
@property (nonatomic, readonly) NSDate*     inscriptionDate;
@property (nonatomic, readonly) NSString*   gender;
@property (nonatomic, readonly) NSString*   link;
@property (nonatomic, readonly) NSString*   picture;
@property (nonatomic, readonly) NSString*   country;

@end
