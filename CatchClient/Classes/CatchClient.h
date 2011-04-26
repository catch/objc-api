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
//  CatchClient.h
//  CatchClient
//
//  Created by Jeff Meininger on 11/8/10.
//

#import "CatchClientDefines.h"
#import "CatchApiNote.h"
#import "CatchApiNoteRef.h"
#import "CatchApiComment.h"
#import "CatchAccount.h"
#import "CatchApiMediaRef.h"
#import "ASIHTTPRequest.h"


@protocol CatchClientLogDelegate;


/**
 Manages communication with Catch.com servers.
 
 @warning *NOTE:* You must create an instance of this class with 
 initWithAppName:version:url: before using any library functionality!
 */
@interface CatchClient : NSObject {
@private
    
}


/** The name of your application.
 
 Example: `@"My Cool App"`
 */
@property(copy) NSString *appName;


/** Your application's version number.
 
 Example: `@"1.0.1"`
 */
@property(copy) NSString *appVersion;


/** The URL for your app's website.
 
 Example: `@"http://yourcompany.com/MyCoolApp/"`
 */
@property(copy) NSString *appUrl;


/** The authentication token.
 
 You may set this property manually if you have an access token that you wish 
 to re-use.  Otherwise, you should simply call signIn:password: to sign in.
 */
@property(copy) NSString *accessToken;



/** Optional delegate to handle API logging.
 
 @see CatchClientLogDelegate
 */
@property(assign) id<CatchClientLogDelegate> logDelegate;


/** The URL scheme to use for API communications.
 
 This is set to `@"https"` by default.  You shouldn't need to change it.
 */
@property(retain) NSString *apiScheme;


/** The server to use for API communications.
 
 This is set to `@"api.catch.com"` by default.  You shouldn't need to change it for 
 normal operation.
 */
@property(retain) NSString *apiServer;



/** The HTTP user agent to use for API communications.
 
 This is configured for you automatically using the app name and version arguments 
 that you passed to the initWithAppName:version:url: initializer.  You shouldn't 
 need to change it unless you want to do something special.
 */
@property(retain) NSString *userAgent;




/** Initializer.
 
 This initializer configures the userAgent property for you.
 
 @see appName, appVersion, appUrl
 */
- (id)initWithAppName:(NSString *)appName 
              version:(NSString *)appVersion 
                  url:(NSString *)appUrl;


/** Sign in to a Catch.com account.
 
 This method signs in and sets the accessToken property.

 @exception CatchApiException Thrown on failure.  If username or password 
 is incorrect, the exception name will be `CATCH_API_EXCEPTION_NOT_AUTHENTICATED`.
*/
- (void)signIn:(NSString *)usernameOrEmail password:(NSString *)password;


/** Get account info.
 
 This returns information for the currently signed-in user's account.
 
 @exception CatchApiException on failure.
 @return The account info.
 */
- (CatchAccount *)getAccountInfo;


/** List all notes in an account.
 
 @exception CatchApiException Thrown on failure.
 @return Array of CatchApiNoteRef objects.
 */
- (NSArray *)getAllNoteRefs;


/** Bulk fetch note data by ref.
 
 @param noteRefs NSArray of CatchNoteRef objects representing the desired notes.
 @exception CatchApiException Thrown on failure.
 @return Array of CatchApiNote objects.
 */
- (NSArray *)getNotesForNoteRefs:(NSArray *)noteRefs;


/** Bulk fetch note data by id.
 
 @param noteIds NSArray of NSString objects representing the desired notes.
 @exception CatchApiException Thrown on failure.
 @return Array of CatchApiNote objects.
 */
- (NSArray *)getNotesForNoteIds:(NSArray *)noteIds;


/** Fetch comments for the specified note.
 
 @param noteId Fetch comments for this note.
 @exception CatchApiException Thrown on failure.
 @return Array of CatchApiComment objects.
 */
- (NSArray *)getCommentsForNoteId:(NSString *)noteId;


/** Fetch media data.
 
 @exception CatchApiException Thrown on failure.
 @return Media data.
 */
- (NSData *)getMediaWithId:(NSString *)mediaId forNoteWithId:(NSString *)noteId;


/** Fetch image data scaled to an approximate resolution.
 
 @param size The image size you wish to fetch.  The server can scale the 
 image (preserving aspect ratio) to reduce download time. 
 Possible values are listed in the `CatchImageSize` enumeration...
 
 - `CatchImageSizeSmall` - Maximum of 128x128 pixels.
 - `CatchImageSizeMedium` - Maximum of 800x800 pixels.
 - `CatchImageSizeLarge` - Maximum of 9999x9999 pixels.
 - `CatchImageSizeOriginal` - Original image at full resolution.

 @exception CatchApiException Thrown on failure.
 @return Media data.
 */
- (NSData *)getImageWithId:(NSString *)mediaId 
             forNoteWithId:(NSString *)noteId 
                    ofSize:(CatchImageSize)size;


// FIXME: appledoc claims to support [created]([CatchApiNote created]) notation 
// for links, but it doesn't seem to work.  Why not?

