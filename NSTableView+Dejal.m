//
//  NSTableView+Dejal.m
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

#import "NSTableView+Dejal.h"
#import "NSAttributedString+AppKit+Dejal.h"
#import "NSString+AppKit+Dejal.h"
#import "NSImage+Dejal.h"
#import "NSWindow+Dejal.h"
#import "NSDictionary+Dejal.h"


@interface NSObject (DejalTableViewCutCopyPasteDeleteDelegate)

- (NSIndexSet *)tableView:(NSTableView *)tableView shouldCutRowIndexes:(NSIndexSet *)indexes;
- (NSIndexSet *)tableView:(NSTableView *)tableView shouldCopyRowIndexes:(NSIndexSet *)indexes;
- (NSInteger)tableView:(NSTableView *)tableView shouldPasteBeforeRow:(NSInteger)row;

- (NSString *)tableView:(NSTableView *)tableView stringValueForRow:(NSInteger)row;

@end


@interface NSObject (DejalTableViewDragDelegate)

- (NSImage *)tableView:(NSTableView *)tableView dragImageForRowsWithIndexes:(NSIndexSet *)dragRows tableColumns:(NSArray *)tableColumns event:(NSEvent *)dragEvent offset:(NSPointPointer)dragImageOffset;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSTableView (Dejal)

/**
 Use this instead of -delegate with the protocol methods defined in this category.
 
 @author DJS 2011-06.
*/

- (id <DejalTableViewDelegate>)dejal_delegate;
{
    return (id <DejalTableViewDelegate>)[self delegate];
}

/**
 Deselects all lines in the table.
*/

- (IBAction)selectNone:(id)sender
{
    [self deselectAll:sender];
}

/**
 Returns an index set including all rows.
 
 @author DJS 2010-05.
*/

- (NSIndexSet *)dejal_allRowIndexes;
{
    if ([self numberOfRows])
	    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfRows] - 1)];
    else
        return [NSIndexSet indexSet];
}

/**
 Returns an index set that either includes just the selected rows, if there are some selected, or all rows, if none are selected.
 
 @author DJS 2010-05.
*/

- (NSIndexSet *)dejal_selectedOrAllRowIndexes;
{
    if ([self numberOfRows] == 0 || [self numberOfSelectedRows] > 0)
        return self.selectedRowIndexes;
    else
        return self.dejal_allRowIndexes;
}

/**
 Returns an index set that either includes just the selected rows, if there are more than one selected, or all rows, if none or one are selected.
 
 @author DJS 2010-05.
*/

- (NSIndexSet *)dejal_multipleSelectedOrAllRowIndexes;
{
    if ([self numberOfRows] == 0 || [self numberOfSelectedRows] > 1)
        return self.selectedRowIndexes;
    else
        return self.dejal_allRowIndexes;
}

/**
 Returns an enumerator of row numbers for all table rows.
 
 @author DJS 2004-05.
*/

- (NSEnumerator *)dejal_rowEnumerator
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self numberOfRows]];
    NSInteger row;
    
    for (row = 0; row < [self numberOfRows]; row++)
        [array addObject:@(row)];
    
    return [array objectEnumerator];
}

/**
 Returns an enumerator of row numbers for selected table rows.  Replacement for the deprecated -selectedRowEnumerator method.
 
 @author DJS 2009-09.
*/

- (NSEnumerator *)dejal_selectedRowsEnumerator;
{
    NSIndexSet *selectedRows = self.selectedRowIndexes;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[selectedRows count]];
    NSInteger row;
    
    for (row = 0; row < [self numberOfRows]; row++)
        if ([selectedRows containsIndex:row])
            [array addObject:@(row)];
    
    return [array objectEnumerator];
}

/**
 Returns an enumerator that either includes just the selected rows, if there are some selected, or all rows, if none are selected.
 
 @author DJS 2002-08.
*/

- (NSEnumerator *)dejal_selectedOrAllRowsEnumerator
{
    if ([self numberOfRows] == 0 || [self numberOfSelectedRows] > 0)
        return [self dejal_selectedRowsEnumerator];
    else
        return [self dejal_rowEnumerator];
}

/**
 Returns an enumerator that either includes just the selected rows, if there are more than one selected, or all rows if none or one are selected.
 
 @author DJS 2004-05.
*/

