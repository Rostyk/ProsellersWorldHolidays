//
//  FacebookManager.m
//  aspire
//
//  Created by Satyadev Sain on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookManager.h"
#import "FBFriend.h"
#import "FBAlbum.h"
#import "FBPhoto.h"
#import "FBComment.h"

static NSString* kAppId = @"198640436927703";
//static NSString* kAppSecretKey = @"d235e630dfeeb497a83e6c913097fa02";

NSString* const kFacebookUpdateSuccessNotificationName = @"FacebookUpdateSuccessful";
NSString* const kFacebookUpdateFailureNotificationName = @"FacebookUpdateFailed";
static FacebookManager *sharedInstance = nil;

@interface FacebookManager ()
- (id) initPrivately;
@end

@implementation FacebookManager

@synthesize delegate=delegate_;
@synthesize facebook=facebook_;
@synthesize reqFriendList;
@synthesize reqAlbumList;
@synthesize reqFriendAlbumList;
@synthesize reqFriendPhoto;
@synthesize reqPhotoList;
@synthesize reqMyInfo;

+ (FacebookManager *)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[self alloc] initPrivately];
  }
  return sharedInstance;
}

- (id) initPrivately {
  
  if (!kAppId) {
    NSLog(@"missing app id!");
    exit(1);
    return nil;
  }
  
  if ((self = [super init])) {
    permissions_ =  [NSArray arrayWithObjects:
                     @"read_stream", @"publish_stream", @"user_photos", @"friends_photos",
                     nil];
    facebook_ = [[Facebook alloc] initWithAppId:kAppId
                                    andDelegate:self];
    
    [facebook_ authorize:permissions_];
  }
    
//    @"friends_about_me", @"friends_activities", @"friends_birthday", @"friends_checkins", @"friends_education_history",
//    @"friends_events", @"friends_games_activity", @"friends_groups", @"friends_hometown",
//    @"friends_interests", @"friends_likes", @"friends_location", @"friends_notes", @"friends_online_presence",
//    @"friends_photo_video_tags", @"friends_photos", @"friends_questions", @"friends_relationship_details",
//    @"friends_relationships", @"friends_religion_politics", @"friends_status", @"friends_subscriptions",
//    @"friends_videos", @"friends_website", @"friends_work_history",
    
  return self;
}

- (void)postMessage:(NSString *)message {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:message,@"message",@"Test it!",@"name",nil];
    [facebook_ requestWithGraphPath:@"me/feed"  andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)postPuzzleMessage:(NSString *)message andImage:(UIImage*) image 
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:message, @"message", 
                                   @"Puzzle", @"name", 
                                   @"whoAREu?", @"caption", 
                                   @"whoAREu? is photo puzzle", @"description", 
                                   image, @"picture", nil];
    [facebook_ requestWithGraphPath:@"me/feed"  andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)postMessage:(NSString *)message andCaption:(NSString *)caption andImage:(UIImage *)image
{
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:caption forKey:@"caption"];
    [args setObject:message forKey:@"message"];
    [args setObject:UIImageJPEGRepresentation(image, 0.7) forKey:@"picture"];
    
    [facebook_ requestWithMethodName:@"photos.upload" andParams:args andHttpMethod:@"POST" andDelegate:self];
}

- (void)postComment:(NSString*) postId andComment:(NSString *)message
{
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:message forKey:@"text"];
    [args setObject:postId forKey:@"object_id"];
    [facebook_ requestWithMethodName:@"comments.add" andParams:args andHttpMethod:@"POST" andDelegate:self];
}

- (void) getAlbums
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,id", @"fields", nil];
    @autoreleasepool {
        self.reqAlbumList = [facebook_ requestWithGraphPath:@"me/albums" andParams:params andDelegate:self];
    }
}

- (void) getPhotos: (NSString *) albumId
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,id,picture,created_time,comments", @"fields", nil];
    NSString *graphPath = [NSString stringWithFormat:@"%@/photos", albumId];
    
    @autoreleasepool {
        self.reqPhotoList = [facebook_ requestWithGraphPath:graphPath andParams:params andDelegate:self];
    }
}

- (void) getFriendPhotos: (NSString *) albumId
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,id,source", @"fields", nil];
    NSString *graphPath = [NSString stringWithFormat:@"%@/photos", albumId];
    
    @autoreleasepool {
        self.reqFriendPhoto = [facebook_ requestWithGraphPath:graphPath andParams:params andDelegate:self];
    }
}

- (void) getFriends
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,id,picture,installed,email", @"fields", nil];
    @autoreleasepool {
        self.reqFriendList = [facebook_ requestWithGraphPath:@"me/friends" andParams:params andDelegate:self];
    }
}

