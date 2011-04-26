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
//  NSDictionary+TypeChecked.m
//  CatchClient
//
//  Created by Jeff Meininger on 4/17/10.
//

#import "NSDictionary+TypeChecked.h"


@implementation NSDictionary (TypeChecked)


- (NSString *)stringForKey:(id)key
{
    return [self objectOfClass:[NSString class] forKey:key];
}


- (NSDictionary *)dictionaryForKey:(id)key
{
    return [self objectOfClass:[NSDictionary class] forKey:key];
}


- (NSArray *)arrayForKey:(id)key
{
    return [self objectOfClass:[NSArray class] forKey:key];
}


- (NSNumber *)numberForKey:(id)key
{
    return [self objectOfClass:[NSNumber class] forKey:key];
}



- (id)objectOfClass:(Class)class forKey:(id)key
{
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:class]) return ret;
    else return nil;
}


@end
