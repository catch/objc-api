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
//  CatchApiException.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/9/10.
//

#import "CatchApiException.h"


@implementation CatchApiException

+ (CatchApiException *)exceptionWithName:(NSString *)name 
                                 reason:(NSString *)reason 
                               userInfo:(NSDictionary *)userInfo
{
    return [[[self alloc] initWithName:name 
                                reason:reason 
                              userInfo:userInfo] autorelease];
}


- (id)initWithName:(NSString *)name 
            reason:(NSString *)reason 
          userInfo:(NSDictionary *)userInfo
{
    if ((self = [super initWithName:name reason:reason userInfo:userInfo])) {
    }
    
    return self;
}


+ (void)throwBadJsonException
{
    [self throwBadJsonExceptionWithReason:CatchClientLocalize(@"Bad JSON.")];
}


+ (void)throwBadJsonExceptionWithReason:(NSString *)reason
{
    CatchApiException *e = [CatchApiException exceptionWithName:CATCH_API_EXCEPTION_BAD_JSON 
                                                         reason:reason 
                                                       userInfo:nil];
    @throw e;
}


@end
