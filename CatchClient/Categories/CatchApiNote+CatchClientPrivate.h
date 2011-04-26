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
//  CatchApiNote+CatchClientPrivate.h
//  CatchClient
//
//  Created by Jeff Meininger on 4/14/11.
//

#import "CatchApiNote.h"


@interface CatchApiNote (CatchClientPrivate)

// Create a note from a JSON dict.  Throws on error.
+ (CatchApiNote *)noteFromDict:(NSDictionary *)dict;

- (NSMutableDictionary *)commonHttpArgs;
- (NSDictionary *)httpArgsForAdd;
- (NSDictionary *)httpArgsForUpdate;
- (NSDictionary *)httpArgsForForceUpdate;

@end