- (NSEnumerator *)dejal_multipleSelectedOrAllRowsEnumerator
{
    if ([self numberOfRows] == 0 || [self numberOfSelectedRows] > 1)
        return [self dejal_selectedRowsEnumerator];
    else
        return [self dejal_rowEnumerator];
}

/**
 Selects the first row, either as well as any existing selection, or instead.
 
 @author DJS 2007-04.
*/

- (void)dejal_selectFirstRowExtendingSelection:(BOOL)extendSel;
{
    if ([self numberOfRows] > 0)
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:extendSel];
}

/**
 Selects the last row, either as well as any existing selection, or instead.
 
 @author DJS 2007-04.
*/

- (void)dejal_selectLastRowExtendingSelection:(BOOL)extendSel;
{
    if ([self numberOfRows] > 0)
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:[self numberOfRows] - 1] byExtendingSelection:extendSel];
}

/**
 Selects the specified row, either as well as any existing selection, or instead.  Replacement for the deprecated -selectRow:extendingSelection: method.
 
 @author DJS 2010-05.
*/

- (void)dejal_selectRowIndex:(NSUInteger)rowIndex byExtendingSelection:(BOOL)extendSel;
{
    if ([self numberOfRows] > (NSInteger)rowIndex)
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:extendSel];
}

/**
 Edits the cell with the column identifier and row, selecting the row first if necessary.  A slightly more convenient version of -editColumn:row:withEvent:select:.  Does nothing if the row is out of range or the column couldn't be found.
 
 @author DJS 2007-04.
*/

- (void)dejal_editColumnWithIdentifier:(NSString *)columnIdentfier row:(NSInteger)row;
{
    NSInteger column = [self columnWithIdentifier:columnIdentfier];
    
    if (row < 0 || row >= [self numberOfRows] || column < 0)
        return;
    
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    [self editColumn:column row:row withEvent:nil select:YES];
}

/**
 Returns an enumerator of all of the columns in the table.
 
 @author DJS 2004-02.
*/

- (NSEnumerator *)dejal_tableColumnEnumerator
{
    return [[self tableColumns] objectEnumerator];
}

/**
 Returns the indexth table column.
 
 @author DJS 2006-10.
*/

- (NSTableColumn *)dejal_tableColumnAtIndex:(NSUInteger)i;
{
    return [self tableColumns][i];
}

/**
 Returns the index of the first editable column in the table, or NSNotFound if there are none.
 
 @author DJS 2006-10.
*/

- (NSUInteger)dejal_indexOfFirstEditableTableColumn;
{
    NSUInteger i = 0;
    NSUInteger count = [self numberOfColumns];
    
    while (i < count && ![[self dejal_tableColumnAtIndex:i] isEditable])
        i++;
    
    return i < count ? i : NSNotFound;
}

/**
 Returns the first editable column in the table, or nil if there are none.
 
 @author DJS 2006-10.
*/

- (NSTableColumn *)dejal_firstEditableTableColumn;
{
    NSUInteger i = [self dejal_indexOfFirstEditableTableColumn];
    
    return i != NSNotFound ? [self dejal_tableColumnAtIndex:i] : nil;
}

/**
 Creates a new text column with the specified attributes, and adds it to the receiver.  The new column is returned, in case you want to change any other attributes.
 
 @author DJS 2004-02.
*/

- (NSTableColumn *)dejal_addTableColumnWithIdentifier:(NSString *)identifier title:(NSString *)title editable:(BOOL)editable resizable:(BOOL)resizable width:(CGFloat)width
{
    return [self dejal_addTableColumnWithIdentifier:identifier title:title editable:editable resizable:resizable sortable:NO ascending:YES width:width alignment:NSTextAlignmentNatural];
}

/**
 Creates a new text column with the specified attributes, and adds it to the receiver.  The new column is returned, in case you want to change any other attributes.
 
 @author DJS 2004-05.
 @version DJS 2006-06: changed to use -setResizingMask: if available (10.4 or later).
 @version DJS 2010-05: changed to always use -setResizingMask:.
*/

