//
//  NSMenu+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Thu Oct 09 2003.
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

#import <Cocoa/Cocoa.h>


@interface NSMenu (Dejal)

- (void)dejal_addSeparatorItem;

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector keyEquivalent:(NSString *)keyEquiv;

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector representedObject:(id)object tag:(NSInteger)tag;

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector keyEquivalent:(NSString *)keyEquiv icon:(NSImage *)icon;

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector keyEquivalent:(NSString *)keyEquiv icon:(NSImage *)icon representedObject:(id)object;

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector keyEquivalent:(NSString *)keyEquiv modifierMask:(NSUInteger)modifierMask icon:(NSImage *)icon representedObject:(id)object;

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector keyEquivalent:(NSString *)keyEquiv modifierMask:(NSUInteger)modifierMask icon:(NSImage *)icon representedObject:(id)object tag:(NSInteger)tag;

- (NSInteger)dejal_removeItemWithTarget:(id)target andAction:(SEL)action;
- (void)dejal_removeItemsWithTarget:(id)target andAction:(SEL)action;

- (NSMenuItem *)dejal_itemWithTarget:(id)target andAction:(SEL)action;
- (NSMenuItem *)dejal_itemWithTarget:(id)target action:(SEL)action tag:(NSInteger)tag;

- (void)dejal_setCheckedItemForTarget:(id)target andAction:(SEL)action withTag:(NSInteger)tag;

@end

