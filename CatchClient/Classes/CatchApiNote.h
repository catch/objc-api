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
//  CatchApiNote.h
//  CatchClient
//
//  Created by Jeff Meininger on 11/8/10.
//

#import "CatchClientDefines.h"
#import "CatchLocation.h"


/**
 Note data.
 
 Provided by several CatchClient methods (such as [CatchClient getNotesForNoteIds:]).
 */
@interface CatchApiNote : NSObject <NSCopying> {
@private
    
}


/** Note ID. */
@property(copy) NSString *noteId;

/** Timestamp of note creation.
 
 Expressed as millseconds since Jan 1, 1970 UTC.
 */
@property(assign) SInt64 created;

/** Timestamp of note modification.
 
 Expressed as millseconds since Jan 1, 1970 UTC.
 */
@property(assign) SInt64 modified;

/** Reminder time.
 
 Expressed as millseconds since Jan 1, 1970 UTC.
 
 A value of `NOT_SET_S64` indicates that no reminder is set.
 */
@property(assign) SInt64 reminder;

/** The text of the note. */
@property(copy) NSString *text;

/** The name of your application.
 
 If you leave this set to the default value of `nil`, the library will 
 automatically use the value of [CatchClient appName] when adding notes.
 */
@property(copy) NSString *source;

/** The URL for your app's website.
 
 If you leave this set to the default value of `nil`, the library will 
 automatically use the value of [CatchClient appUrl] when adding notes.
 */
@property(copy) NSString *sourceUrl;

/** Geotag.
 
 A value of `nil` indicates that there is no geotag.
 */
@property(retain) CatchLocation *location;

/** Privacy mode of note.
 
 The possible values are listed in the `CatchNotePrivacyMode` enumeration...
 
 - `CatchNotePrivacyModePrivate` - Disables access from others.
 - `CatchNotePrivacyModeShared` - Enables access from others via a web-accessible URL.
 
 The default setting is `CatchNotePrivacyModePrivate`.
 */
@property(assign) CatchNotePrivacyMode privacyMode;



/** Server modified timestamp.
 
 This is a special value used by programs that synchronize offline note 
 note collections.  For the standard note modification timestamp, see the 
 modified property.
 */
@property(copy, readonly) NSString *serverModified;

/** First few lines of note. */
@property(copy, readonly) NSString *summary;

/** Web-accessible URL of note. */
@property(copy, readonly) NSString *browserUrl;

/** Username of note owner. */
@property(copy, readonly) NSString *ownerName;

/** User ID of note owner. */
@property(copy, readonly) NSString *ownerId;

/** Array of NSString #hashtags. */
@property(copy, readonly) NSArray *tags;

/** Array of CatchApiMediaRef objects. */
@property(copy, readonly) NSArray *mediaRefs;

/** Array of NSString comment IDs. */
@property(copy, readonly) NSArray *commentIds;



/** Initializer with basic info.
 
 Useful for creating new notes.
 
 @see text, location
 */
- (id)initWithText:(NSString *)text 
          location:(CatchLocation *)location;


/** Initializer with complete info.
 
 When creating a simple note, it might be easier to use initWithText:location: 
 instead.
 
 @see noteId, created, modified, reminder, text, source, sourceUrl, location, 
 privacyMode
 */
- (id)initWithNoteId:(NSString *)noteId 
             created:(SInt64)created 
            modified:(SInt64)modified 
            reminder:(SInt64)reminder 
                text:(NSString *)text 
              source:(NSString *)source 
           sourceUrl:(NSString *)sourceUrl 
            location:(CatchLocation *)location 
         privacyMode:(CatchNotePrivacyMode)privacyMode;



// Private initializers.
// You probably want to call one of the initializers above instead.
// These return nil if JSON is not in the correct format.
- (id)initWithJsonDict:(NSDictionary *)dict;
- (id)initWithJsonCommentDict:(NSDictionary *)dict;


@end

