//
//  NSWindow+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Tue Jul 01 2003.
//  Copyright (c) 2003-2015 Dejal Systems, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSWindow+Dejal.h"


@implementation NSWindow (Dejal)

/**
 Makes the specified view the first responder, if possible, and regardless ensures that no field editor is in use.  Should always call this before creating a new field editor, or to flush edits to a current field without having to be notified of each keystroke.
 
 @author DJS 2004-01.
*/

- (void)dejal_forceEndEditingForView:(NSView *)view
{
    // Make sure noone else is using the field editor:
    if (![self makeFirstResponder:view])
        [self endEditingFor:nil];
}


/**
 Sets the alpha value of the window to the percentage (from 0.0 to 100.0), and displays the window.  Normally you'd call the following method to animate the fade instead of this.
 
 @author DJS 2003-01.
 @version DJS 2003-07: changed to make into a category.
*/

- (void)dejal_fadeTo:(CGFloat)percent
{
    if (percent > 100.0)
        percent = 100.0;
    else if (percent < 0.0)
        percent = 0.0;

    CGFloat amount = percent / 100.0;

    // Set the window's alpha value from 0.0-1.0:
    [self setAlphaValue:amount];

    // Tell the window to redraw things:
    [self display];
}

/**
 Fades a transparent window to opaque if fadeIn is YES, otherwise vice versa, taking the indicated total time to make the transition.  See also fadeIn:forInterval:target:selector:withObject: if you want to do other work while the window is fading in or out.

 @author DJS 2003-07.
 */

- (void)dejal_fadeIn:(BOOL)fadeIn forInterval:(NSTimeInterval)totalTime
{
    [self dejal_fadeIn:fadeIn forInterval:totalTime target:nil selector:nil withObject:nil];
}

/**
 Fades a transparent window to opaque if fadeIn is YES, otherwise vice versa, taking the indicated total time to make the transition.  While this is being animated, the selector is sent to the target with the object parameter.  The target or selector can be nil to avoid this.  The method thus called must have one (and only one) parameter: the object.  The object can have any value.  e.g.

 - (void)doSomethingDuringFadeIn:(id)object;
 
 @author DJS 2003-01.
 @changed DJS 2003-07: changed to make into a category.
*/

- (void)dejal_fadeIn:(BOOL)fadeIn forInterval:(NSTimeInterval)totalTime target:(id)target selector:(SEL)aSelector withObject:(id)object
{
    NSDate *start = [NSDate date];
    NSTimeInterval elapsedTime;
    CGFloat percent;

    do
    {
        elapsedTime = -[start timeIntervalSinceNow];
        percent = (elapsedTime * 100.0) / totalTime;

//        NSLog(@"time = %f; percent = %d", elapsedTime, percent);

        if (!fadeIn)
            percent = 100.0 - percent;

        [self dejal_fadeTo:percent];

        if (target && aSelector)
            [target performSelector:aSelector withObject:object];
    }
    while (elapsedTime < totalTime);

    if (fadeIn)
        [self dejal_fadeTo:100.0];
    else
        [self dejal_fadeTo:0.0];
}

/**
 Resizes the receiver window so that the specified view will be resized to the indicated size -- assuming that the auto-sizing springs are set for that view.  If centerHoriz is YES, the window position is moved so the horizontal center of the window remains in the same place, otherwise the window position is not changed.  Normally would pass YES for sheets and NO for windows, though some windows may want to pass YES.
 
 @author DJS 2004-10.
*/

- (void)dejal_setFrameSoView:(NSView *)view hasSize:(NSSize)newViewSize centerHorizontalPostion:(BOOL)centerHoriz
{
    if (!view)
        return;
    
    NSRect oldViewFrame = [view frame];
    
    CGFloat deltaH = newViewSize.width - NSWidth(oldViewFrame);
    CGFloat deltaV = newViewSize.height - NSHeight(oldViewFrame);
    
    NSRect oldWindowFrame = [NSWindow contentRectForFrameRect:[self frame] styleMask:[self styleMask]];
    
    CGFloat newWindowWidth = NSWidth(oldWindowFrame) + deltaH;
    CGFloat newWindowHeight = NSHeight(oldWindowFrame) + deltaV;
    CGFloat horizPosition = centerHoriz ? NSMinX(oldWindowFrame) - (deltaH / 2) : NSMinX(oldWindowFrame);
    
    NSRect newWindowFrame = [NSWindow frameRectForContentRect:NSMakeRect(horizPosition, NSMaxY(oldWindowFrame) - newWindowHeight, newWindowWidth, newWindowHeight) styleMask:[self styleMask]];
    
    [self setFrame:newWindowFrame display:YES animate:[self isVisible]];
}

@end

