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
//  CLLocation+CatchClient.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/14/10.
//

#import "CLLocation+CatchClient.h"


@implementation CLLocation (CatchClient)

+ (CLLocation *)locationWithCatchLocation:(CatchLocation *)loc
{
    CLLocationCoordinate2D coord;
    coord.latitude = loc.latitude;
    coord.longitude = loc.longitude;
    
    CLLocation *ret = nil;
    if ([CLLocation instancesRespondToSelector:
         @selector(initWithCoordinate:altitude:horizontalAccuracy:verticalAccuracy:
                   course:speed:timestamp:)]) {
        
        // iOS 4.2+
        // FIXME: best way to suppress compiler warning for other SDKs?
        ret = [[[CLLocation alloc] initWithCoordinate:coord 
                                             altitude:loc.altitude 
                                   horizontalAccuracy:loc.accuracyPosition 
                                     verticalAccuracy:loc.accuracyAltitude 
                                               course:loc.bearing 
                                                speed:loc.speed 
                                            timestamp:[NSDate date]] autorelease];
        
    } else {
        // MacOS and older iOS
        ret = [[[CLLocation alloc] initWithCoordinate:coord 
                                             altitude:loc.altitude 
                                   horizontalAccuracy:loc.accuracyPosition 
                                     verticalAccuracy:loc.accuracyAltitude 
                                            timestamp:[NSDate date]] autorelease];
    }
    
    return ret;
}


- (CatchLocation *)catchLocation
{
    CatchLocation *ret = [[[CatchLocation alloc] init] autorelease];
    ret.latitude = self.coordinate.latitude;
    ret.longitude = self.coordinate.longitude;
    ret.altitude = self.altitude;
    ret.speed = self.speed;
    ret.bearing = self.course;
    ret.accuracyPosition = self.horizontalAccuracy;
    ret.accuracyAltitude = self.verticalAccuracy;
    return ret;
}


@end
