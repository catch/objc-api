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
//  CatchApiComment.h
//  CatchClient
//
//  Created by Jeff Meininger on 11/8/10.
//

#import "CatchClientDefines.h"
#import "CatchApiNote.h"


/**
 Comment data.
 
 Provided by [CatchClient getCommentsForNoteId:]. 
 */
@interface CatchApiComment : NSObject <NSCopying> {
@private
    
}


/** Comment ID. */
@property(copy) NSString *commentId;

/** ID of the parent note. */
@property(copy) NSString *parentId;

/** Timestamp of note creation.
 
 Expressed as millseconds since Jan 1, 1970 UTC.
 
 If you leave this set to the default value of `NOT_SET_S64`, the library will 
 automatically use the current date and time when adding comments.
*/
@property(assign) SInt64 created;

/** Timestamp of note modification.
 
 Expressed as millseconds since Jan 1, 1970 UTC.
 
 If you leave this set to the default value of `NOT_SET_S64`, the library will 
 automatically use the current date and time when adding or updating comments.
 */
@property(assign) SInt64 modified;

/** The text of the note. */
@property(copy) NSString *text;

/** The name of your application.
 
 If you leave this set to the default value of `nil`, the library will 
 automatically use the value of [CatchClient appName] when adding comments.
 */
@property(copy) NSString *source;

/** The URL for your app's website.
 
 If you leave this set to the default value of `nil`, the library will 
 automatically use the value of [CatchClient appUrl] when adding comments.
 */
@property(copy) NSString *sourceUrl;



/** Initializer with basic info.
 
 Useful for creating new comments.
 
 @see parentId, text
 */
- (id)initWithParentID:(NSString *)parentId 
                  text:(NSString *)text;


/** Initializer with complete info.
 
 When creating a simple comment, it might be easier to use initWithParentID:text: 
 instead.
 
 @see commentId, parentId, created, modified, text, source, sourceUrl
 */
- (id)initWithCommentID:(NSString *)commentId 
               parentId:(NSString *)parentId 
                created:(SInt64)created 
               modified:(SInt64)modified 
                   text:(NSString *)text 
                 source:(NSString *)source 
              sourceUrl:(NSString *)sourceUrl;



// Private initializer.
// You probably want to call one of the initializers above instead.
- (id)initWithGuts:(CatchApiNote *)guts;


@end