- (void) getMyInfo
{
    @autoreleasepool {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,id,picture,gender,email,first_name,last_name", @"fields", nil];
//        self.reqMyInfo = [facebook_ requestWithGraphPath:@"me" andDelegate: self ];
        self.reqMyInfo = [facebook_ requestWithGraphPath:@"me" andParams:params andDelegate:self];
    }
}

- (void) getFriendLargePicture: (NSString *) friendId
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,id", @"fields", nil];
    NSString *graphPath = [NSString stringWithFormat:@"%@/albums", friendId];
    @autoreleasepool {
        self.reqFriendAlbumList = [facebook_ requestWithGraphPath:graphPath andParams:params andDelegate:self];
    }
}

- (void) logout
{
    [facebook_ logout: self];
}

- (void) inviteFriendtoApp: (FBFriend*) friend
{
    NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:4];
    [variables setObject:[NSString stringWithFormat:@"Hej!"                          
                          "Hej! Jeg har tilføjet dig som ven på Blå Mandag App. Tjek www.blåmandag.dk og download nu!"] forKey:@"message"];
//    [variables setObject:@"url" forKey:@"picture"];       
    [variables setObject:@"Hello" forKey:@"name"];
    [variables setObject:@"Description" forKey:@"description"];

    [facebook_ requestWithGraphPath: [NSString stringWithFormat:@"/%@/feed", friend.fbId]
                          andParams: variables
                      andHttpMethod:@"POST"
                        andDelegate:self];
}

- (void) processMyInfoQuery: (id) result
{
    NSLog(@"MyInfo - %@", result);
    [self.delegate myInfoLoaded: result];
}

- (void) processFriendsQuery:(id) result {
    NSLog(@"Friend List - %@", result);
    NSMutableArray* users = [NSMutableArray new];
    if([result isKindOfClass:[NSDictionary class]])
    {
        result = [result objectForKey: @"data"];
        if ([result isKindOfClass:[NSArray class]]) 
        {
            for(int i=0; i<[result count]; i++){                
                FBFriend* friend = [FBFriend new];
                NSDictionary *userInfo = [result objectAtIndex:i];
                friend.fbId = [userInfo objectForKey:@"id"];
                friend.fbName = [userInfo objectForKey:@"name"];
                friend.fbPicture = [userInfo objectForKey:@"picture"];
                friend.bUsingApp = [[userInfo objectForKey:@"installed"] intValue];
                [users addObject: friend];
            }
        }
    }
    facebook_.friendsList = users;
    [self.delegate friendsListLoaded: users];
}

- (void) processAlbumQuery:(id) result {
    NSLog(@"Album List - %@", result);
    NSMutableArray* albums = [NSMutableArray new];
    if([result isKindOfClass:[NSDictionary class]])
    {
        result = [result objectForKey: @"data"];
        if ([result isKindOfClass:[NSArray class]]) 
        {
            for(int i=0; i<[result count]; i++){                
                FBAlbum* album = [FBAlbum new];
                NSDictionary *albumInfo = [result objectAtIndex:i];
                album.fbAlbumId = [albumInfo objectForKey:@"id"];
                album.fbAlbumName = [albumInfo objectForKey:@"name"];
                [albums addObject: album];
            }
        }
    }
    facebook_.albumList = albums;
    [self.delegate albumsListLoaded: albums];
}

- (void) processFriendAlbumQuery:(id) result {
    NSLog(@"Friend Album List - %@", result);
    if([result isKindOfClass:[NSDictionary class]])
    {
        result = [result objectForKey: @"data"];
        if ([result isKindOfClass:[NSArray class]]) 
        {
            for(int i=0; i<[result count]; i++){                
                NSDictionary *albumInfo = [result objectAtIndex:i];
                if ([[albumInfo objectForKey:@"name"] isEqual:@"Profile Pictures"] == YES) {
                    FBAlbum* album = [FBAlbum new];
                    album.fbAlbumId = [albumInfo objectForKey:@"id"];
                    album.fbAlbumName = @"Profile Pictures";
                    facebook_.fbFriendAlbum = album;
                    NSLog(@"Friend Profile Album Loaded:%@", album.fbAlbumId);
                    [self.delegate friendAlbumLoaded: album];
                    return;
                }
            }
            NSLog(@"Friend Profile Album Doesn't Exist");
            [self.delegate friendAlbumLoaded:nil];
        }
    }
}

