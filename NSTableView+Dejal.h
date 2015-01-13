//
//  NSTableView+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Mon Aug 12 2002.
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


@protocol DejalTableViewDelegate <NSTableViewDelegate>
@optional

- (NSMenu *)tableView:(NSTableView *)tableView menuForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (NSIndexSet *)tableView:(NSTableView *)tableView shouldCutRowIndexes:(NSIndexSet *)indexes;
- (NSIndexSet *)tableView:(NSTableView *)tableView shouldCopyRowIndexes:(NSIndexSet *)indexes;
- (NSInteger)tableView:(NSTableView *)tableView shouldPasteBeforeRow:(NSInteger)row;
- (NSIndexSet *)tableView:(NSTableView *)tableView shouldDeleteRowIndexes:(NSIndexSet *)indexes;
- (NSIndexSet *)tableView:(NSTableView *)tableView shouldSaveRowIndexes:(NSIndexSet *)indexes;

- (BOOL)tableView:(NSTableView *)tableView deleteRowIndexes:(NSIndexSet *)indexes;

- (NSString *)tableView:(NSTableView *)tableView stringValueForRow:(NSInteger)row;

- (NSImage *)tableView:(NSTableView *)tableView dragImageForRowsWithIndexes:(NSIndexSet *)dragRows tableColumns:(NSArray *)tableColumns event:(NSEvent *)dragEvent offset:(NSPointPointer)dragImageOffset;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSTableView (Dejal)

- (id <DejalTableViewDelegate>)dejal_delegate;

- (IBAction)selectNone:(id)sender;

- (NSIndexSet *)dejal_allRowIndexes;
- (NSIndexSet *)dejal_selectedOrAllRowIndexes;
- (NSIndexSet *)dejal_multipleSelectedOrAllRowIndexes;

- (NSEnumerator *)dejal_rowEnumerator;
- (NSEnumerator *)dejal_selectedRowsEnumerator;
- (NSEnumerator *)dejal_selectedOrAllRowsEnumerator;
- (NSEnumerator *)dejal_multipleSelectedOrAllRowsEnumerator;

- (void)dejal_selectFirstRowExtendingSelection:(BOOL)extendSel;
- (void)dejal_selectLastRowExtendingSelection:(BOOL)extendSel;
- (void)dejal_selectRowIndex:(NSUInteger)rowIndex byExtendingSelection:(BOOL)extendSel;

- (void)dejal_editColumnWithIdentifier:(NSString *)columnIdentfier row:(NSInteger)row;

- (NSEnumerator *)dejal_tableColumnEnumerator;
- (NSTableColumn *)dejal_tableColumnAtIndex:(NSUInteger)i;
- (NSUInteger)dejal_indexOfFirstEditableTableColumn;
- (NSTableColumn *)dejal_firstEditableTableColumn;

- (NSTableColumn *)dejal_addTableColumnWithIdentifier:(NSString *)identifier title:(NSString *)title editable:(BOOL)editable resizable:(BOOL)resizable width:(CGFloat)width;
- (NSTableColumn *)dejal_addTableColumnWithIdentifier:(NSString *)identifier title:(NSString *)title editable:(BOOL)editable resizable:(BOOL)resizable sortable:(BOOL)sortable ascending:(BOOL)ascending width:(CGFloat)width alignment:(NSTextAlignment)alignment;

- (NSTableColumn *)dejal_addTableColumnWithColumnInfo:(NSDictionary *)columnInfo;
- (void)dejal_addTableColumnsWithArrayOfColumnInfo:(NSArray *)columns removeAll:(BOOL)removeAll sizeLast:(BOOL)sizeLast;

- (void)dejal_insertTableColumn:(NSTableColumn *)aColumn atIndex:(NSUInteger)i;

- (void)dejal_removeTableColumns:(NSArray *)columns;

- (void)dejal_registerDefaultSortDescriptorForTableColumnWithIdentifier:(NSString *)identifier ascending:(BOOL)ascending;
- (void)dejal_registerDefaultSortDescriptorForTableColumn:(NSTableColumn *)tableColumn ascending:(BOOL)ascending;

- (void)dejal_setHeaderImageNamed:(NSString *)imageName inTableColumnWithIdentifier:(NSString *)identifier;
- (void)dejal_setDataImageNamed:(NSString *)imageName inTableColumnWithIdentifier:(NSString *)identifier;

- (void)dejal_setHeaderAndDataImageNamed:(NSString *)imageName inTableColumnWithIdentifier:(NSString *)identifier;

- (NSString *)dejal_truncatedString:(NSString *)string withIndicator:(NSString *)indicator forTableColumn:(NSTableColumn *)tableColumn;

- (NSMenu *)menuForEvent:(NSEvent *)event;

- (void)dejal_addKey:(NSString *)key withValue:(NSString *)value toDictionary:(NSMutableDictionary *)dict;
- (void)dejal_removeSelectedKeyFromDictionary:(NSMutableDictionary *)dict;
- (void)dejal_reselectEditWithKey:(NSString *)key forDictionary:(NSMutableDictionary *)dict;

- (CGFloat)dejal_contentHeight;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSTableView (DejalCutCopyPasteDelete)

- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)delete:(id)sender;

- (BOOL)dejal_savePlainTextToURL:(NSURL *)url;
- (BOOL)dejal_saveRichTextToURL:(NSURL *)url;

- (BOOL)validateMenuItem:(NSMenuItem *)item;

- (NSIndexSet *)dejal_shouldCutRowIndexes;
- (NSIndexSet *)dejal_shouldCopyRowIndexes;
- (NSInteger)dejal_shouldPasteBeforeRow;
- (NSIndexSet *)dejal_shouldDeleteRowIndexes;
- (NSIndexSet *)dejal_shouldSaveRowIndexes;

- (NSString *)dejal_stringValueForRow:(NSUInteger)row;

- (BOOL)dejal_deleteRowIndexes:(NSIndexSet *)indexes;

@end

