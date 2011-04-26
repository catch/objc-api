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
//  CatchApiMediaRef.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/8/10.
//

#import "CatchApiMediaRef.h"
#import "CatchClient.h"
#import "NSDictionary+TypeChecked.h"
#import "NSNumber+OSTypes.h"


@interface CatchApiMediaRef ()

@property(retain) NSDictionary *jsonDict;

@end



@implementation CatchApiMediaRef

@synthesize jsonDict = jsonDict_;


- (id)initWithJsonDict:(NSDictionary *)dict
{
    // validate JSON
    if (!dict || ![dict stringForKey:@"id"] || ![dict stringForKey:@"src"] || 
        ![dict stringForKey:@"type"] || ![dict stringForKey:@"created_at"]) {
        
        [self release];
        return nil;
    }
    
    // initialize
    if ((self = [super init])) {
        self.jsonDict = dict;
        createdAt_ = NOT_SET_S64;
    }
    
    return self;
}


- (void)dealloc
{
    self.jsonDict = nil;
    
    [super dealloc];
}


- (NSString *)mediaId
{
    return [self.jsonDict stringForKey:@"id"];
}


- (SInt64)created
{
    // cache parse3339 result in createdAt_ so we don't have to run it every time.
    if (createdAt_ == NOT_SET_S64) {
        createdAt_ = [CatchClient parse3339:[self.jsonDict stringForKey:@"created_at"]];
    }
    
    return createdAt_;
}


- (NSString *)filename
{
    return [self.jsonDict stringForKey:@"filename"];
}


- (NSString *)type
{
    return [self.jsonDict stringForKey:@"type"];
}


- (NSString *)src
{
    return [self.jsonDict stringForKey:@"src"];
}


- (SInt64)size
{
    NSNumber *num = [self.jsonDict numberForKey:@"size"];
    if (!num) return NOT_SET_S64;
    return [num SInt64Value];
}


- (BOOL)isVoice
{
    NSNumber *num = [self.jsonDict numberForKey:@"voicenote_hint"];
    if (!num) return NO;
    return [num boolValue];
}


@end
