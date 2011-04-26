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
//  NSNumber+OSTypes.h
//  CatchClient
//
//  Created by Jeff Meininger on 11/9/10.
//

#import "CatchClientDefines.h"


/** Architecture-independent 64-bit int for NSNumber. */
@interface NSNumber (OSTypes)

/** Initializes an NSNumber with an `SInt64` value. */
- (id)initWithSInt64:(SInt64)value;

/** Creates and returns an NSNumber with an `SInt64` value. */
+ (NSNumber *)numberWithSInt64:(SInt64)value;

/** Returns the `SInt64` value. */
- (SInt64)SInt64Value;

@end
