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
//  CatchApiNoteRef.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/8/10.
//

#import "CatchClient.h"
#import "CatchClientDefines.h"
#import "CatchApiNoteRef.h"
#import "NSDictionary+TypeChecked.h"


@interface CatchApiNoteRef ()

@property(retain) NSDictionary *jsonDict;

@end



@implementation CatchApiNoteRef

@synthesize jsonDict = jsonDict_;


- (id)initWithJsonDict:(NSDictionary *)dict
{
    // validate JSON
    if (!dict || ![dict stringForKey:@"id"] || 
        ![dict stringForKey:@"server_modified_at"]) {
        
        [self release];
        return nil;
    }
    
    // initialize
    if ((self = [super init])) {
        self.jsonDict = dict;
    }
    
    return self;
}


- (void)dealloc
{
    self.jsonDict = nil;
    
    [super dealloc];
}



- (NSString *)noteId
{
    return [self.jsonDict stringForKey:@"id"];
}


- (NSString *)serverModified
{
    return [self.jsonDict stringForKey:@"server_modified_at"];
}


@end
