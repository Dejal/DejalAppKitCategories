//
//  NSTextField+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Mon Feb 16 2004.
//  Copyright (c) 2004-2015 Dejal Systems, LLC. All rights reserved.
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

#import "NSTextField+Dejal.h"
#import "NSView+Dejal.h"
#import "NSWindow+Dejal.h"


@implementation NSTextField (Dejal)

/**
 Returns YES if the field's string value is non-empty, i.e. not nil and not @"".
 
 @author DJS 2005-03.
*/

- (BOOL)dejal_containsSomething
{
    return ([[self stringValue] length] > 0);
}

/**
 Performs the common task of setting a prompt label with a colon suffix.
 
 @author DJS 2004-02.
*/

- (void)dejal_setPromptLabel:(NSString *)label
{
    if ([label length])
    {
        if (![label hasSuffix:@":"])
            label = [label stringByAppendingString:@":"];
        
        [self setStringValue:label];
    }
}

/**
 Performs the common task of setting a field's value, making sure that the value isn't nil.
 
 @author DJS 2004-02.
*/

- (void)dejal_setFieldValue:(NSString *)value
{
    if (value)
        [self setStringValue:value];
    else
        [self setStringValue:@""];
}

/**
 Validates the field value using the range from the slider, and sets either the receiver or the slider to that value, as appropriate.  Returns the value.  All this could be done with bindings, but this works too, and works in Mac OS X 10.2.
 
 @author DJS 2005-03.
 @version DJS 2006-01: changed to divide by 60 if the maximum value is large, indicating minutes expressed in seconds.
 @version DJS 2014-01: changed to eliminate setting a preference, and instead return the value.
*/

- (NSInteger)dejal_syncronizeWithIntegerSlider:(NSSlider *)slider usingFieldValue:(BOOL)isUsingField
{
    NSInteger max = [slider maxValue];
    NSInteger value = 0;
    
    if (isUsingField)
    {
        value = [self integerValue];
        
        if (max > 1000)
            value *= 60;
    }
    else
        value = [slider integerValue];
    
    if (value < [slider minValue] || value > [slider maxValue])
    {
        isUsingField = NO;
        value = [slider integerValue];
    }
    
    if (isUsingField)
        [slider setIntegerValue:value];
    else
    {
        NSInteger temp = value;
        
        if (max > 1000)
            temp /= 60;
        
        [self setIntegerValue:temp];
    }
    
    return value;
}

/**
 If the field content doesn't currently fit within its frame, this method resizes the window that contains this field, and the field itself, so that it does fit.  The window and field are only resized vertically.  The auto-resizing springs and struts are not needed or affected for this change.  The window size is only increased, never decreased.  Returns YES if a resize was needed, or NO if it was already big enough.
 
 @author DJS 2006-01.
*/

- (BOOL)dejal_resizeWindowVerticallyToFit;
{
    NSRect oldFrame = [self frame];
    NSRect newFrame = oldFrame;
    
    // Determine the ideal height for the field:
    newFrame.size.height = 10000.0;
    newFrame.size = [[self cell] cellSizeForBounds:newFrame];
    
    // If no change, or the new height would be smaller, do nothing:
    if (NSHeight(newFrame) <= NSHeight(oldFrame))
        return NO;
    
    // We need to resize, so adjust the autoresize masks:
    NSArray *masks = [self dejal_adjustAutoresizeMasks];
    
    // Resize the window based on the new text field frame size:
    [[self window] dejal_setFrameSoView:self hasSize:newFrame.size centerHorizontalPostion:NO];
    
    // Tidy up:
    [self dejal_restoreAutoresizeMasks:masks];
    
    return YES;
}

@end