- (NSTableColumn *)dejal_addTableColumnWithIdentifier:(NSString *)identifier title:(NSString *)title editable:(BOOL)editable resizable:(BOOL)resizable sortable:(BOOL)sortable ascending:(BOOL)ascending width:(CGFloat)width alignment:(NSTextAlignment)alignment
{
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:identifier];
    
    [[tableColumn headerCell] setStringValue:title];
    [[tableColumn headerCell] setAlignment:alignment];
    
    [[tableColumn dataCell] setFont:[[tableColumn headerCell] font]];
    [[tableColumn dataCell] setAlignment:alignment];
    
    [tableColumn setEditable:editable];
    [tableColumn setResizingMask:resizable ? NSTableColumnUserResizingMask : NSTableColumnNoResizing];
    
    [tableColumn setMinWidth:width < 50.0 ? width : 50.0];
    [tableColumn setMaxWidth:3000.0];
    [tableColumn setWidth:width];
    
    if (sortable && [tableColumn respondsToSelector:@selector(setSortDescriptorPrototype:)])
    {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:identifier ascending:ascending];
        
        [tableColumn setSortDescriptorPrototype:descriptor];
    }
    
    [self addTableColumn:tableColumn];
    
    return tableColumn;
}

/**
 Creates a new text column with the attributes specified in a dictionary with "Identifier", "Name", "Width", and "Editable" keys.  If the "Ascending" key is present, the column is sortable.
 
 @author DJS 2004-05.
*/

- (NSTableColumn *)dejal_addTableColumnWithColumnInfo:(NSDictionary *)columnInfo
{
    NSString *identifier = columnInfo[@"Identifier"];
    NSString *title = columnInfo[@"Name"];
    NSNumber *ascendingNum = columnInfo[@"Ascending"];
    CGFloat width = [columnInfo[@"Width"] floatValue];
    NSTextAlignment alignment = [columnInfo[@"Alignment"] integerValue];
    BOOL isEditable = [columnInfo[@"Editable"] boolValue];
    BOOL isResizable = width != 16.0;
    BOOL isSortable = ascendingNum != nil;
    BOOL isAscending = [ascendingNum boolValue];
    
    if (width < 12.0)
        width = 100.0;
    
    return [self dejal_addTableColumnWithIdentifier:identifier title:title editable:isEditable resizable:isResizable sortable:isSortable ascending:isAscending width:width alignment:alignment];
}

/**
 Creates new text columns as described in an array of dictionaries as for -addTableColumnsWithArrayOfColumnInfo:, above.  If removeAll is YES, any existing columns are first removed.  If sizeLast is YES, the last column is resized to fit.
 
 @author DJS 2004-05.
*/

- (void)dejal_addTableColumnsWithArrayOfColumnInfo:(NSArray *)columns removeAll:(BOOL)removeAll sizeLast:(BOOL)sizeLast
{
    if (removeAll)
        [self dejal_removeTableColumns:[self tableColumns]];
    
    NSDictionary *columnInfo = nil;
    
    for (columnInfo in columns)
    {
        [self dejal_addTableColumnWithColumnInfo:columnInfo];
    }
    
    if (sizeLast)
        [self sizeLastColumnToFit];
}

/**
 Similar to -addTableColumn:, this adds the specified table column at the indicated index.  The column is retained by the receiver.
 
 @author DJS 2005-10.
*/

- (void)dejal_insertTableColumn:(NSTableColumn *)aColumn atIndex:(NSUInteger)i;
{
    [self addTableColumn:aColumn];
    
    NSUInteger lastIndex = [self numberOfColumns] - 1;
    
    // Only bother to move if not already in the right place (new columns are added at the end):
    if (i < lastIndex)
        [self moveColumn:lastIndex toColumn:i];
}

/**
 Given an array of NSTableColumns (as returned by -tableColumns), removes them from the receiver.
 
 @author DJS 2004-02.
*/

- (void)dejal_removeTableColumns:(NSArray *)columns
{
    // Since this would alter the columns, make a copy of the array in case it is really the actual array of columns:
    NSEnumerator *enumerator = [[columns copy] objectEnumerator];
    NSTableColumn *tableColumn;
    
    while ((tableColumn = [enumerator nextObject]))
    {
    	[self removeTableColumn:tableColumn];
    }
}

