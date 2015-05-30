//
//  FBComment.h
//  bluemonday
//
//  Created by  on 4/2/12.
//  Copyright (c) 2012 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBComment : NSObject
@property (nonatomic, strong) NSString* fbCommentId;
@property (nonatomic, strong) NSString* fbCommentMessage;
@property (nonatomic, strong) NSString* fbCommentAuthor;
@property (nonatomic, strong) NSString* fbCommentDate;
@end
