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
//  CatchLocation.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/10/10.
//

#import "CatchLocation.h"
#import "NSDictionary+TypeChecked.h"


@implementation CatchLocation

@synthesize latitude = latitude_;
@synthesize longitude = longitude_;
@synthesize altitude = altitude_;
@synthesize speed = speed_;
@synthesize bearing = bearing_;
@synthesize accuracyPosition = accuracyPosition_;
@synthesize accuracyAltitude = accuracyAltitude_;


- (id)initWithJsonDict:(NSDictionary *)dict
{
    // validate JSON
    if (!dict) {
        [self release];
        return nil;
    }
    
    NSArray *features = [dict arrayForKey:@"features"];
    if (!features || [features count] < 1) {
        [self release];
        return nil;
    }
    
    NSDictionary *featuresDict = [features objectAtIndex:0];
    if (!featuresDict) {
        [self release];
        return nil;
    }
    
    NSDictionary *geomDict = [featuresDict dictionaryForKey:@"geometry"];
    NSDictionary *propsDict = [featuresDict dictionaryForKey:@"properties"];
    if (!geomDict || !propsDict) {
        [self release];
        return nil;
    }
    
    NSArray *coords = [geomDict arrayForKey:@"coordinates"];
    if (!coords || [coords count] < 2) {
        [self release];
        return nil;
    }
    
    NSNumber *altNum = [propsDict numberForKey:@"altitude"];
    NSNumber *speedNum = [propsDict numberForKey:@"speed"];
    NSNumber *bearingNum = [propsDict numberForKey:@"bearing"];
    NSNumber *aPosNum = [propsDict numberForKey:@"accuracy_position"];
    NSNumber *aAltNum = [propsDict numberForKey:@"accuracy_altitude"];
    if (!altNum || !speedNum || !bearingNum || !aPosNum || !aAltNum) {
        [self release];
        return nil;
    }
    
    // initialize
    if ((self = [super init])) {
        self.latitude = [(NSNumber*)[coords objectAtIndex:1] doubleValue];
        self.longitude = [(NSNumber*)[coords objectAtIndex:0] doubleValue];
        self.altitude = [altNum doubleValue];
        self.speed = [speedNum doubleValue];
        self.bearing = [bearingNum doubleValue];
        self.accuracyPosition = [aPosNum doubleValue];
        self.accuracyAltitude = [aAltNum doubleValue];
    }
    
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    CatchLocation *copy = [[[self class] allocWithZone:zone] init];
    copy.latitude = self.latitude;
    copy.longitude = self.longitude;
    copy.altitude = self.altitude;
    copy.speed = self.speed;
    copy.bearing = self.bearing;
    copy.accuracyPosition = self.accuracyPosition;
    copy.accuracyAltitude = self.accuracyAltitude;
    
    return copy;
}



@end
