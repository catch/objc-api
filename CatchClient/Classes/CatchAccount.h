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
//  CatchAccount.h
//  CatchClient
//
//  Created by Jeff Meininger on 11/17/10.
//

#import "CatchClientDefines.h"


/**
 Information about a Catch.com account.
 
 Provided by [CatchClient getAccountInfo].
 */
@interface CatchAccount : NSObject {
@private
    
}

/** User ID. */
@property(copy, readonly) NSString *userId;

/** User Name. */
@property(copy, readonly) NSString *userName;

/** Primary email address. */
@property(copy, readonly) NSString *primaryEmail;

/** Timestamp of account creation.
 
 Expressed as millseconds since Jan 1, 1970 UTC.
 */
@property(assign, readonly) SInt64 created;

/** Upload activity. */
@property(assign, readonly) SInt64 uploadActivity;

/** Upload period start date (timestamp). */
@property(assign, readonly) SInt64 uploadPeriodStart;

/** Upload period end date (timestamp). */
@property(assign, readonly) SInt64 uploadPeriodEnd;

/** Monthly upload limit. */
@property(assign, readonly) SInt64 uploadLimit;

/** Level of service.
 
 The possible values are listed in the `CatchAccountServiceLevel` enumeration...
 
 - `CatchAccountStandard` - Standard (free) account.
 - `CatchAccountPro` - Pro account.
 */
@property(assign, readonly) CatchAccountServiceLevel level;

/** Description of the level of service. */
@property(copy, readonly) NSString *levelDescription;


// Private initializer.
// You probably don't need to create CatchAccount objects yourself.  They are 
// provided by CatchClient.
// Returns nil if JSON is not in the correct format.
- (id)initWithJsonDict:(NSDictionary *)dict;


@end


