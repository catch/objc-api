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
//  NSData+JsonParanoia.m
//  CatchClient
//
//  Created by Jeff Meininger on 4/18/11.
//

#import "NSData+JsonParanoia.h"
#import "NSObject+JsonParanoia.h"
#import "CatchApiException.h"
#import "NSString+SBJSON.h"


@implementation NSData (JsonParanoia)


// called by objectFromJsonData
+ (NSString *)jsonDataToString:(NSData *)data
{
    if (!data) {
        [CatchApiException throwBadJsonExceptionWithReason:
         CatchClientLocalize(@"JSON was empty.")];
    }
    
    NSString *str = [[[NSString alloc] initWithData:data 
                                           encoding:NSUTF8StringEncoding] autorelease];
    if (!str) {
        CatchApiException *e = [CatchApiException exceptionWithName:CATCH_API_EXCEPTION_ENCODING 
                                                             reason:CatchClientLocalize(@"Unexpected encoding.") 
                                                           userInfo:nil];
        @throw e;
    }
    
    return str;
}


// called by arrayFromJsonData and dictionaryFromJsonData
+ (NSObject *)objectFromJsonData:(NSData *)data
{
    NSObject *obj = [[self jsonDataToString:data] JSONValue];
    if (!obj) {
        CatchApiException *e = [CatchApiException exceptionWithName:CATCH_API_EXCEPTION_BAD_JSON 
                                                             reason:CatchClientLocalize(@"Bad JSON encoding.") 
                                                           userInfo:nil];
        @throw e;
    }
    
    return obj;
}


+ (NSArray *)arrayFromJsonData:(NSData *)data
{
    NSObject *obj = [self objectFromJsonData:data];
    [NSObject verifyJsonObject:obj isOfClass:[NSArray class]];
    
    return (NSArray *)obj;
}


+ (NSDictionary *)dictionaryFromJsonData:(NSData *)data
{
    NSObject *obj = [self objectFromJsonData:data];
    [NSObject verifyJsonObject:obj isOfClass:[NSDictionary class]];
    
    return (NSDictionary *)obj;
}



@end

