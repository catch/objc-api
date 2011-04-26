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
//  DesktopDemoAppDelegate.m
//  DesktopDemo
//
//  Created by Jeff Meininger on 4/20/11.
//

#import "DesktopDemoAppDelegate.h"
#import "CatchAccount.h"

@interface DesktopDemoAppDelegate ()
- (void)showSignInSheet;
- (void)attachMediaWithURL:(NSURL *)url;
@end



@implementation DesktopDemoAppDelegate

@synthesize window = window_;
@synthesize signInPanel = signInPanel_;
@synthesize recentNoteId = recentNoteId_;
@synthesize recentMediaId = recentMediaId_;
@synthesize recentCommentId = recentCommentId_;
@synthesize client = client_;


// Hints...
// 
// You'll see many calls to MWLog, MWLogBanner, and MWLogException.  These 
// simply add text to the output pane of the main window.
// 
// Most of the work takes place inside of @try blocks.  This is because most 
// CatchClient methods report errors by throwing NSException objects.  See the 
// CatchApiException documentation for more information.



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Get app name (DesktopDemo) and version (1.2.3) from bundle
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:
                         @"CFBundleName"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:
                            @"CFBundleShortVersionString"];
    
    NSString *appUrl = @"https://catch.com/";
    
    
    ////////////////////////////////
    // Create the CatchClient object
    ////////////////////////////////
    self.client = [[[CatchClient alloc] initWithAppName:appName 
                                                version:appVersion 
                                                    url:appUrl] autorelease];
    
    
    // Display Sign-In sheet.
    [self showSignInSheet];
}


