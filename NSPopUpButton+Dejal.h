//
//  NSPopUpButton+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Fri Mar 12 2004.
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


@interface NSPopUpButton (Dejal)

- (void)dejal_addSeparatorItem;

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString tag:(NSInteger)tag;
- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString tag:(NSInteger)tag representedObject:(id)object;

- (void)dejal_addItemsWithPaths:(NSArray *)paths prefixDivider:(BOOL)prefixDivider tag:(NSInteger)tag abbreviatedObject:(BOOL)abbreviatedObject defaultPath:(NSString *)defaultPath;

- (NSMenuItem *)dejal_itemWithTag:(NSInteger)aTag;
- (NSInteger)dejal_tagOfSelectedItem;

- (NSInteger)dejal_selectItemWithRepresentedObject:(id)anObj;
- (id)dejal_representedObjectOfSelectedItem;

@end

