//
//  NSPopUpButton+Dejal.m
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

#import "NSPopUpButton+Dejal.h"
#import "NSString+Dejal.h"


@implementation NSPopUpButton (Dejal)

/**
 Adds a separator item to the menu.
 
 @author DJS 2006-10.
*/

- (void)dejal_addSeparatorItem;
{
    [[self menu] addItem:[NSMenuItem separatorItem]];
    
    [self synchronizeTitleAndSelectedItem];
}

/**
 Similar to -addItemWithTitle:, but allows specifying a tag.  It does not remove any other items with the same name, however, as -[NSPopUpButton addItemWithTitle:] does.  It also returns the created item.
 
 @author DJS 2004-03.
*/

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString tag:(NSInteger)tag
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:aString action:nil keyEquivalent:@""];
    
    [item setTag:tag];
    
    [[self menu] addItem:item];
    
    [self synchronizeTitleAndSelectedItem];
    
    return item;
}

/**
 Similar to -addItemWithTitle:, but allows specifying a tag and represented object.  It does not remove any other items with the same name, however, as -[NSPopUpButton addItemWithTitle:] does.  It also returns the created item.
 
 @author DJS 2004-03.
*/

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString tag:(NSInteger)tag representedObject:(id)object
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:aString action:nil keyEquivalent:@""];
    
    [item setTag:tag];
    [item setRepresentedObject:object];
    
    [[self menu] addItem:item];
    
    [self synchronizeTitleAndSelectedItem];
    
    return item;
}

/**
 Given an array of file paths, adds items to the receiver.  The item titles are the last path components sans extensions, and the item tags are set as requested.  The item represented objects are set to the abbreviated or full paths, based on the abbreviatedObject value.  If prefixDivider is YES, a divider line is added before the other items, iff there are any.  You can call -pathsWithExtension:atPath:deepScan: (in NSFileManager+Dejal) to get the paths.
 
 @author DJS 2005-05.
 @version DJS 2014-01: changed to support a default path.
*/

- (void)dejal_addItemsWithPaths:(NSArray *)paths
            prefixDivider:(BOOL)prefixDivider
                      tag:(NSInteger)tag
        abbreviatedObject:(BOOL)abbreviatedObject
              defaultPath:(NSString *)defaultPath;
{
    NSString *path;
    
    for (path in paths)
    {
        if (prefixDivider)
        {
            [[self menu] addItem:[NSMenuItem separatorItem]];
            prefixDivider = NO;
        }
        
        NSString *title = [path dejal_lastPathComponentWithoutExtension];
        NSString *object = path;
        
        if (defaultPath && ![object hasPrefix:@"/"])
            object = [defaultPath stringByAppendingPathComponent:object];
        
        if (abbreviatedObject)
            object = [object dejal_abbreviatedPath];
        
        [self dejal_addItemWithTitle:title tag:tag representedObject:object];
    }
    
    [self synchronizeTitleAndSelectedItem];
}


/**
 Convenience method to return the menu item with the given tag.
 
 @author DJS 2004-03.
*/

- (NSMenuItem *)dejal_itemWithTag:(NSInteger)aTag
{
    NSMenu *menu = [self menu];
    NSMenuItem *item = [menu itemWithTag:aTag];
    
    return item;
}

/**
 Convenience method to return the tag of the selected item, similar to indexOfSelectedItem etc.
 
 @author DJS 2007-07.
 */

- (NSInteger)dejal_tagOfSelectedItem;
{
    return [[self selectedItem] tag];
}

/**
 Convenience method to select the menu item with the given represented object.
 
 @author DJS 2005-05.
*/

- (NSInteger)dejal_selectItemWithRepresentedObject:(id)anObj
{
    NSUInteger i = [self indexOfItemWithRepresentedObject:anObj];
    
    [self selectItemAtIndex:i];
    
    return i;
}

/**
 Convenience method to return the represented object of the selected item, similar to indexOfSelectedItem etc.
 
 @author DJS 2010-07.
*/

- (id)dejal_representedObjectOfSelectedItem;
{
    return [[self selectedItem] representedObject];
}

@end

