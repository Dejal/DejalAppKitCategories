//
//  NSOutlineView+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Fri May 30 2003.
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


#import "NSOutlineView+Dejal.h"
#import "NSTableView+Dejal.h"


@implementation NSOutlineView (Dejal)

/**
 Use this instead of -delegate with the protocol methods defined in this category.
 
 @author DJS 2011-06.
*/

- (id <DejalOutlineViewDelegate>)dejal_delegate;
{
    return (id <DejalOutlineViewDelegate>)[self delegate];
}

/**
 Returns the object for the selected row (or the first selected row if multiple).
*/

- (id)dejal_selectedItem
{
    return [self itemAtRow:[self selectedRow]];
}

/**
 Returns an array containing the objects for the selected rows, or for all rows if none are selected and YES is passed.
*/

- (NSArray *)dejal_selectedOrAllItems:(BOOL)allIfNoneSelected
{
    NSMutableArray *items = [NSMutableArray array];
    NSEnumerator *enumerator;
    NSNumber *selRow = nil;

    if (allIfNoneSelected)
        enumerator = [self dejal_selectedOrAllRowsEnumerator];
    else
        enumerator = [self dejal_selectedRowsEnumerator];
    
    while ((selRow = [enumerator nextObject]))
    {
        id item = [self itemAtRow:[selRow integerValue]];
        
        if (item)
            [items addObject:item];
    }

    return items;
}

/**
 Selects the rows for the objects in the array, optionally extending any existing selection.
*/

- (void)dejal_selectItems:(NSArray *)items byExtendingSelection:(BOOL)extendSel;
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet new];
    
    for (id item in items)
    {
        NSInteger row = [self rowForItem:item];

        if (row >= 0)
        {
            [indexes addIndex:row];
        }
    }
    
    [self selectRowIndexes:indexes byExtendingSelection:extendSel];
}

/**
 Override of a NSView method, to allow a contextual menu for an individual row and column.  You should implement -outlineView:menuForTableColumn:byItem: in your outline delegate.  If that isn't implemented, this returns the default menu.
 
 @author DJS 2004-06.
*/

- (NSMenu *)dejal_menuForEvent:(NSEvent *)event
{
    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger column = [self columnAtPoint:point];
    NSInteger row = [self rowAtPoint:point];
    id item = [self itemAtRow:row];
    
    if (column >= 0 && item && [[self delegate] respondsToSelector:@selector(outlineView:menuForTableColumn:byItem:)])
        return [[self dejal_delegate] outlineView:self menuForTableColumn:[self tableColumns][column] byItem:item];
    else
        return [super menuForEvent:event];
}

@end

