//
//  NSSplitView+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on 2013-02-19.
//  Copyright (c) 2013-2015 Dejal Systems, LLC. All rights reserved.
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

#import "NSSplitView+Dejal.h"
#import <QuartzCore/QuartzCore.h>


@implementation NSSplitView (Dejal)

/**
 Adds an animatable property for the splitPosition key.
 
 @author DJS 2013-02.
*/

+ (id)defaultAnimationForKey:(NSString *)key;
{
    if ([key isEqualToString:@"splitPosition"])
    {
        CAAnimation *animation = [CABasicAnimation animation];
        
        animation.duration = 0.2;
        
        return animation;
    }
    else
        return [super defaultAnimationForKey:key];
}

/**
 Returns the current position of the specified split divider.
 
 @param idx The divider, where the first is zero.
 @returns The position of the divider.
 
 @author DJS 2014-10.
 */

- (CGFloat)dejal_splitPositionOfDividerAtIndex:(NSUInteger)idx;
{
    NSRect frame = [[[self subviews] objectAtIndex:idx] frame];
    
    if ([self isVertical])
        return NSMaxX(frame);
    else
        return NSMaxY(frame);
}

/**
 Returns the current position of the first split divider.
 
 @author DJS 2013-02.
 @version DJS 2014-10: changed to use the -splitPositionOfDividerAtIndex: method.
*/

- (CGFloat)dejal_splitPosition;
{
    return [self dejal_splitPositionOfDividerAtIndex:0];
}

/**
 Sets the position of the first split divider.  Can be animated by [[splitView animator] setSplitPosition:position].
 
 @author DJS 2013-02.
*/

- (void)dejal_setSplitPosition:(CGFloat)position;
{
    [self setPosition:position ofDividerAtIndex:0];
}

/**
 Toggle the visability of the subview at the specified index; assumes that only two subviews are used.
 
 @param idx The index to collapse or expand.
 
 @author DJS 2014-09.
 */

- (void)dejal_toggleSubviewAtIndex:(NSUInteger)idx;
{
    BOOL isCollapsed = [self isSubviewCollapsed:[self.subviews objectAtIndex:idx]];
    
    if (isCollapsed)
    {
        [self dejal_expandSubviewAtIndex:idx];
    }
    else
    {
        [self dejal_collapseSubviewAtIndex:idx];
    }
}

/**
 Collapses the subview at the specified index; assumes that only two subviews are used.  Does nothing if already collapsed
 
 @param idx The index to collapse.
 
 @author DJS 2014-09.
 */

- (void)dejal_collapseSubviewAtIndex:(NSUInteger)idx;
{
    NSUInteger other = idx ? 0 : 1;

    NSView *remaining  = [self.subviews objectAtIndex:other];
    NSView *collapsing = [self.subviews objectAtIndex:idx];
    NSRect remainingFrame = remaining.frame;
    NSRect overallFrame = self.frame;
    
    if (collapsing.hidden)
    {
        return;
    }
    
    collapsing.hidden = YES;
    
    if (self.vertical)
    {
        remaining.frameSize = NSMakeSize(overallFrame.size.width, remainingFrame.size.height);
    }
    else
    {
        remaining.frameSize = NSMakeSize(remainingFrame.size.width, overallFrame.size.height);
    }
    
    [self display];
}

/**
 Expands the subview at the specified index; assumes that only two subviews are used.  Does nothing if already expanded
 
 @param idx The index to expand.
 
 @author DJS 2014-09.
 */

- (void)dejal_expandSubviewAtIndex:(NSUInteger)idx;
{
    NSUInteger other = idx ? 0 : 1;
    
    NSView *remaining  = [self.subviews objectAtIndex:other];
    NSView *collapsing = [self.subviews objectAtIndex:idx];
    CGFloat thickness = self.dividerThickness;
    
    if (!collapsing.hidden)
    {
        return;
    }
    
    collapsing.hidden = NO;
    
    NSRect remainingFrame = remaining.frame;
    NSRect collapsingFrame = collapsing.frame;
    
    if (self.vertical)
    {
        remainingFrame.size.height = (remainingFrame.size.height - collapsingFrame.size.height - thickness);
        collapsingFrame.origin.y = remainingFrame.size.height + thickness;
    }
    else
    {
        remainingFrame.size.width = (remainingFrame.size.width - collapsingFrame.size.width - thickness);
        collapsingFrame.origin.x = remainingFrame.size.width + thickness;
    }
    
    remaining.frameSize = remainingFrame.size;
    collapsing.frame = collapsingFrame;
    
    [self display];
}

@end

