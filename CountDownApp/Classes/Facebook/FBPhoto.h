//
//  FBFriend.h
//  bluemonday
//
//  Created by  on 4/2/12.
//  Copyright (c) 2012 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBPhoto : NSObject
@property (nonatomic, strong) NSString* fbPhotoId;
@property (nonatomic, strong) NSString* fbPhotoMessage;
@property (nonatomic, strong) NSString* fbPhotoPictureURL;
@property (nonatomic, strong) NSString* fbPhotoDate;
@property (nonatomic, strong) NSMutableArray* fbCommentList;

@property (nonatomic, assign) BOOL bSelected;
@property (nonatomic, strong) UIImage* profilePhoto;
@end
