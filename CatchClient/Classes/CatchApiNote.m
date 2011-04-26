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
//  CatchApiNote.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/8/10.
//

#import "CatchClient.h"
#import "CatchApiNote.h"
#import "CatchApiMediaRef.h"
#import "NSDictionary+TypeChecked.h"
#import "NSNumber+OSTypes.h"


@interface CatchApiNote ()

@property(copy, readwrite) NSString *serverModified;
@property(copy, readwrite) NSString *summary;
@property(copy, readwrite) NSString *browserUrl;
@property(copy, readwrite) NSString *ownerName;
@property(copy, readwrite) NSString *ownerId;
@property(copy, readwrite) NSArray *tags;
@property(copy, readwrite) NSArray *mediaRefs;
@property(copy, readwrite) NSArray *commentIds;

- (id)initWithValidatedJsonDict:(NSDictionary *)dict;

@end



@implementation CatchApiNote

@synthesize noteId = noteId_;
@synthesize created = created_;
@synthesize modified = modified_;
@synthesize reminder = reminder_;
@synthesize text = text_;
@synthesize source = source_;
@synthesize sourceUrl = sourceUrl_;
@synthesize location = location_;
@synthesize privacyMode = privacyMode_;
@synthesize serverModified = serverModified_;
@synthesize summary = summary_;
@synthesize browserUrl = browserUrl_;
@synthesize ownerName = ownerName_;
@synthesize ownerId = ownerId_;
@synthesize tags = tags_;
@synthesize mediaRefs = mediaRefs_;
@synthesize commentIds = commentIds_;



- (id)initWithText:(NSString *)text 
          location:(CatchLocation *)location
{
    return [self initWithNoteId:nil 
                        created:NOT_SET_S64 
                       modified:NOT_SET_S64 
                       reminder:NOT_SET_S64 
                           text:text 
                         source:nil 
                      sourceUrl:nil 
                       location:location 
                    privacyMode:CatchNotePrivacyModePrivate];
}


- (id)initWithNoteId:(NSString *)noteId 
             created:(SInt64)created 
            modified:(SInt64)modified 
            reminder:(SInt64)reminder 
                text:(NSString *)text 
              source:(NSString *)source 
           sourceUrl:(NSString *)sourceUrl 
            location:(CatchLocation *)location 
         privacyMode:(CatchNotePrivacyMode)privacyMode
{
    if ((self = [super init])) {
        self.noteId = noteId;
        self.created = created;
        self.modified = modified;
        self.reminder = reminder;
        self.text = text;
        self.source = source;
        self.sourceUrl = sourceUrl;
        self.location = location;
        self.privacyMode = privacyMode;
    }
    
    return self;
}


- (id)init
{
    return [self initWithNoteId:nil 
                        created:NOT_SET_S64 
                       modified:NOT_SET_S64 
                       reminder:NOT_SET_S64 
                           text:nil 
                         source:nil 
                      sourceUrl:nil 
                       location:nil 
                    privacyMode:CatchNotePrivacyModePrivate];
}


- (id)copyWithZone:(NSZone *)zone
{
    CatchApiNote *copy = nil;
    copy = [[[self class] allocWithZone:zone] initWithNoteId:self.noteId 
                                                     created:self.created 
                                                    modified:self.modified 
                                                    reminder:self.reminder 
                                                        text:self.text 
                                                      source:self.source 
                                                   sourceUrl:self.sourceUrl 
                                                    location:[[self.location copyWithZone:zone] 
                                                              autorelease]
                                                 privacyMode:self.privacyMode];
    
    copy.serverModified = self.serverModified;
    copy.summary = self.summary;
    copy.browserUrl = self.browserUrl;
    copy.ownerName = self.ownerName;
    copy.ownerId = self.ownerId;
    copy.tags = self.tags;
    copy.mediaRefs = self.mediaRefs;
    copy.commentIds = self.commentIds;
    
    return copy;
}


- (id)initWithJsonDict:(NSDictionary*)dict
{
    // validate JSON
    if (!dict || ![dict stringForKey:@"id"] || 
        ![dict stringForKey:@"server_modified_at"]) {
        
        [self release];
        return nil;
    }
    
    return [self initWithValidatedJsonDict:dict];
}



- (id)initWithJsonCommentDict:(NSDictionary*)dict
{
    // validate JSON
    if (!dict || ![dict stringForKey:@"id"]) {
        [self release];
        return nil;
    }
    
    return [self initWithValidatedJsonDict:dict];
}


- (id)initWithValidatedJsonDict:(NSDictionary*)dict
{
    // set properties from JSON
    CatchApiNote *ret = [self init];
    ret.noteId = [dict stringForKey:@"id"];
    ret.created = [CatchClient parse3339:[dict stringForKey:@"created_at"]];
    ret.modified = [CatchClient parse3339:[dict stringForKey:@"modified_at"]];
    ret.reminder = [CatchClient parse3339:[dict stringForKey:@"reminder_at"]];
    ret.serverModified = [dict stringForKey:@"server_modified_at"];
    ret.text = [dict stringForKey:@"text"];
    ret.source = [dict stringForKey:@"source"];
    ret.sourceUrl = [dict stringForKey:@"source_url"];
    
    NSDictionary *lDict = [dict dictionaryForKey:@"location"];
    if (lDict) {
        CatchLocation *loc = [[CatchLocation alloc] initWithJsonDict:lDict];
        if (loc) self.location = [loc autorelease];
    }
    
    NSString *pmStr = [dict stringForKey:@"mode"];
    if (pmStr && [pmStr isEqualToString:@"shared"]) {
        ret.privacyMode = CatchNotePrivacyModeShared;
    }
    
    ret.summary = [dict stringForKey:@"summary"];
    ret.browserUrl = [dict stringForKey:@"browser_url"];
    
    NSDictionary *userDict = [dict dictionaryForKey:@"user"];
    if (userDict) {
        ret.ownerId = [userDict stringForKey:@"id"];
        ret.ownerName = [userDict stringForKey:@"user_name"];
    }
    
    NSArray *tagArray = [dict arrayForKey:@"tags"];
    if (tagArray && [tagArray count] > 0) self.tags = tagArray;
    
    NSArray *mediaArray = [dict arrayForKey:@"media"];
    if (mediaArray) {
        NSMutableArray *mRefs = [NSMutableArray arrayWithCapacity:[mediaArray count]];
        for (NSDictionary *mediaDict in mediaArray) {
            CatchApiMediaRef *ref = [[CatchApiMediaRef alloc] initWithJsonDict:mediaDict];
            if (ref) [mRefs addObject:[ref autorelease]];
        }
        
        if ([mRefs count] > 0) self.mediaRefs = mRefs;
    }
    
    NSArray *commentArray = [dict arrayForKey:@"comments"];
    if (commentArray && [commentArray count] > 0) {
        NSMutableArray *cIds = [NSMutableArray arrayWithCapacity:[commentArray count]];
        for (NSDictionary *commentDict in commentArray) {
            NSString *cId = [commentDict stringForKey:@"id"];
            if (cId) [cIds addObject:cId];
        }
        
        if ([cIds count] > 0) self.commentIds = cIds;
    }
    
    return ret;
}


- (void)dealloc
{
    self.noteId = nil;
    self.text = nil;
    self.source = nil;
    self.sourceUrl = nil;
    self.location = nil;
    self.summary = nil;
    self.browserUrl = nil;
    self.ownerName = nil;
    self.ownerId = nil;
    self.tags = nil;
    self.mediaRefs = nil;
    self.commentIds = nil;
    
    [super dealloc];
}


@end
