//
//  FacebookManager.h
//  aspire
//
//  Created by Satyadev Sain on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FBLoginButton.h"

#define FRIENDLIST_LOADED_NOTIFICATION      @"FriendlistLoaded"
#define ALBUMLIST_LOADED_NOTIFICATION      @"AlbumlistLoaded"
#define PHOTOLIST_LOADED_NOTIFICATION      @"PhotolistLoaded"

@protocol FacebookManagerDelegate;


extern NSString* const kFacebookUpdateSuccessNotificationName;
extern NSString* const kFacebookUpdateFailureNotificationName;

@interface FacebookManager : NSObject<FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate> {
  id<FacebookManagerDelegate>  delegate_;
  Facebook* facebook_;
  NSArray* permissions_;
}

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) id<FacebookManagerDelegate> delegate;
@property (nonatomic, strong) FBRequest*    reqFriendList;
@property (nonatomic, strong) FBRequest*    reqAlbumList;
@property (nonatomic, strong) FBRequest*    reqFriendAlbumList;
@property (nonatomic, strong) FBRequest*    reqFriendPhoto;
@property (nonatomic, strong) FBRequest*    reqPhotoList;
@property (nonatomic, strong) FBRequest*    reqMyInfo;

+ (FacebookManager *) sharedInstance;
- (void) postMessage:(NSString *)message;
- (void) postMessage:(NSString *)message andCaption:(NSString *)caption andImage:(UIImage *)image;
- (void) postPuzzleMessage:(NSString *)message andImage:(UIImage *)image;
- (void) postComment:(NSString*) postId andComment:(NSString *)message;
- (void) getFriends;
- (void) getAlbums;
- (void) getPhotos: (NSString *) albumId;
- (void) getFriendPhotos: (NSString *) albumId;
- (void) getFriendLargePicture: (NSString *) friendId;
- (void) getMyInfo;
- (void) inviteFriendtoApp: (FBFriend*) friend;
- (void) logout;
@end

@protocol FacebookManagerDelegate <NSObject>
@optional
- (void) facebookLoginSucceeded;
- (void) facebookLoginFailed;
- (void) facebookloggedout;
- (void) friendsListLoaded:(NSMutableArray*) array;
- (void) albumsListLoaded:(NSMutableArray*) array;
- (void) friendAlbumLoaded:(id) friendAlbum;
- (void) friendLargePictureLoaded:(id) friendPhoto;
- (void) photosListLoaded:(NSMutableArray*) array;
- (void) myInfoLoaded: (NSMutableDictionary*) myInfo;
- (void) requestFailed:(NSError*) error;
- (void) messagePostedSuccessfully;
- (void) messagePostingFailedWithError:(NSError*) error;
- (void) messageCommentedSuccessfully;
- (void) messageCommentingFailedWithError:(NSError*) error;
@end



