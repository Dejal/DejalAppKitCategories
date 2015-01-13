//
//  NSImage+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Fri Oct 11 2002.
//  Copyright (c) 2002-2015 Dejal Systems, LLC. All rights reserved.
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

#import "NSImage+Dejal.h"


@implementation NSImage (Dejal)

- (void)dejal_drawFlippedInRect:(NSRect)rect operation:(NSCompositingOperation)op fraction:(CGFloat)delta
{
    CGContextRef context;

    context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);

    {
        CGContextTranslateCTM(context, 0, NSMaxY(rect));
        CGContextScaleCTM(context, 1, -1);

        rect.origin.y = 0;
        [self drawInRect:rect fromRect:NSZeroRect operation:op fraction:delta];
    }

    CGContextRestoreGState(context);
}

- (void)dejal_drawFlippedInRect:(NSRect)rect operation:(NSCompositingOperation)op
{
    [self dejal_drawFlippedInRect:rect operation:op fraction:1.0];
}

- (void)dejal_applyBadge:(NSImage *)badge withAlpha:(CGFloat)alpha scale:(CGFloat)scale
{
    if (!badge)
    {
        return;
    }
    
    NSImage *newBadge = [badge copy];
    
    newBadge.size = NSMakeSize(self.size.width * scale, self.size.height * scale);
    
    [self lockFocus];
    
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [newBadge drawAtPoint:NSMakePoint(self.size.width - newBadge.size.width, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];
    
    [self unlockFocus];
}

- (NSImage *)dejal_tintedImageWithColor:(NSColor *)tint;
{
    return [self dejal_tintedImageWithColor:tint operation:NSCompositeSourceAtop];
}

- (NSImage *)dejal_tintedImageWithColor:(NSColor *)tint operation:(NSCompositingOperation)operation;
{
    NSSize size = self.size;
    NSRect bounds = NSMakeRect(0.0, 0.0, size.width, size.height);
    NSImage *image = [[NSImage alloc] initWithSize:size];
    
    [image lockFocus];
    [self drawAtPoint:NSZeroPoint fromRect:bounds operation:NSCompositeSourceOver fraction:1.0];
    [tint set];
    NSRectFillUsingOperation(bounds, operation);
    [image unlockFocus];
    
    return image;
}

/**
 Returns a PNG representation of the receiver.
 
 @author DJS 2014-10.
 */

- (NSData *)dejal_PNGRepresentation;
{
    CGImageRef cgRef = [self CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    
    newRep.size = self.size;
    
    return [newRep representationUsingType:NSPNGFileType properties:nil];
}

@end

