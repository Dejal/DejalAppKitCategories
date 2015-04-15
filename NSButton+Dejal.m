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
 
 @author DJS 2015-04.
 */

- (void)dejal_displayMenu:(NSMenu *)menu;
{
    [self dejal_displayMenu:menu withOffset:4];
}

/**
 Displays a menu below the receiver.
 
 @param menu The menu to display.
 @param verticalOffset the offset to adjust vertically.
 
 @author DJS 2014-10.
 @version DJS 2015-04: Changed to use -popUpMenuPositioningItem::: instead of +popUpContextMenu:menu::.
 */

- (void)dejal_displayMenu:(NSMenu *)menu withOffset:(CGFloat)verticalOffset;
{
    NSPoint location = self.frame.origin;
    
    location.y -= verticalOffset;
    
    [menu popUpMenuPositioningItem:nil atLocation:location inView:self.superview];
}

/*
- (void)dejal_displayMenu:(NSMenu *)menu withOffset:(CGFloat)verticalOffset;
{
    NSRect frame = self.frame;
    NSPoint location = [self convertPoint:NSMakePoint(NSMinX(frame) - 5.0, NSMaxY(frame) + verticalOffset) toView:nil];
    NSEvent *event = [NSApp currentEvent];
    
    event = [NSEvent mouseEventWithType:event.type location:location modifierFlags:event.modifierFlags timestamp:event.timestamp windowNumber:event.windowNumber context:event.context eventNumber:event.eventNumber clickCount:event.clickCount pressure:event.pressure];
    
    [NSMenu popUpContextMenu:menu withEvent:event forView:self];
}
*/

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSButton (DejalRadios)

/**
 Assuming the receiver is a radio button, finds other radio buttons in the group (i.e. in the same superview and with the same action) and selects the one with the specified tag.  Invoke this on any of the radios in the group.  A replacement for -[NSMatrix selectCellWithTag:].
 
 @param tag The tag value to select.
 
 @author DJS 2015-01.
 */

- (void)dejal_selectRadioWithTag:(NSInteger)tag;
{
    [self dejal_enumerateRadiosUsingBlock:^(NSButton *radio, BOOL *stop)
     {
         radio.state = radio.tag == tag;
     }];
}

/**
 Assuming the receiver is a radio button, finds other radio buttons in the group (i.e. in the same superview and with the same action) and returns the tag value of the selected radio.  Invoke this on any of the radios in the group.  A replacement for -[NSMatrix selectedTag].
 
 @returns A tag value integer.
 
 @author DJS 2015-01.
 */

- (NSInteger)dejal_selectedRadioTag;
{
    NSButton *foundRadio = [self dejal_radioPassingTest:^BOOL(NSButton *radio, BOOL *stop)
     {
         return radio.state;
     }];
    
    return foundRadio.tag;
}

/**
 Returns YES if the radio group is enabled, or NO if not.  Simply returns the state of the receiver; the others are assumed to be the same.  (If you want to know if they are all enabled or disabled, probably best to use -dejal_enumerateRadiosUsingBlock: to scan the group, and handle a mixed case as needed.)
 
 @author DJS 2015-01.
 */

- (BOOL)dejal_radiosEnabled;
{
    return self.enabled;
}

/**
 Sets all of the radios in the group to be enabled or disabled.  A replacement for -[NSMatrix setEnabled:].
 
 @author DJS 2015-01.
 */

- (void)dejal_setRadiosEnabled:(BOOL)enabled;
{
    [self dejal_enumerateRadiosUsingBlock:^(NSButton *radio, BOOL *stop)
     {
         radio.enabled = enabled;
     }];
}

/**
 Assuming the receiver is a radio button, finds other radio buttons in the group (i.e. in the same superview and with the same action) and performs the block for each of them, passing the radio to the block.  Returns the one that returns YES, or nil if the block requests to stop before completion, or it completes without the block returning YES.  Invoke this on any of the radios in the group.
 
 @param block A block that takes a radio button and stop boolean reference as parameters and returns a boolean.
 @returns The found radio button, or nil if none is found.
 
 @author DJS 2015-01.
 */

- (NSButton *)dejal_radioPassingTest:(BOOL (^)(NSButton *radio, BOOL *stop))predicate;
{
    for (NSButton *radio in self.superview.subviews)
    {
        // There's no reliable way to determine if a button is actually a radio button, but it's reasonable to assume that no non-radio will have the same action (and having the same action is what makes it a member of the group):
        if ([radio isKindOfClass:[NSButton class]] && radio.action == self.action && predicate)
        {
            BOOL stop = NO;
            
            if (predicate(radio, &stop))
            {
                return radio;
            }
            
            if (stop)
            {
                return nil;
            }
        }
    }
    
    return nil;
}

/**
 Assuming the receiver is a radio button, finds other radio buttons in the group (i.e. in the same superview and with the same action) and performs the block for each of them, passing the radio to the block.  Invoke this on any of the radios in the group.
 
 @param block A block that takes a radio button and stop boolean reference as parameters and returns void.
 
 @author DJS 2015-01.
 */

- (void)dejal_enumerateRadiosUsingBlock:(void (^)(NSButton *radio, BOOL *stop))block;
{
    for (NSButton *radio in self.superview.subviews)
    {
        // There's no reliable way to determine if a button is actually a radio button, but it's reasonable to assume that no non-radio will have the same action (and having the same action is what makes it a member of the group):
        if ([radio isKindOfClass:[NSButton class]] && radio.action == self.action && block)
        {
            BOOL stop = NO;
            
            block(radio, &stop);
            
            if (stop)
            {
                return;
            }
        }
    }
}

@end

