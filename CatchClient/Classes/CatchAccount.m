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
//  CatchAccount.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/17/10.
//

#import "CatchAccount.h"
#import "CatchClient.h"
#import "NSDictionary+TypeChecked.h"
#import "NSNumber+OSTypes.h"


@interface CatchAccount ()

@property(copy, readwrite) NSString *userId;
@property(copy, readwrite) NSString *userName;
@property(copy, readwrite) NSString *primaryEmail;
@property(assign, readwrite) SInt64 created;
@property(assign, readwrite) SInt64 uploadActivity;
@property(assign, readwrite) SInt64 uploadPeriodStart;
@property(assign, readwrite) SInt64 uploadPeriodEnd;
@property(assign, readwrite) SInt64 uploadLimit;
@property(assign, readwrite) CatchAccountServiceLevel level;
@property(copy, readwrite) NSString *levelDescription;

@end



@implementation CatchAccount

@synthesize userId = userId_;
@synthesize userName = userName_;
@synthesize primaryEmail = primaryEmail_;
@synthesize created = created_;
@synthesize uploadActivity = uploadActivity_;
@synthesize uploadPeriodStart = uploadPeriodStart_;
@synthesize uploadPeriodEnd = uploadPeriodEnd_;
@synthesize uploadLimit = uploadLimit_;
@synthesize level = level_;
@synthesize levelDescription = levelDescription_;


- (id)initWithJsonDict:(NSDictionary *)dict
{
    // validate JSON
    if (!dict) {
        [self release];
        return nil;
    }
    
    NSString *uId = [dict stringForKey:@"id"];
    NSString *uName = [dict stringForKey:@"user_name"];
    NSString *uEmail = [dict stringForKey:@"email"];
    if (!uId || !uName || !uEmail) {
        [self release];
        return nil;
    }
    
    // initialize
    self = [super init];
    if (!self) return nil;
    
    self.userId = uId;
    self.userName = uName;
    self.primaryEmail = uEmail;
    
    // creation timestamp
    self.created = [CatchClient parse3339:[dict stringForKey:@"created_at"]];
    
    // upload activity stats
    self.uploadActivity = NOT_SET_S64;
    self.uploadPeriodStart = NOT_SET_S64;
    self.uploadPeriodEnd = NOT_SET_S64;
    NSArray *uploadArray = [dict arrayForKey:@"account_upload_activity_periodic"];
    if (uploadArray && [uploadArray count]) {
        // first entry in upload activity array is the most recent
        NSDictionary *uploadDict = [uploadArray objectAtIndex:0];
        NSNumber *activity = [uploadDict numberForKey:@"period_activity"];
        if (activity) self.uploadActivity = [activity SInt64Value];
        NSString *periodStart = [uploadDict stringForKey:@"period_start"];
        if (periodStart) self.uploadPeriodStart = [CatchClient parse3339:periodStart];
        NSString *periodEnd = [uploadDict stringForKey:@"period_end"];
        if (periodEnd) self.uploadPeriodEnd = [CatchClient parse3339:periodEnd];
    }
    
    self.uploadLimit = NOT_SET_S64;
    NSDictionary *limitsDict = [dict dictionaryForKey:@"account_limits"];
    if (limitsDict) {
        NSNumber *limit = [limitsDict numberForKey:@"monthly_upload_limit"];
        if (limit) self.uploadLimit = [limit SInt64Value];
    }
    
    // account level of service
    self.level = CatchAccountStandard;
    NSNumber *levelNum = [dict numberForKey:@"account_level"];
    if (levelNum) self.level = [levelNum intValue];
    
    self.levelDescription = [dict stringForKey:@"account_level_desc"];
    
    return self;
}


- (void)dealloc
{
    self.userId = nil;
    self.userName = nil;
    self.primaryEmail = nil;
    self.levelDescription = nil;
    
    [super dealloc];
}


@end
