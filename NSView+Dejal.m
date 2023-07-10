//
//  NSView+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Fri Dec 10 2004.
//  Copyright (c) 2004-2018 Dejal Systems, LLC. All rights reserved.
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


#import "NSView+Dejal.h"


@implementation NSView (DejalSubviews)

/**
 Returns whether or not the current appearance is dark mode.  A similar class method is also provided in the NSColor+Dejal category, for when a view isn't available.
 
 @returns YES if dark, otherwise NO.
 
 @author DJS 2018-09.
 */

- (BOOL)dejal_isDark;
{
    return [self.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]] == NSAppearanceNameDarkAqua;
}

/**
 Adds the specified view as a subview of the reciever, and sets its Auto Layout constraints to keep it the full size of the receiver.
 
 @author DJS 2012-06.
 @version DJS 2015-01: Split the Auto Layout part out to a separate method.
*/

- (void)dejal_addFullyConstrainedSubview:(NSView *)subview;
{
    [self addSubview:subview];
    [self dejal_addFullSizeConstraintsForSubview:subview];
}

/**
 Adjusts the Auto Layout constraints of the specified subview of the reciever to keep it the full size of the receiver.
 
 @author DJS 2015-01.
*/

- (void)dejal_addFullSizeConstraintsForSubview:(NSView *)subview;
{
    // See also the IB checkbox for the root level of a view controller's views "Translates Mask Into Constraints":
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|" options:0 metrics:nil views:views]];
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSView (DejalSizing)

/**
 Adjusts the autoresize masks in the window so that when the window is resized, the receiver will expand vertically and other views will remain the same height.  Returns an array of the old masks, to be passed to -restoreAutoresizeMasks, below, to change the masks back to how they were before this method was invoked.
 
 @author DJS 2006-01.
*/

- (NSArray *)dejal_adjustAutoresizeMasks;
{
    return [self dejal_adjustAutoresizingAroundPosition:NSMaxY([self frame]) stickPositionToTop:YES];
}

/**
 Adjusts the autoresize masks in the window so that when the window is resized, the receiver will expand vertically and other views will remain the same height.  Returns an array of the old masks, to be passed to -restoreAutoresizeMasks, below, to change the masks back to how they were before this method was invoked.
 
 @author DJS 2006-01, based on code from my ViewsListView.
*/

- (NSArray *)dejal_adjustAutoresizingAroundPosition:(CGFloat)position stickPositionToTop:(BOOL)stickPositionToTop;
{
    NSMutableArray *subviewMasks = [NSMutableArray array];
    NSView *superview = self;
    NSView *oldSuperview = superview;
    
    while (superview)
    {
        // First adjust the superview's mask:
        NSUInteger mask = [superview autoresizingMask];
        [subviewMasks addObject:@(mask)];
        
        // Make it stick to the top and bottom of the window, and change height:
        mask |= NSViewHeightSizable;
        mask &= ~NSViewMaxYMargin;
        mask &= ~NSViewMinYMargin;
        
        [superview setAutoresizingMask:mask];
        
        NSArray *subviews = [superview subviews];
        
        for (NSView *subview in subviews)
        {
            
            if (subview != oldSuperview)
            {
                mask = [subview autoresizingMask];
                BOOL stickToBottom = NSMaxY([subview frame]) <= position;
                
                if (!stickPositionToTop && (NSMaxY([subview frame]) == position))
                    stickToBottom = YES;
                
                [subviewMasks addObject:@(mask)];
                
                if (stickToBottom)
                {
                    // This subview is below us.  Make it stick to the bottom of the window and not change height:
                    mask &= ~NSViewHeightSizable;
                    mask |= NSViewMaxYMargin;
                    mask &= ~NSViewMinYMargin;
                }
                else
                {
                    // This subview is above us.  Make it stick to the top of the window, and not change height:
                    mask &= ~NSViewHeightSizable;
                    mask &= ~NSViewMaxYMargin;
                    mask |= NSViewMinYMargin;
                }
                
                [subview setAutoresizingMask:mask];
            }
        }
        
        // Go to this superview's superview and repeat the process; note that the looping algorithm must be replicated exactly in the restore method, below.  Ideally both methods should use another method to get the next subview, but I can't be bothered refactoring it at this stage, so just be aware of the issue:
        oldSuperview = superview;
        position = NSMaxY([superview frame]);
        superview = [superview superview];
    }
    
    return subviewMasks;
}

/**
 Changes the window's autoresizing masks back to how they were before -adjustAutoresizeMasks or -adjustAutoresizingAroundPosition:stickPositionToTop: was invoked.
 
 @author DJS 2006-01, based on code from my ViewsListView.
*/

- (void)dejal_restoreAutoresizeMasks:(NSArray *)masks;
{
    NSView *superview = self;
    NSView *oldSuperview = superview;
    NSEnumerator *enumerator = [masks objectEnumerator];
    
    while (superview)
    {
        // First item is the superview's mask:
        [superview setAutoresizingMask:[[enumerator nextObject] unsignedIntegerValue]];
        
        // Following items are the subview masks:
        NSArray *subviews = [superview subviews];
        
        for (NSView *subview in subviews)
        {
            
            if (subview != oldSuperview)
                [subview setAutoresizingMask:[[enumerator nextObject] unsignedIntegerValue]];
        }
        
        // Go to this superview's superview and repeat the process; note that the looping algorithm must be replicated exactly in the adjust method, above.  Ideally both methods should use another method to get the next subview, but I can't be bothered refactoring it at this stage, so just be aware of the issue:
        oldSuperview = superview;
        superview = [superview superview];
    }
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSView (DejalScaling)

const NSSize unitSize = {1.0, 1.0};

/**
 This method makes the scaling of the receiver equal to the window's base coordinate system.
 
 @author Apple; added by DJS 2004-12.  See <http://developer.apple.com/qa/qa2004/qa1346.html>.
*/

- (void)dejal_resetScaling
{
    [self scaleUnitSquareToSize:[self convertSize:unitSize fromView:nil]];
}

/**
 This method returns the scale of the receiver's coordinate system, relative to the window's base coordinate system, expressed in absolute terms.
 
 @author Apple; added by DJS 2004-12.  See <http://developer.apple.com/qa/qa2004/qa1346.html>.
*/

- (NSSize)dejal_scale
{
    return [self convertSize:unitSize fromView:nil];
}

/**
 This method sets the scale in absolute terms.
 
 @author Apple; added by DJS 2004-12.  See <http://developer.apple.com/qa/qa2004/qa1346.html>.
*/

- (void)dejal_setScale:(NSSize)newScale
{
    [self dejal_resetScaling];  // First, match our scaling to the window's coordinate system
    [self scaleUnitSquareToSize:newScale]; // Then, set the scale.
}

/**
 This method returns the scale of the receiver's coordinate system, relative to the window's base coordinate system, expressed as a percentage.
 
 @author Apple; added by DJS 2004-12.  See <http://developer.apple.com/qa/qa2004/qa1346.html>.
*/

- (CGFloat)dejal_scalePercent
{
    return [self dejal_scale].width * 100;
}

/**
 This method sets the scale expressed as a percentage.
 
 @author Apple; added by DJS 2004-12.  See <http://developer.apple.com/qa/qa2004/qa1346.html>.
*/

- (void)dejal_setScalePercent:(CGFloat)scale
{
    scale = scale / 100.0;
    [self dejal_setScale:NSMakeSize(scale, scale)];
    [self setNeedsDisplay:YES];
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSView (DejalDrawing)

/**
 Returns YES if the alphaValue of the receiver is 1.0, otherwise NO.
 
 @author DJS 2014-10.
 */

- (BOOL)dejal_alphaOpaque;
{
    return self.alphaValue == 1.0;
}

/**
 Changes the alphaValue of the receiver to make it opaque or transparent.
 
 @param makeOpaque If YES, sets the alphaValue of the receiver to 1.0 (opaque), otherwise sets it to 0.0 (transparent).
 
 @author DJS 2014-10.
 */

- (void)dejal_setAlphaOpaque:(BOOL)makeOpaque;
{
    self.alphaValue = makeOpaque ? 1.0 : 0.0;
}

/**
 Changes the alphaValue of the receiver to make it opaque or transparent, optionally with animation.
 
 @param makeOpaque If YES, sets the alphaValue of the receiver to 1.0 (opaque), otherwise sets it to 0.0 (transparent).
 @param animated If YES, the animator is used to set the alphaValue, otherwise it's set immediately.
 
 @author DJS 2014-10.
 */

- (void)dejal_setAlphaOpaque:(BOOL)makeOpaque animated:(BOOL)animated;
{
    if (animated)
    {
        self.animator.alphaValue = makeOpaque ? 1.0 : 0.0;
    }
    else
    {
        self.alphaValue = makeOpaque ? 1.0 : 0.0;
    }
}

@end

