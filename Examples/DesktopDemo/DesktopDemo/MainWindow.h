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
//  MainWindow.h
//  DesktopDemo
//
//  Created by Jeff Meininger on 4/20/11.
//

#import <Foundation/Foundation.h>

#define MWLog(format, ...) [(MainWindow *)[NSApp mainWindow] logString:[NSString stringWithFormat:format, ## __VA_ARGS__]]
#define MWLogBanner(title) MWLog(@"\n=== %@ ===", title)
#define MWLogException(exception) MWLog(@"*** ERROR %@: %@", [exception name], [exception reason]);


@interface MainWindow : NSWindow <NSTabViewDelegate, NSSplitViewDelegate> {
@private
    NSInteger selectedTab_;
}

@property (assign) IBOutlet NSSplitView *splitView;
@property (assign) IBOutlet NSTabView *tabView;
@property (assign) IBOutlet NSScrollView *outputScroller;
@property (assign) IBOutlet NSTextView *outputView;

@property (assign) IBOutlet NSTextView *createNoteTextView;
@property (assign) IBOutlet NSTextView *editNoteTextView;

@property (assign) IBOutlet NSFormCell *attachMediaMimeTypeCell;

@property (assign) IBOutlet NSTextView *createCommentTextView;
@property (assign) IBOutlet NSTextView *editCommentTextView;

- (void)logString:(NSString *)str;

@end
