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
//  CatchClientDefines.h
//  CatchClient
//
//  Created by Jeff Meininger on 11/10/10.
//

#import <Foundation/Foundation.h>


// FIXME: We can ship a strings bundle with this library...
#define CatchClientLocalize(str) str



// Documented at [CatchApiNote privacyMode]
typedef enum {
    CatchNotePrivacyModePrivate, 
    CatchNotePrivacyModeShared
} CatchNotePrivacyMode;


// Documented at [CatchAccount level]
typedef enum {
    CatchAccountStandard,
    CatchAccountPro    
} CatchAccountServiceLevel;


// Documented at [CatchClient getImageWithId:forNoteWithId:ofSize:
typedef enum {
    CatchImageSizeSmall,
    CatchImageSizeMedium,
    CatchImageSizeLarge,
    CatchImageSizeOriginal
} CatchImageSize;


// Indicates "not set" or "not applicable" for SInt64 values.
static const SInt64 NOT_SET_S64 = INT64_MIN;


