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
//  MainWindow.m
//  DesktopDemo
//
//  Created by Jeff Meininger on 4/20/11.
//

#import "MainWindow.h"

static NSArray *splitViewHeights__ = nil;



@interface MainWindow ()
- (CGFloat)minimumSplitPosition;
@end



@implementation MainWindow

@synthesize splitView = splitView_;
@synthesize tabView = tabView_;
@synthesize outputScroller = outputScroller_;
@synthesize outputView = outputView_;
@synthesize createNoteTextView = createNoteTextView_;
@synthesize editNoteTextView = editNoteTextView_;
@synthesize attachMediaMimeTypeCell = attachMediaMimeTypeCell_;
@synthesize createCommentTextView = createCommentTextView_;
@synthesize editCommentTextView = editCommentTextView_;



- (void)awakeFromNib
{
    // ideal heights for top pane content
    splitViewHeights__ = [[NSArray alloc] initWithObjects:
                          [NSNumber numberWithFloat:95.0],  // Fetch
                          [NSNumber numberWithFloat:166.0], // Create
                          [NSNumber numberWithFloat:196.0], // Edit
                          [NSNumber numberWithFloat:132.0], // Delete
                          [NSNumber numberWithFloat:330.0], // Media
                          [NSNumber numberWithFloat:275.0], // Comments
                          nil];
    
    [self.splitView setPosition:[self minimumSplitPosition] ofDividerAtIndex:0];
    [self.outputView setString:@"DesktopDemo Output\n"];
}


- (void)logString:(NSString *)str
{
    // append string to bottom pane
    str = [str stringByAppendingString:@"\n"];
    NSAttributedString *aStr = [[[NSAttributedString alloc] initWithString:str] autorelease];
    
    NSTextStorage *text = [self.outputView textStorage];
    [text beginEditing];
    [text appendAttributedString:aStr];
    [text endEditing];
    
    // scroll to bottom
    NSRange range = NSMakeRange([[self.outputView string] length], 0);
    [self.outputView scrollRangeToVisible:range];
}


- (CGFloat)minimumSplitPosition
{
    // values lower than 218 cause some subviews to go negative-height, which 
    // causes layout problems.
    CGFloat minPos = [[splitViewHeights__ objectAtIndex:selectedTab_] floatValue];
    return MAX(218, minPos);
}




#pragma mark NSTabViewDelegate methods

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    selectedTab_ = [[tabViewItem identifier] intValue]-1;
    [self.splitView setPosition:[self minimumSplitPosition] ofDividerAtIndex:0];
}



#pragma mark NSSplitViewDelegate methods

- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize
{
    CGRect tabRect = self.tabView.frame;
    CGRect outputRect = self.outputScroller.frame;
    
    // width
    tabRect.size.width = splitView.frame.size.width;
    outputRect.size.width = splitView.frame.size.width;
    
    // height: must ensure we don't violate our minimumSplitPosition
    CGFloat minPos = [self minimumSplitPosition];
    CGFloat hDelta = splitView.frame.size.height-oldSize.height;
    if (hDelta > 0) {
        // expanding: give extra space to outputView.
        outputRect.size.height += hDelta;
    } else if (hDelta < 0) {
        // contracting: reduce size of tabView to minimum before shrinking outputView.
        tabRect.size.height += hDelta;
        if (tabRect.size.height < minPos) {
            outputRect.size.height -= (minPos-tabRect.size.height);
            tabRect.size.height = minPos;
        }
        outputRect.origin.y = tabRect.size.height+[splitView dividerThickness];
    }
    
    self.tabView.frame = tabRect;
    self.outputScroller.frame = outputRect;
}


- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition 
         ofSubviewAt:(NSInteger)dividerIndex
{
    if (dividerIndex == 0) {
        CGFloat minPos = [self minimumSplitPosition];
        return MAX(proposedPosition, minPos);
    }
    
    return proposedPosition;
}



@end
