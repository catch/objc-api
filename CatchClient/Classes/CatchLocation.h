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
//  CatchLocation.h
//  CatchClient
//
//  Created by Jeff Meininger on 11/10/10.
//

#import "CatchClientDefines.h"


// FIXME: appledoc's @see isn't showing up for the CLLocation category.  Why not?
// FIXME: If changed to a normal paragraph instead of @see, the cross reference 
// gets formatted incorrectly.  Why?

/**
 Location data.
 
 Provided in [CatchApiNote location].
 
 @see CLLocation(CatchClient)
 */
@interface CatchLocation : NSObject <NSCopying> {
@private
    
}

/** Latitude. */
@property(assign) double latitude;

/** Longitude. */
@property(assign) double longitude;

/** Altitude. */
@property(assign) double altitude;

/** Speed. */
@property(assign) double speed;

/** Bearing. */
@property(assign) double bearing;

/** Horizontal accuracy. */
@property(assign) double accuracyPosition;

/** Vertical accuracy. */
@property(assign) double accuracyAltitude;


// Private initializer.
// You probably don't need to create CatchLocation objects yourself.
// Returns nil if JSON is not in the correct format.
- (id)initWithJsonDict:(NSDictionary *)dict;


@end