/** Add a new note.
 
 The note's [CatchApiNote created] and [CatchApiNote modified] properties will 
 be set to the current date and time if they are not set.
 
 The note's [CatchApiNote source] and [CatchApiNote sourceUrl] properties will 
 be set to appName and appUrl if they are not set.
 
 @param note The note to add.
 @exception CatchApiException Thrown on failure.
 @return The newly added note.
 */
- (CatchApiNote *)addNote:(CatchApiNote *)note;


/** Edit a note even if a conflict exists.
 
 This 'force' version does not respect server_modified_at and does not provide 
 protection against data loss in the event of a conflict.
 
 @param note The note to edit.
 @exception CatchApiException Thrown on failure.
 @return The edited note.
 */
- (CatchApiNote *)forceUpdateNote:(CatchApiNote *)note;



/** Delete a note even if a conflict exists.
 
 This 'force' version does not respect server_modified_at and does not provide 
 protection against data loss in the event of a conflict.
 
 @param noteId The note ID to delete.
 @exception CatchApiException Thrown on failure.
 */
- (void)forceDeleteNoteWithId:(NSString *)noteId;


/** Add a comment to a note even if a conflict exists.
 
 The comment's [CatchApiComment created] and [CatchApiComment modified] 
 properties will be set to the current date and time if they are not set.
 
 The comment's [CatchApiComment source] and [CatchApiComment sourceUrl] 
 properties will be set to appName and appUrl if they are not set.
  
 This 'force' version does not respect server_modified_at and does not provide 
 protection against data loss in the event of a conflict.
 
 @param comment The comment to add.
 @exception CatchApiException Thrown on failure.
 @return The newly added comment.
 */
- (CatchApiComment *)forceAddComment:(CatchApiComment *)comment;


/** Edit a comment even if a conflict exists.
 
 This 'force' version does not respect server_modified_at and does not provide 
 protection against data loss in the event of a conflict.
 
 @param comment The comment to edit.
 @exception CatchApiException Thrown on failure.
 @return The edited comment.
 */
- (CatchApiComment *)forceUpdateComment:(CatchApiComment *)comment;


/** Delete a comment even if a conflict exists.
 
 This 'force' version does not respect server_modified_at and does not provide 
 protection against data loss in the event of a conflict.
 
 @param commentId The comment ID to delete.
 @param noteId The ID for the comment's parent note.
 @exception CatchApiException Thrown on failure.
 */
- (void)forceDeleteCommentWithId:(NSString *)commentId 
                  fromNoteWithId:(NSString *)noteId;


/** Attach media to a note even if a conflict exists.
 
 Attach images or documents to a note.
 
 For voice notes, please use forceAddVoice:ofType:named:createdAt:toNoteWithId: 
 instead.
  
 This 'force' version does not respect server_modified_at and does not provide 
 protection against data loss in the event of a conflict.
 
 @exception CatchApiException Thrown on failure.
 @return The newly added media ref. 
 */
- (CatchApiMediaRef *)forceAddMedia:(NSData *)media 
                             ofType:(NSString *)mimeType 
                              named:(NSString *)filename 
                          createdAt:(SInt64)created 
                       toNoteWithId:(NSString *)noteId;


/** Attach audio (voice) to a note even if a conflict exists.
 
 Attach audio clips to a note.
 
 For other media types, please use forceAddMedia:ofType:named:createdAt:toNoteWithId: 
 instead.
 
 This 'force' version does not respect server_modified_at and does not provide 
 protection against data loss in the event of a conflict.
 
 @exception CatchApiException Thrown on failure.
 @return The newly added media ref. 
 */
- (CatchApiMediaRef *)forceAddVoice:(NSData *)media 
                             ofType:(NSString *)mimeType 
                              named:(NSString *)filename 
                          createdAt:(SInt64)created 
                       toNoteWithId:(NSString *)noteId;


/** Remove media from a note even if a conflict exists.
 
 @exception CatchApiException Thrown on failure.
 */
- (void)forceDeleteMediaWithId:(NSString *)mediaId 
                fromNoteWithId:(NSString *)noteId;


@end




/** Simple logging protocol. */
@protocol CatchClientLogDelegate

/** Reports status of each HTTP transaction. */
- (void)catchClient:(CatchClient *)client didExecuteHttpMethod:(NSString *)method 
           endpoint:(NSString *)endpoint 
         logMessage:(NSString *)message;

@end





@interface CatchClient (LibraryPrivate)

// adds access_token to a parameter dictionary
- (NSDictionary *)authenticatedParameters:(NSDictionary *)parameters;

// execute a file upload request
- (NSData *)executeHttpPostAttachment:(NSData *)attachment 
                               ofType:(NSString *)mimeType 
                                named:(NSString *)filename 
                             endpoint:(NSString *)endpoint 
                           parameters:(NSDictionary *)parameters;

// execute a standard request
- (NSData *)executeHttpMethod:(NSString *)method 
                     endpoint:(NSString *)endpoint 
                   parameters:(NSDictionary *)parameters;

// engine: generate a request object
- (ASIHTTPRequest *)requestForMethod:(NSString *)method 
                            endpoint:(NSString *)endpoint 
                          parameters:(NSDictionary *)parameters;

// engine: execute a request object
- (NSData *)executeRequest:(ASIHTTPRequest *)request;


// Convert RFC3339 date string to msec timestamp.
+ (SInt64)parse3339:(NSString *)dateStr;

@end



