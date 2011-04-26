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
//  DesktopDemoAppDelegate.h
//  DesktopDemo
//
//  Created by Jeff Meininger on 4/20/11.
//

#import "MainWindow.h"
#import "SignInPanel.h"
#import "CatchClient.h"

@interface DesktopDemoAppDelegate : NSObject <NSApplicationDelegate> {
@private
    
}

@property (assign) IBOutlet MainWindow *window;
@property (assign) IBOutlet SignInPanel *signInPanel;

@property (copy) NSString *recentNoteId;
@property (copy) NSString *recentMediaId;
@property (copy) NSString *recentCommentId;

@property (retain) CatchClient *client;


- (IBAction)signIn:(id)sender;
- (IBAction)dontSignIn:(id)sender;

- (IBAction)fetchNotes:(id)sender;
- (IBAction)createNote:(id)sender;
- (IBAction)editNote:(id)sender;
- (IBAction)deleteNote:(id)sender;

- (IBAction)fetchMediaInfo:(id)sender;
- (IBAction)attachMedia:(id)sender;
- (IBAction)downloadMedia:(id)sender;
- (IBAction)deleteMedia:(id)sender;

- (IBAction)fetchComments:(id)sender;
- (IBAction)createComment:(id)sender;
- (IBAction)editComment:(id)sender;
- (IBAction)deleteComment:(id)sender;


@end
