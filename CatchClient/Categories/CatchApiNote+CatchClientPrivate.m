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
//  CatchApiNote+CatchClientPrivate.m
//  CatchClient
//
//  Created by Jeff Meininger on 4/14/11.
//

#import "CatchApiNote+CatchClientPrivate.h"
#import "CatchApiException.h"
#import "NSObject+JsonParanoia.h"
#import "NSNumber+OSTypes.h"


@implementation CatchApiNote (CatchClientPrivate)


+ (CatchApiNote *)noteFromDict:(NSDictionary *)dict
{
    if (!dict) [CatchApiException throwBadJsonException];
    [NSObject verifyJsonObject:dict isOfClass:[NSDictionary class]];
    
    CatchApiNote *ret = [[CatchApiNote alloc] initWithJsonDict:dict];
    if (!ret) [CatchApiException throwBadJsonException];
    return [ret autorelease];
}


- (NSMutableDictionary *)commonHttpArgs
{
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:14];
    
    SInt64 t = (self.modified == NOT_SET_S64) ? 0 : self.modified;
    [ret setValue:[NSNumber numberWithSInt64:t] forKey:@"modified_at"];
    
    t = (self.reminder == NOT_SET_S64) ? 0 : self.reminder;
    [ret setValue:[NSNumber numberWithSInt64:t] forKey:@"reminder_at"];
    
    if (self.text) [ret setValue:self.text forKey:@"text"];
    
    NSString *mode = @"";
    if (self.privacyMode == CatchNotePrivacyModeShared) mode = @"shared";
    [ret setValue:mode forKey:@"mode"];
    
    return ret;
}


- (NSDictionary *)httpArgsForAdd
{
    NSMutableDictionary *ret = [self commonHttpArgs];
    
    SInt64 t = (self.created == NOT_SET_S64) ? 0 : self.created;
    [ret setValue:[NSNumber numberWithSInt64:t] forKey:@"created_at"];
    
    if (self.source) [ret setValue:self.source forKey:@"source"];
    if (self.sourceUrl) [ret setValue:self.sourceUrl forKey:@"source_url"];
    
    if (self.location) {
        [ret setValue:[NSNumber numberWithDouble:self.location.latitude] 
               forKey:@"latitude"];
        [ret setValue:[NSNumber numberWithDouble:self.location.longitude] 
               forKey:@"longitude"];
        [ret setValue:[NSNumber numberWithDouble:self.location.altitude] 
               forKey:@"altitude"];
        [ret setValue:[NSNumber numberWithDouble:self.location.speed] 
               forKey:@"speed"];
        [ret setValue:[NSNumber numberWithDouble:self.location.bearing] 
               forKey:@"bearing"];
        [ret setValue:[NSNumber numberWithDouble:self.location.accuracyPosition] 
               forKey:@"accuracy_position"];
        [ret setValue:[NSNumber numberWithDouble:self.location.accuracyAltitude] 
               forKey:@"accuracy_altitude"];
    }
    
    return ret;
}


- (NSDictionary *)httpArgsForUpdate
{
    // FIXME: stub.
    NSAssert(NO, @"Conflict-aware note edit is not yet implemented.");
    return nil;

    // FIXME: the following should work once it's supported...
    // NSMutableDictionary *ret = (NSMutableDictionary*)[self httpArgsForForceUpdate];
    // [ret setValue:self.serverModified forKey:@"server_modified_at"];
    // return ret;
}


- (NSDictionary *)httpArgsForForceUpdate
{
    return [self commonHttpArgs];
}


@end
