//
//  NSView+Dejal.h
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


@interface NSView (DejalSubviews)

- (BOOL)dejal_isDark;

- (void)dejal_addFullyConstrainedSubview:(NSView *)subview;
- (void)dejal_addFullSizeConstraintsForSubview:(NSView *)subview;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSView (DejalSizing)

- (NSArray *)dejal_adjustAutoresizeMasks;
- (NSArray *)dejal_adjustAutoresizingAroundPosition:(CGFloat)position stickPositionToTop:(BOOL)stickPositionToTop;

- (void)dejal_restoreAutoresizeMasks:(NSArray *)masks;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSView (DejalScaling)

@property (nonatomic, setter=dejal_setScale:) NSSize dejal_scale;
@property (nonatomic, setter=dejal_setScalePercent:) CGFloat dejal_scalePercent;

- (void)dejal_resetScaling;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSView (DejalDrawing)

@property (nonatomic, setter=dejal_setAlphaOpaque:) BOOL dejal_alphaOpaque;

- (void)dejal_setAlphaOpaque:(BOOL)makeOpaque animated:(BOOL)animated;

@end