- (void) processFriendProfilePictureQuery:(id) result {
    NSLog(@"Friend Profile Picture - %@", result);
    if([result isKindOfClass:[NSDictionary class]])
    {
        result = [result objectForKey: @"data"];
        if ([result isKindOfClass:[NSArray class]]) 
        {
            FBPhoto* photo = [FBPhoto new];
            NSDictionary *photoInfo = [result objectAtIndex:0];
            photo.fbPhotoId = [photoInfo objectForKey:@"id"];
            photo.fbPhotoMessage = [photoInfo objectForKey:@"name"];
            photo.fbPhotoPictureURL = [photoInfo objectForKey:@"source"];
            photo.fbPhotoDate = [photoInfo objectForKey:@"created_time"];
            
            facebook_.fbFriendPhoto = photo;
            NSLog(@"Friend Profile Album Loaded:%@", photo.fbPhotoId);
            [self.delegate friendLargePictureLoaded: photo];
        }
    }
}

- (void) processPhotoQuery:(id) result {
    NSLog(@"Photo List - %@", result);
    NSMutableArray* photos = [NSMutableArray new];
    if([result isKindOfClass:[NSDictionary class]])
    {
        result = [result objectForKey: @"data"];
        if ([result isKindOfClass:[NSArray class]]) 
        {
            for(int i = 0; i < [result count]; i++) {                
                FBPhoto* photo = [FBPhoto new];
                NSDictionary *photoInfo = [result objectAtIndex:i];
                photo.fbPhotoId = [photoInfo objectForKey:@"id"];
                photo.fbPhotoMessage = [photoInfo objectForKey:@"name"];
                photo.fbPhotoPictureURL = [photoInfo objectForKey:@"picture"];
                id comments = [photoInfo objectForKey:@"comments"];
                NSMutableArray* photocomments = [NSMutableArray new];
                BOOL FClosed = NO;
                if (comments != nil) {
                    comments = [comments objectForKey: @"data"];
                    if ([comments isKindOfClass:[NSArray class]]) {
                        for (int j = 0; j < [comments count]; j++) {
                            NSDictionary *commentInfo = [comments objectAtIndex:j];
                            FBComment* comment = [FBComment new];
                            comment.fbCommentId = [commentInfo objectForKey:@"id"];
                            comment.fbCommentMessage = [commentInfo objectForKey:@"message"];
                            if ([comment.fbCommentMessage rangeOfString:@"whoAREu? has now ended"].length > 0) {
                                FClosed = YES;
                            }
                            NSDictionary* commentAuthor = [commentInfo objectForKey:@"from"];
                            comment.fbCommentAuthor = [commentAuthor objectForKey:@"name"];
                            comment.fbCommentDate = [commentInfo objectForKey:@"created_time"];
                            [photocomments addObject:comment];
                        }
                    }
                }
                photo.fbCommentList = photocomments;
                photo.fbPhotoDate = [photoInfo objectForKey:@"created_time"];
                if (FClosed == NO)
                    [photos addObject: photo];
            }
        }
    }
    facebook_.photoList = photos;
    [self.delegate photosListLoaded: photos];
}

#pragma mark Facebook login delegates
- (void)fbDidLogin {
    if ([delegate_ respondsToSelector:@selector(facebookLoginSucceeded)]) {
    [delegate_ facebookLoginSucceeded];
    }
}

-(void)fbDidNotLogin:(BOOL)cancelled {
  sharedInstance = nil;
  if ([delegate_ respondsToSelector:@selector(facebookLoginFailed)]) {
    [delegate_ facebookLoginFailed];
  }
}

-(void)fbDidLogout {
    sharedInstance = nil;
    if ([delegate_ respondsToSelector:@selector(facebookloggedout)]) {
        [delegate_ facebookloggedout];
    }    
}

#pragma mark facebook delegate methods

/**
 * FBRequestDelegate
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if (request == self.reqFriendList) {
        [self processFriendsQuery: result];
    }
    else if (request == self.reqMyInfo){
        [self processMyInfoQuery: result];
    }
    else if (request == self.reqAlbumList) {
        [self processAlbumQuery: result];
    }
    else if (request == self.reqPhotoList) {
        [self processPhotoQuery: result];
    }
    else if (request == self.reqFriendAlbumList) {
        [self processFriendAlbumQuery: result];
    }
    else if (request == self.reqFriendPhoto) {
        [self processFriendProfilePictureQuery: result];
    }
    else {
        [self.delegate messagePostedSuccessfully];
    }
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
    if ([delegate_ respondsToSelector:@selector(requestFailed:)]) {
        [delegate_ requestFailed:error];
    }
    if ([delegate_ respondsToSelector:@selector(messagePostingFailedWithError:)]) {
        [delegate_ messagePostingFailedWithError:error];
    }
}

@end