/**
 If the table doesn't already have sort descriptors, this will set the column with the specified identifier to be the currently sorted one, in ascending or descending order.  If there is no table column with that identifier (or it is nil), the first table column is used, if there is one.
 
 @author DJS 2004-05.
*/

- (void)dejal_registerDefaultSortDescriptorForTableColumnWithIdentifier:(NSString *)identifier ascending:(BOOL)ascending
{
    NSTableColumn *tableColumn = [self tableColumnWithIdentifier:identifier];
    
    [self dejal_registerDefaultSortDescriptorForTableColumn:tableColumn ascending:ascending];
}

/**
 If the table doesn't already have sort descriptors, this will set the specified column to be the currently sorted one, in ascending or descending order.  If the table column is nil, the first table column is used, if there is one.
 
 @author DJS 2004-05.
*/

- (void)dejal_registerDefaultSortDescriptorForTableColumn:(NSTableColumn *)tableColumn ascending:(BOOL)ascending
{
    if ([self respondsToSelector:@selector(sortDescriptors)] && ![[self sortDescriptors] count])
    {
        if (!tableColumn)
        {
            NSArray *columns = [self tableColumns];
            
            if ([columns count])
                tableColumn = columns[0];
        }
        
        if (tableColumn)
        {
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:[tableColumn identifier] ascending:ascending];
            
            [self setSortDescriptors:@[descriptor]];
        }
    }
}

- (void)dejal_setHeaderImageNamed:(NSString *)imageName inTableColumnWithIdentifier:(NSString *)identifier
{
    NSTableColumn *column = [self tableColumnWithIdentifier:identifier];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"tiff"];
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:url options:0 error:nil];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithFileWrapper:fileWrapper];
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attachment];

    [[column headerCell] setAttributedStringValue:string];
}

- (void)dejal_setDataImageNamed:(NSString *)imageName inTableColumnWithIdentifier:(NSString *)identifier
{
    NSTableColumn *column = [self tableColumnWithIdentifier:identifier];
    NSImage *image = [NSImage imageNamed:imageName];
    NSImageCell *cell = [[NSImageCell alloc] initImageCell:image];
    [column setDataCell:cell];
}

- (void)dejal_setHeaderAndDataImageNamed:(NSString *)imageName inTableColumnWithIdentifier:(NSString *)identifier
{
    [self dejal_setHeaderImageNamed:imageName inTableColumnWithIdentifier:identifier];
    [self dejal_setDataImageNamed:imageName inTableColumnWithIdentifier:identifier];
}

/**
 Returns the specified string either intact, or truncated with the indicator string added if the original string is too long to fit in the table column.  The indicator string would typically be an ellipsis (...).  This method is ideal to call in your -tableView:objectValueForTableColumn:row: data source method.
 
 @author DJS 2004-01.
*/

- (NSString *)dejal_truncatedString:(NSString *)string withIndicator:(NSString *)indicator forTableColumn:(NSTableColumn *)tableColumn
{ 
    NSCell *cell = [tableColumn dataCell];
    NSInteger desiredWidth = [cell titleRectForBounds:NSMakeRect(0, 0, [tableColumn width] - 50, [self rowHeight])].size.width;
    
    return [string dejal_truncatedStringWithIndicator:indicator forFont:[cell font] withWidth:desiredWidth];
}

/**
 Override of a NSView method, to allow a contextual menu for an individual row and column.  You should implement -tableView:menuForTableColumn:row: in your table delegate.  If that isn't implemented, this returns the default menu.
 
 @author DJS 2004-06.
*/

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger column = [self columnAtPoint:point];
    NSInteger row = [self rowAtPoint:point];
    
    if (column >= 0 && row >= 0 && [[self dejal_delegate] respondsToSelector:@selector(tableView:menuForTableColumn:row:)])
        return [[self dejal_delegate] tableView:self menuForTableColumn:[self tableColumns][column] row:row];
    else
        return [super menuForEvent:event];
}

/**
 If the data source for the receiver is a dictionary, displayed via "Key" and "Value" columns, this method will add a new key to that dictionary, usually called from the "+" button's action method.  Digits are appended to the key to make it unique, if necessary.  Note that this could and should be done instead with bindings.  Remove this method once existing uses have been upgraded.
 
 @author DJS 2006-10.
 @version DJS 2015-01: Changed to avoid an analyzer warning.
*/

