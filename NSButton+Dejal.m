//
//  NSButton+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on 2014-10-04.
//  Copyright (c) 2014-2015 Dejal Systems, LLC. All rights reserved.
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

#import "NSButton+Dejal.h"


@implementation NSButton (Dejal)

/**
 Returns the color of the receiver's text.
 
 @author DJS 2014-10, based on Apple's Popover sample code.
 */

- (NSColor *)dejal_textColor;
{
    NSAttributedString *attrTitle = self.attributedTitle;
    NSColor *textColor = [NSColor controlTextColor];
    
    if (attrTitle.length)
    {
        NSDictionary *attrs = [attrTitle fontAttributesInRange:NSMakeRange(0, 1)];
        
        if (attrs)
        {
            textColor = [attrs objectForKey:NSForegroundColorAttributeName];
        }
    }
    
    return textColor;
}

/**
 Sets the receiver's text to the specified color.
 
 @author DJS 2014-10, based on Apple's Popover sample code.
 */

- (void)dejal_setTextColor:(NSColor *)textColor;
{
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
    NSRange range = NSMakeRange(0, attrTitle.length);
    
    if (textColor)
    {
        [attrTitle addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    }
    else
    {
        [attrTitle removeAttribute:NSForegroundColorAttributeName range:range];
    }
    
    [attrTitle fixAttributesInRange:range];
    
    self.attributedTitle = attrTitle;
}

/**
 Displays a menu below the receiver.
 
 @param menu The menu to display.
 
 @author DJS 2014-10.
 */

- (void)dejal_displayMenu:(NSMenu *)menu withOffset:(CGFloat)verticalOffset;
{
    NSRect frame = self.frame;
    NSPoint location = [self convertPoint:NSMakePoint(NSMinX(frame) - 5.0, NSMaxY(frame) + verticalOffset) toView:nil];
    NSEvent *event = [NSApp currentEvent];
    
    event = [NSEvent mouseEventWithType:event.type location:location modifierFlags:event.modifierFlags timestamp:event.timestamp windowNumber:event.windowNumber context:event.context eventNumber:event.eventNumber clickCount:event.clickCount pressure:event.pressure];
    
    [NSMenu popUpContextMenu:menu withEvent:event forView:self];
}

@end

