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
//  CatchApiComment+CatchClientPrivate.m
//  CatchClient
//
//  Created by Jeff Meininger on 4/14/11.
//

#import "CatchApiComment+CatchClientPrivate.h"
#import "CatchApiException.h"
#import "NSObject+JsonParanoia.h"
#import "NSNumber+OSTypes.h"


@implementation CatchApiComment (CatchClientPrivate)


+ (CatchApiComment *)commentFromDict:(NSDictionary *)dict parentId:(NSString *)noteId
{
    if (!dict) [CatchApiException throwBadJsonException];
    [NSObject verifyJsonObject:dict isOfClass:[NSDictionary class]];
    
    CatchApiNote *guts = [[CatchApiNote alloc] initWithJsonCommentDict:dict];
    if (!guts) [CatchApiException throwBadJsonException];
    
    CatchApiComment *ret = [[CatchApiComment alloc] initWithGuts:[guts autorelease]];
    if (!ret) [CatchApiException throwBadJsonException];
    ret.parentId = noteId;
    return [ret autorelease];
}


- (NSMutableDictionary *)commonHttpArgs
{
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:14];
    
    SInt64 t = (self.modified == NOT_SET_S64) ? 0 : self.modified;
    [ret setValue:[NSNumber numberWithSInt64:t] forKey:@"modified_at"];
    
    if (self.text) [ret setValue:self.text forKey:@"text"];
    
    return ret;
}


- (NSDictionary *)httpArgsForAdd
{
    NSMutableDictionary *ret = [self commonHttpArgs];
    
    SInt64 t = (self.created == NOT_SET_S64) ? 0 : self.created;
    [ret setValue:[NSNumber numberWithSInt64:t] forKey:@"created_at"];
    
    if (self.source) [ret setValue:self.source forKey:@"source"];
    if (self.sourceUrl) [ret setValue:self.sourceUrl forKey:@"source_url"];
    
    return ret;
}


- (NSDictionary *)httpArgsForUpdate
{
    // FIXME: stub.
    NSAssert(NO, @"Conflict-aware comment edit is not yet implemented.");
    return nil;
}


- (NSDictionary *)httpArgsForForceUpdate
{
    NSMutableDictionary *ret = [self commonHttpArgs];
    [ret setValue:self.commentId forKey:@"comment"];
    return ret;
}


@end