- (void)dejal_addKey:(NSString *)key withValue:(NSString *)value toDictionary:(NSMutableDictionary *)dict;
{
    [self reloadData];
    
    NSString *composedKey = key;
    NSInteger extra = 2;
    
    if (![key length] || dict[key])
        while ((composedKey = [NSString stringWithFormat:@"%@%ld", key, extra]) && dict[composedKey])
            extra++;
    
    if (composedKey.length)
    {
        dict[composedKey] = value;
    }
    
    [self reloadData];
    
    NSInteger row = [[dict dejal_sortedKeys] indexOfObject:composedKey];
    NSInteger column = [self dejal_indexOfFirstEditableTableColumn];
    
    [self dejal_selectRowIndex:row byExtendingSelection:NO];
    
    if (column >= 0)
        [self editColumn:column row:row withEvent:nil select:YES];
}

/**
 If the data source for the receiver is a dictionary, displayed via "Key" and "Value" columns, this method will remove the key of the selected row from that dictionary, usually called from the "-" button's action method.  Only supports deleting a single row, so multiple selection shouldn't be enabled.  Note that this could and should be done instead with bindings.  Remove this method once existing uses have been upgraded.
 
 @author DJS 2006-10.
 @version DJS 2015-12: Changed to avoid a crash if called with no selected row.
*/

- (void)dejal_removeSelectedKeyFromDictionary:(NSMutableDictionary *)dict;
{
    [[self window] dejal_forceEndEditingForView:self];
    
    NSInteger row = [self selectedRow];
    
    if (row == -1)
    {
        return;
    }
    
    NSString *key = [dict dejal_sortedKeys][row];
    
    if (!dict)
    {
        return;
    }
    
    [dict removeObjectForKey:key];
    
    [self reloadData];
}

/**
 Adjusts the current edit after editing the key.
 
 @author DJS 2014-12.
 */

- (void)dejal_reselectEditWithKey:(NSString *)key forDictionary:(NSDictionary *)dict;
{
    [self dejal_reselectEditWithKey:key forDictionary:dict column:-1];
}

/**
 Adjusts the current edit after editing the key.
 
 @param key A dictionary key.
 @param dict A dictionary that contains that key.
 @param column The column with the field for that key.
 
 @author DJS 2014-12.
 @version DJS 2015-06: Changed to wait a moment, to avoid conflicting with a tab event, and add a column parameter.
 @version DJS 2015-08: Changed to check for an invalid row.
 */

- (void)dejal_reselectEditWithKey:(NSString *)key forDictionary:(NSDictionary *)dict column:(NSInteger)column;
{
    dispatch_time_t doTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    
    dispatch_after(doTime, dispatch_get_main_queue(), ^
                   {
                       [self reloadData];
                       
                       NSInteger row = [[dict dejal_sortedKeys] indexOfObject:key];
                       NSInteger editColumn = self.editedColumn + 1;
                       
                       if (row != NSNotFound)
                       {
                           if (column >= 0)
                           {
                               editColumn = column + 1;
                           }
                           else if (editColumn < 0)
                           {
                               editColumn = [self dejal_indexOfFirstEditableTableColumn];
                           }
                           
                           [self dejal_selectRowIndex:row byExtendingSelection:NO];
                           
                           if (editColumn >= 0)
                           {
                               [self editColumn:editColumn row:row withEvent:nil select:YES];
                           }
                       }
                   });
}

/**
 Returns the current height of all rows in a view-based table view.  Doesn't currently support cell based table views.
 
 @author DJS 2013-02.
*/

- (CGFloat)dejal_contentHeight;
{
    CGFloat height = 0.0;
    
    for (NSInteger row = 0; row < [self numberOfRows]; row++)
    {
        NSView *view = [self viewAtColumn:0 row:row makeIfNecessary:YES];
        
        height += view.frame.size.height + self.intercellSpacing.height;
    }
    
    return height;
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSTableView (DejalTableViewCutCopyPasteDeleteDelegate)

- (NSString *)dejal_stringForIndexes:(NSIndexSet *)indexes;
{
    NSMutableString *output = [NSMutableString string];
    
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         NSString *value = [self dejal_stringValueForRow:idx];
         
         if (value.length)
         {
             [output appendString:value];
             [output appendString:@"\n"];
         }
     }];
    
    return output;
}

