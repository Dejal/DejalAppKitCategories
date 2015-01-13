//
//  NSTextView+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Mon May 24 2004.
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

#import "NSTextView+Dejal.h"
#import "NSAttributedString+Dejal.h"


@implementation NSTextView (Dejal)

/**
 Returns the number of characters in the text view.
 
 @author DJS 2004-05.
*/

- (NSInteger)dejal_length
{
    return [[self string] length];
}

/**
 Returns a NSRange that includes all characters in the text view.
 
 @author DJS 2004-05.
*/

- (NSRange)dejal_allRange
{
    return NSMakeRange(0, [self dejal_length]);
}

/**
 After changing the font or foreground/background colors of a NSTextView, call this to apply those changes to zero-length selections too (i.e. the next user typing).  Otherwise, new typing will be inserted in the old style (which can be useful sometimes).
 
 @author DJS 2006-10.
*/

- (void)dejal_setTypingAttributesToMatchView;
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    attributes[NSFontAttributeName] = [self font];
    attributes[NSForegroundColorAttributeName] = [self textColor];
    attributes[NSBackgroundColorAttributeName] = [self backgroundColor];
    
    [self setTypingAttributes:attributes];
}

/**
 Action method to select no text; the opposite of -selectAll:.  Makes an insertion point at the start of the current selection, if any.  Does nothing if there is no selection.
 
 @author DJS 2007-02.
*/

- (IBAction)deselectAll:(id)sender;
{
    NSRange range = [self selectedRange];
    
    if (range.length == 0)
        return;
    
    range.length = 0;
    
    [self setSelectedRange:range];
}


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


/**
 Appends the specified plain string to the end of the receiver.
 
 @author DJS 2004-07.
*/

- (void)dejal_appendStringValue:(NSString *)value
{
    [[self textStorage] appendAttributedString:[NSAttributedString dejal_attributedStringWithString:value]];
}

/**
 Appends the specified attributed string to the end of the receiver.
 
 @author DJS 2004-07.
*/

- (void)dejal_appendAttributedStringValue:(NSAttributedString *)value
{
    [[self textStorage] appendAttributedString:value];
}


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


/**
 Returns an autoreleased copy of the selected text of the receiver as a plain string.
 
 @author DJS 2004-07.
*/

- (NSString *)dejal_selectedStringValue
{
    NSRange range = [self selectedRange];
    
    if (range.length == 0)
        return @"";
    else
        return [[self string] substringWithRange:range];
}

/**
 Returns an autoreleased copy of the selected text of the receiver as a plain string.
 
 @author DJS 2004-07.
*/

- (NSString *)dejal_selectedOrAllStringValue
{
    NSRange range = [self selectedRange];
    
    if (range.length == 0)
        return [self dejal_stringValue];
    else
        return [[self string] substringWithRange:range];
}

/**
 Returns an autoreleased copy of the selected text of the receiver as an attributed string.
 
 @author DJS 2004-07.
*/

- (NSAttributedString *)dejal_selectedAttributedStringValue
{
    NSRange range = [self selectedRange];
    
    if (range.length == 0)
        return [NSAttributedString dejal_attributedString];
    else
        return [[self textStorage] attributedSubstringFromRange:range];
}

/**
 Returns an autoreleased copy of the selected text of the receiver as an attributed string.
 
 @author DJS 2004-07.
*/

- (NSAttributedString *)dejal_selectedOrAllAttributedStringValue
{
    NSRange range = [self selectedRange];
    
    if (range.length == 0)
        return [self dejal_attributedStringValue];
    else
        return [[self textStorage] attributedSubstringFromRange:range];
}


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


/**
 Returns an autoreleased copy of the text as a plain string; see also the standard -string method for a non-copied edition.
 
 @author DJS 2004-05.
*/

- (NSString *)dejal_stringValue
{
    return [[self string] copy];
}

/**
 Returns an autoreleased copy of the text as an attributed string.
 
 @author DJS 2004-05.
*/

- (NSAttributedString *)dejal_attributedStringValue
{
    return [[self textStorage] copy];
}

/**
 Returns a RTF edition of the text.
 
 @author DJS 2004-05.
*/

- (NSData *)dejal_RTFValue
{
    NSAttributedString *text = [self dejal_attributedStringValue];
    
    return [text RTFFromRange:NSMakeRange(0, [text length]) documentAttributes:nil];
}

/**
 Returns a RTFD edition of the text.
 
 @author DJS 2004-05.
*/

- (NSData *)dejal_RTFDValue
{
    NSAttributedString *text = [self dejal_attributedStringValue];
    
    return [text RTFDFromRange:NSMakeRange(0, [text length]) documentAttributes:nil];
}


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


/**
 Replaces all of the text with the specified plain string (using the current font etc)
 
 @author DJS 2004-05.
*/

- (void)dejal_setStringValue:(NSString *)value
{
    if (value)
        [self replaceCharactersInRange:[self dejal_allRange] withString:value];
}

/**
 Replaces all of the text with the specified attributed string.
 
 @author DJS 2004-05.
*/

- (void)dejal_setAttributedStringValue:(NSAttributedString *)value
{
    if (value)
        [[self textStorage] replaceCharactersInRange:[self dejal_allRange] withAttributedString:[value copy]];
}

/**
 Replaces all of the text with the specified RTF data.
 
 @author DJS 2004-05.
*/

- (void)dejal_setRTFValue:(NSData *)value
{
    [self replaceCharactersInRange:[self dejal_allRange] withRTF:value];
}

/**
 Replaces all of the text with the specified RTFD data.
 
 @author DJS 2004-05.
*/

- (void)dejal_setRTFDValue:(NSData *)value
{
    [self replaceCharactersInRange:[self dejal_allRange] withRTFD:value];
}


/**
 Replaces all of the text with the richest of the specified values; any or all may be nil.  If none are valid, the text is cleared.
 
 @author DJS 2004-05.
*/

- (void)dejal_setRTFDValue:(NSData *)theRTFD orRTF:(NSData *)theRTF orAttributedString:(NSAttributedString *)attrString orString:(NSString *)string
{
    if ([theRTFD length])
        [self dejal_setRTFDValue:theRTFD];
    else if ([theRTF length])
        [self dejal_setRTFValue:theRTF];
    else if ([attrString length])
        [self dejal_setAttributedStringValue:attrString];
    else if (string)
        [self dejal_setStringValue:string];
    else
        [self dejal_setStringValue:@""];
}

@end

