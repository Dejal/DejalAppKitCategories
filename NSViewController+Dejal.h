//
//  NSViewController+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on 2015-01-21.
//  Copyright (c) 2015 Dejal Systems, LLC. All rights reserved.
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


@interface NSViewController (Dejal)

/**
 Returns the receiver's window controller, as a convenience.  Assumes that the window's delegate is the window controller, as is normally the case.
 
 @author DJS 2015-07.
 */

@property (nonatomic, weak, readonly) NSWindowController *dejal_windowController;

/**
 Returns the last child view controller of the receiver, as a convenience (e.g. when there's only one).
 
 @author DJS 2015-01.
 */

@property (nonatomic, strong, readonly) NSViewController *dejal_lastChildViewController;

/**
 Performs a transition between two sibling child view controllers of the view controller.  The same as the
 -transitionFromViewController:toViewController:options:completionHandler: method, except this variation supports either of the views being nil, and automatically adds and removes the view controllers as needed, in addition to their views.
 
 @param fromViewController A child view controller whose view is visible in the view controller’s view hierarchy, or nil if there isn't one yet.
 @param toViewController A child view controller whose view is not in the view controller’s view hierarchy, or nil to remove fromViewController.
 @param options A bitmask of options that specify how you want to perform the transition animation. For the options, see the NSViewControllerTransitionOptions enumeration.
 @param completion A block called immediately after the transition animation completes; may be nil.
 
 @author DJS 2015-01.
 */

- (void)dejal_transitionSubviewFromViewController:(NSViewController *)fromViewController toViewController:(NSViewController *)toViewController options:(NSViewControllerTransitionOptions)options completionHandler:(void (^)(void))completion;

@end