- (BOOL)dejal_doCopyIndexes:(NSIndexSet *)indexes;
{
    // Convert the constructed output attributed string to RTFD and a plain string:
    NSPasteboard *pboard = [NSPasteboard generalPasteboard];
    NSString *plainString = [self dejal_stringForIndexes:indexes];
    
    // Declare types:
    [pboard declareTypes:@[NSPasteboardTypeString] owner:self];
    
    // Copy values to pasteboard:
    [pboard setString:plainString forType:NSPasteboardTypeString];
    
    return YES;
}

- (IBAction)cut:(id)sender
{
    NSIndexSet *indexes = [self dejal_shouldCutRowIndexes];
    
    if (!indexes)
        return;
    
    // Only Delete if the Copy was successful:
    if ([self dejal_doCopyIndexes:indexes])
        [self dejal_deleteRowIndexes:indexes];
}

- (IBAction)copy:(id)sender
{
    NSIndexSet *indexes = [self dejal_shouldCopyRowIndexes];
    
    if (!indexes)
        return;
    
    [self dejal_doCopyIndexes:indexes];
}

- (IBAction)paste:(id)sender
{
    NSInteger row = [self dejal_shouldPasteBeforeRow];
    
    if (row < 0)
        return;
    
    NSLog(@"The -paste: method for table views is not implemented yet!");		//  log
}

- (IBAction)delete:(id)sender
{
    NSIndexSet *indexes = self.selectedRowIndexes;
    
    if ([self dejal_canDeleteRowIndexes:indexes])
    {
        [self dejal_deleteRowIndexes:indexes];
    }
}

