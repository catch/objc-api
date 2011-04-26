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
//  NSDictionary+TypeChecked.h
//  CatchClient
//
//  Created by Jeff Meininger on 4/17/10.
//

#import "CatchClientDefines.h"


/** Type-checked value getters. */
@interface NSDictionary (TypeChecked)

/** Gets a string value.
 
 @return `nil` if the value does not exist or is not an NSString.
 */
- (NSString *)stringForKey:(id)key;

/** Gets a dictionary value.
 
 @return `nil` if the value does not exist or is not an NSDictionary.
 */
- (NSDictionary *)dictionaryForKey:(id)key;

/** Gets an array value.
 
 @return `nil` if the value does not exist or is not an NSArray.
 */
- (NSArray *)arrayForKey:(id)key;

/** Gets a number value.
 
 @return `nil` if the value does not exist or is not an NSNumber.
 */
- (NSNumber *)numberForKey:(id)key;

/** Gets a value of a specific type.
 
 @return `nil` if the value does not exist or is not of the specified class.
 */
- (id)objectOfClass:(Class)class forKey:(id)key;

@end
