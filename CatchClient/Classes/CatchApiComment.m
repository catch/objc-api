//
//  Copyright 2011 Catch.com, Inc.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//      http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

//
//  CatchApiComment.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/8/10.
//

#import "CatchApiComment.h"


// CatchApiComment is implemented in terms of CatchApiNote.  All properties 
// except parentId are just pass-throughs.
@interface CatchApiComment ()

@property(retain) CatchApiNote *impl;

@end



@implementation CatchApiComment

@synthesize parentId = parentId_;
@synthesize impl = impl_;


- (id)initWithGuts:(CatchApiNote *)guts
{
    if ((self = [super init])) {
        self.impl = guts;
    }
    
    return self;
}


- (id)initWithParentID:(NSString *)parentId 
                  text:(NSString *)text
{
    return [self initWithCommentID:nil 
                          parentId:parentId 
                           created:NOT_SET_S64 
                          modified:NOT_SET_S64 
                              text:text 
                            source:nil 
                         sourceUrl:nil];
}


- (id)initWithCommentID:(NSString *)commentId 
               parentId:(NSString *)parentId 
                created:(SInt64)created 
               modified:(SInt64)modified 
                   text:(NSString *)text 
                 source:(NSString *)source 
              sourceUrl:(NSString *)sourceUrl
{
    CatchApiComment *ret = [self initWithGuts:[[[CatchApiNote alloc] init] autorelease]];
    ret.commentId = commentId;
    ret.parentId = parentId;
    ret.created = created;
    ret.modified = modified;
    ret.text = text;
    ret.source = source;
    ret.sourceUrl = sourceUrl;
    return ret;
}


- (id)init
{
    return [self initWithCommentID:nil 
                          parentId:nil 
                           created:NOT_SET_S64 
                          modified:NOT_SET_S64 
                              text:nil 
                            source:nil 
                         sourceUrl:nil];
}


- (id)copyWithZone:(NSZone *)zone
{
    CatchApiComment *copy = [[[self class] allocWithZone:zone] initWithGuts:
                             [[self.impl copyWithZone:zone] autorelease]];
    
    return copy;
}


- (void)dealloc
{
    self.impl = nil;
    
    [super dealloc];
}


- (NSString *)commentId
{
    return self.impl.noteId;
}

- (void)setCommentId:(NSString *)commentId
{
    self.impl.noteId = commentId;
}


- (SInt64)created
{
    return self.impl.created;
}

- (void)setCreated:(SInt64)created
{
    self.impl.created = created;
}


- (SInt64)modified
{
    return self.impl.modified;
}

- (void)setModified:(SInt64)modified
{
    self.impl.modified = modified;
}


- (NSString *)text
{
    return self.impl.text;
}

- (void)setText:(NSString *)text
{
    self.impl.text = text;
}


- (NSString *)source
{
    return self.impl.source;
}

- (void)setSource:(NSString *)source
{
    self.impl.source = source;
}


- (NSString *)sourceUrl
{
    return self.impl.sourceUrl;
}

- (void)setSourceUrl:(NSString *)sourceUrl
{
    self.impl.sourceUrl = sourceUrl;
}


@end