- (BOOL)dejal_savePlainTextToURL:(NSURL *)url;
{
    NSIndexSet *indexes = [self dejal_shouldSaveRowIndexes];
    
    if (!indexes)
        return NO;
    
    NSString *plainString = [self dejal_stringForIndexes:indexes];
    
    return [plainString writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}

- (BOOL)dejal_saveRichTextToURL:(NSURL *)url;
{
    NSIndexSet *indexes = [self dejal_shouldSaveRowIndexes];
    
    if (!indexes)
        return NO;
    
    NSLog(@"-saveRichTextToURL: does not work yet!");         // log
    
    return NO;
}

- (BOOL)validateMenuItem:(NSMenuItem *)item;
{
    SEL action = [item action];
    
    if (action == @selector(cut:))
        return ([self dejal_shouldCutRowIndexes] != nil);
    else if (action == @selector(copy:))
        return ([self dejal_shouldCopyRowIndexes] != nil);
    else if (action == @selector(paste:))
        return ([self dejal_shouldPasteBeforeRow] >= 0);
    else if (action == @selector(delete:))
        return ([self dejal_canDeleteRowIndexes:self.selectedRowIndexes]);
    else
        return YES;
}

/**
 Override of the key press method to detect and handle the Delete key, if appropriate.
 
 @author DJS 2015-07.
 @version DJS 2015-09: Changed to avoid calling super for the Delete key (since it causes a beep).
 */

- (void)keyDown:(NSEvent *)theEvent;
{
    if (theEvent.keyCode == 51)
    {
        [self delete:nil];
    }
    else
    {
        [super keyDown:theEvent];
    }
}

/**
 If the delegate responds to -tableView:shouldCutRowIndexes:, it is invoked with the selected row indexes as a parameter.  The delegate should either return it intact if those rows are cuttable, or modify it (by making a mutable copy) to remove some rows, or return nil if Cut should not be allowed.  If there is no selection, nil is returned without asking the delegate.  You shouldn't need to call this method.
 
 @author DJS 2004-12.
*/

- (NSIndexSet *)dejal_shouldCutRowIndexes
{
    NSIndexSet *indexes = self.selectedRowIndexes;
    
    if ([indexes count] && [[self dejal_delegate] respondsToSelector:@selector(tableView:shouldCutRowIndexes:)])
        return [[self dejal_delegate] tableView:self shouldCutRowIndexes:indexes];
    else
        return nil;
}

/**
 If the delegate responds to -tableView:shouldCopyRowIndexes:, it is invoked with the selected row indexes as a parameter.  The delegate should either return it intact if those rows are copyable, or modify it (by making a mutable copy) to remove some rows, or return nil if Copy should not be allowed.  If there is no selection, nil is returned without asking the delegate.
 
 @author DJS 2004-12.
*/

- (NSIndexSet *)dejal_shouldCopyRowIndexes
{
    NSIndexSet *indexes = self.selectedRowIndexes;
    
    if ([indexes count] && [[self dejal_delegate] respondsToSelector:@selector(tableView:shouldCopyRowIndexes:)])
        return [[self dejal_delegate] tableView:self shouldCopyRowIndexes:indexes];
    else
        return nil;
}

/**
 If the delegate responds to -tableView:shouldPasteBeforeRow:, it is invoked with the first selected row as a parameter (or 0 if there is no selection, so it will paste before the first row).  The delegate should either return it intact if pasting before that row is acceptable, or return a different row, or return -1 if Paste should not be allowed.
 
 @author DJS 2004-12.
*/

- (NSInteger)dejal_shouldPasteBeforeRow
{
    NSInteger row = [self selectedRow];
    
    if (row < 0)
        row = 0;
    
    if ([[self dejal_delegate] respondsToSelector:@selector(tableView:shouldPasteBeforeRow:)])
        return [[self dejal_delegate] tableView:self shouldPasteBeforeRow:row];
    else
        return -1;
}

/**
 If the delegate responds to -tableView:canDeleteRowIndexes:, it is invoked with the selected row indexes as a parameter.  The delegate should return YES if all of those rows are deletable, or NO if Delete should not be allowed.  If there is no selection, NO is returned without asking the delegate.
 
 @author DJS 2004-12.
 @version DJS 2015-07: Changed from returning an index set to a boolean, and take indexes.
*/

- (BOOL)dejal_canDeleteRowIndexes:(NSIndexSet *)indexes;
{
    if ([indexes count] && [[self dejal_delegate] respondsToSelector:@selector(tableView:canDeleteRowIndexes:)])
    {
        return [[self dejal_delegate] tableView:self canDeleteRowIndexes:indexes];
    }
    else
    {
        return NO;
    }
}

/**
 If the delegate responds to -tableView:deleteRowIndexes:, it is invoked with the specified row indexes as a parameter.  The delegate should then delete those rows from its data source, optionally displaying a confirmation first if desired.  It should return YES if it handled the deletion (even if cancelled or deferred).
 
 @author DJS 2007-11.
*/

- (BOOL)dejal_deleteRowIndexes:(NSIndexSet *)indexes;
{
    if ([indexes count] && [[self dejal_delegate] respondsToSelector:@selector(tableView:deleteRowIndexes:)])
        return [[self dejal_delegate] tableView:self deleteRowIndexes:indexes];
    else
        return NO;
}

/**
 If the delegate responds to -tableView:shouldSaveRowIndexes:, it is invoked with the selected row indexes as a parameter, or all rows if none or only one are selected (N.B.: this is different than the pasteboard-related method, above).  The delegate should either return it intact if those rows are saveable, or modify it (by making a mutable copy) to remove some rows, or return nil if saving should not be allowed.  If there are no rows, nil is returned without asking the delegate.
 
 @author DJS 2010-05.
*/

- (NSIndexSet *)dejal_shouldSaveRowIndexes;
{
    NSIndexSet *indexes = [self dejal_multipleSelectedOrAllRowIndexes];
    
    if ([indexes count] && [[self dejal_delegate] respondsToSelector:@selector(tableView:shouldSaveRowIndexes:)])
        return [[self dejal_delegate] tableView:self shouldSaveRowIndexes:indexes];
    else
        return nil;
}

/**
 If the delegate responds to -tableView:stringValueForRow:, it is invoked with the specified row.  The delegate should return a string representation of the specified row.
 
 @author DJS 2014-11.
 */

- (NSString *)dejal_stringValueForRow:(NSUInteger)row;
{
    if ([[self dejal_delegate] respondsToSelector:@selector(tableView:stringValueForRow:)])
        return [[self dejal_delegate] tableView:self stringValueForRow:row];
    else
        return nil;
}

@end