- (IBAction)signIn:(id)sender
{
    [NSApp endSheet:self.signInPanel];
    
    NSString *username = [self.signInPanel.username stringValue];
    NSString *password = [self.signInPanel.password stringValue];
    
    /////////////////////////////////
    // Sign in to a Catch.com account
    /////////////////////////////////
    @try {
        MWLogBanner(@"Sign In");
        
        [self.client signIn:username password:password];
        
        MWLog(@"Success!");
    }
    @catch (NSException *exception) {
        // Error signing in!
        
        // Normal authentication errors (wrong username / password) are indicated 
        // by an [exception name] of CATCH_API_EXCEPTION_NOT_AUTHENTICATED.  You 
        // should probably handle that case separately from other exceptions in 
        // your own app's sign-in function.
        
        MWLogException(exception);
        [self showSignInSheet];
    }
    
    
    ////////////////////////////////////
    // Get information about the account
    ////////////////////////////////////
    @try {
        MWLogBanner(@"Get Account Info");
        
        CatchAccount *account = [self.client getAccountInfo];
        
        MWLog(@"User ID: %@", account.userId);
        MWLog(@"User Name: %@", account.userName);
        MWLog(@"Primary E-Mail: %@", account.primaryEmail);
        MWLog(@"Account Type: %@", account.levelDescription);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)fetchNotes:(id)sender
{
    ///////////////////////////////////////////////
    // Get refs for all of the notes in the account
    ///////////////////////////////////////////////
    NSArray *refs = nil;
    @try {
        MWLogBanner(@"Get Note Refs");
        
        refs = [self.client getAllNoteRefs];
        
        MWLog(@"%i refs fetched.", [refs count]);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
    
    
    /////////////////////////////////////
    // Get note data for each of our refs
    /////////////////////////////////////
    @try {
        MWLogBanner(@"Get Notes (Bulk)");
        
        NSArray *notes = [self.client getNotesForNoteRefs:refs];
        
        for (CatchApiNote *note in notes) {
            MWLog(@"\n-- Note ID %@:  %i comment(s), %i media item(s) --\n%@", 
                  note.noteId, [note.commentIds count], [note.mediaRefs count], 
                  note.summary);
        }
        MWLog(@"\n%i note(s) displayed.", [notes count]);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)createNote:(id)sender
{
    NSString *noteText = [self.window.createNoteTextView string];
    
    ////////////////////
    // Create a new note
    ////////////////////
    @try {
        MWLogBanner(@"Create Note");
        
        CatchApiNote *note = [[[CatchApiNote alloc] initWithText:noteText 
                                                        location:nil] autorelease];
        CatchApiNote *serverNote = [self.client addNote:note];
        
        MWLog(@"Added note ID %@", serverNote.noteId);
        self.recentNoteId = serverNote.noteId;
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)editNote:(id)sender
{
    NSString *noteId = self.recentNoteId;
    NSString *newText = [self.window.editNoteTextView string];
    
    /////////////////////////
    // Fetch an existing note
    /////////////////////////
    CatchApiNote *editMe = nil;
    @try {
        MWLogBanner(@"Fetch Existing Note");
        
        NSArray *fetchIds = [NSArray arrayWithObject:noteId];
        NSArray *notes = [self.client getNotesForNoteIds:fetchIds];
        editMe = [notes objectAtIndex:0];
        
        MWLog(@"Fetched note ID %@", editMe.noteId);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
    
    
    ////////////////////////
    // Edit an existing note
    ////////////////////////
    @try {
        MWLogBanner(@"Edit Note");
        
        editMe.text = newText;
        [self.client forceUpdateNote:editMe];
        
        MWLog(@"Edited note ID %@", editMe.noteId);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)deleteNote:(id)sender
{
    NSString *noteId = self.recentNoteId;
    
    ////////////////
    // Delete a note
    ////////////////
    @try {
        MWLogBanner(@"Delete Note");
        
        [self.client forceDeleteNoteWithId:noteId];
        
        MWLog(@"Deleted note ID %@", noteId);
        self.recentNoteId = nil;
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}



- (IBAction)fetchMediaInfo:(id)sender
{
    NSString *noteId = self.recentNoteId;
    
    ////////////////////////////////////////////
    // Fetch an existing note (to inspect media)
    ////////////////////////////////////////////
    @try {
        MWLogBanner(@"Fetch Media Info");
        
        NSArray *fetchIds = [NSArray arrayWithObject:noteId];
        NSArray *notes = [self.client getNotesForNoteIds:fetchIds];
        CatchApiNote *note = [notes objectAtIndex:0];
        
        for (CatchApiMediaRef *ref in note.mediaRefs) {
            MWLog(@"Media ID %@: %@ (%@) %qi bytes", 
                  ref.mediaId, ref.filename, ref.type, ref.size);
        }
        MWLog(@"\n%i media item(s) displayed.", [note.mediaRefs count]);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (void)attachMediaWithURL:(NSURL *)url  // the url is a local filesystem path.
{
    NSString *noteId = self.recentNoteId;
    NSString *mimeType = [self.window.attachMediaMimeTypeCell stringValue];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // Catch.com uses millisecond-based timestamps.
    SInt64 created = [[NSDate date] timeIntervalSince1970]*1000.0;
        
    ///////////////////////
    // Attach media to note
    ///////////////////////
    @try {
        MWLogBanner(@"Attach Media");
        
        CatchApiMediaRef *serverRef = [self.client forceAddMedia:data 
                                                          ofType:mimeType 
                                                           named:[url lastPathComponent] 
                                                       createdAt:created 
                                                    toNoteWithId:noteId];
        
        MWLog(@"Added media ID: %@", serverRef.mediaId);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)downloadMedia:(id)sender
{
    NSString *noteId = self.recentNoteId;
    NSString *mediaId = self.recentMediaId;
    
    ////////////////////////////////////////////
    // Fetch an existing note (to inspect media)
    ////////////////////////////////////////////
    NSString *filename = @"unknown.media";
    @try {
        MWLogBanner(@"Fetch Media Filename");
        
        NSArray *fetchIds = [NSArray arrayWithObject:noteId];
        NSArray *notes = [self.client getNotesForNoteIds:fetchIds];
        CatchApiNote *note = [notes objectAtIndex:0];
        
        for (CatchApiMediaRef *ref in note.mediaRefs) {
            if ([ref.mediaId isEqualToString:mediaId]) {
                filename = ref.filename;
                MWLog(@"Found filename: %@", filename);
                break;
            }
        }
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
    
    
    ///////////////////////////
    // Download media file data
    ///////////////////////////
    @try {
        MWLogBanner(@"Download Media");
        
        NSData *data = [self.client getMediaWithId:mediaId forNoteWithId:noteId];
        
        MWLog(@"Downloaded %u bytes.", [data length]);
        NSURL *saveAs = [[NSFileManager defaultManager] URLForDirectory:NSDesktopDirectory 
                                                               inDomain:NSUserDomainMask 
                                                      appropriateForURL:nil 
                                                                 create:NO 
                                                                  error:NULL];
        saveAs = [NSURL URLWithString:filename relativeToURL:saveAs];
        [data writeToURL:saveAs atomically:NO];
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)deleteMedia:(id)sender
{
    NSString *noteId = self.recentNoteId;
    NSString *mediaId = self.recentMediaId;
    
    //////////////////////
    // Delete a media item
    //////////////////////
    @try {
        MWLogBanner(@"Delete Media");
        
        [self.client forceDeleteMediaWithId:mediaId fromNoteWithId:noteId];
        
        MWLog(@"Deleted media ID: %@", mediaId);
        self.recentMediaId = nil;
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}



- (IBAction)fetchComments:(id)sender
{
    NSString *noteId = self.recentNoteId;
    
    /////////////////////////////////////
    // Fetch comments for a specific note
    /////////////////////////////////////
    @try {
        MWLogBanner(@"Fetch Comments");
        
        NSArray *comments = [self.client getCommentsForNoteId:noteId];
        
        for (CatchApiComment *comment in comments) {
            MWLog(@"\n-- Comment ID %@ --\n%@", comment.commentId, comment.text);
        }
        MWLog(@"\n%i comment(s) displayed.", [comments count]);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)createComment:(id)sender
{
    NSString *noteId = self.recentNoteId;
    NSString *commentText = [self.window.createCommentTextView string];

    ///////////////////////
    // Create a new comment
    ///////////////////////
    @try {
        MWLogBanner(@"Create Comment");
        
        CatchApiComment *comment = [[[CatchApiComment alloc] initWithParentID:noteId 
                                                                         text:commentText] 
                                    autorelease];
        CatchApiComment *serverComment = [self.client forceAddComment:comment];
        
        MWLog(@"Added comment ID: %@", serverComment.commentId);
        self.recentCommentId = serverComment.commentId;
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)editComment:(id)sender
{
    NSString *noteId = self.recentNoteId;
    NSString *commentId = self.recentCommentId;
    NSString *newText = [self.window.editCommentTextView string];
    
    ///////////////////////////
    // Edit an existing comment
    ///////////////////////////
    @try {
        MWLogBanner(@"Edit Comment");
        
        CatchApiComment *comment = [[[CatchApiComment alloc] initWithParentID:noteId 
                                                                         text:newText] 
                                    autorelease];
        comment.commentId = commentId;
        [self.client forceUpdateComment:comment];
        
        MWLog(@"Edited comment ID: %@", comment.commentId);
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}


- (IBAction)deleteComment:(id)sender
{
    NSString *noteId = self.recentNoteId;
    NSString *commentId = self.recentCommentId;
    
    ///////////////////
    // Delete a comment
    ///////////////////
    @try {
        MWLogBanner(@"Delete Comment");
        
        [self.client forceDeleteCommentWithId:commentId fromNoteWithId:noteId];
        
        MWLog(@"Deleted comment ID: %@", commentId);
        self.recentCommentId = nil;
    }
    @catch (NSException *exception) {
        MWLogException(exception);
    }
}








// There's nothing interesting about libCatchClient usage below this point.


- (void)showSignInSheet
{
    [NSApp beginSheet:self.signInPanel 
       modalForWindow:self.window 
        modalDelegate:self 
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) 
          contextInfo:NULL];    
}


- (IBAction)dontSignIn:(id)sender
{
    [NSApp endSheet:self.signInPanel];
    [NSApp terminate:self];
}


- (IBAction)attachMedia:(id)sender
{
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setPrompt:@"Upload"];
    [op beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [self attachMediaWithURL:[[op URLs] objectAtIndex:0]];
        }
    }];
}


- (void)didEndSheet:(NSWindow *)sheet 
         returnCode:(NSInteger)returnCode 
        contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}


@end
