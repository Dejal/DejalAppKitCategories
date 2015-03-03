//
//  NSMenu+Dejal.m
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

#import "NSMenu+Dejal.h"


@implementation NSMenu (Dejal)

/**
 Adds a separator item to the menu.
 
 @author DJS 2006-10.
*/

- (void)dejal_addSeparatorItem;
{
    [self addItem:[NSMenuItem separatorItem]];
}

/**
 Similar to -addItemWithTitle:action:keyEquivalent:, but allows specifying a target object as well.  The key equivalent should be @"" if not required, not nil, though nil is also accepted by these categories.
 
 @author DJS 2003-10.
*/

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector
                   keyEquivalent:(NSString *)keyEquiv
{
    return [self dejal_addItemWithTitle:aString target:target action:aSelector keyEquivalent:keyEquiv icon:nil];
}

/**
 Similar to -addItemWithTitle:action:keyEquivalent:, but allows specifying a target object as well.  Instead of a key equivalent, it allows setting the represented object and/or tag.
 
 @author DJS 2008-07.
 @version DJS 2014-10: changed to fix not passing the object.
*/

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector representedObject:(id)object tag:(NSInteger)tag;
{
    return [self dejal_addItemWithTitle:aString target:target action:aSelector keyEquivalent:@"" modifierMask:0 icon:nil representedObject:object tag:tag];
}

/**
 Similar to -addItemWithTitle:target:action:keyEquivalent:, but allows specifying an icon image as well.  The key equivalent should be @"" if not required, not nil, though nil is also accepted by these categories.
 
 @author DJS 2004-01.
*/

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector
                   keyEquivalent:(NSString *)keyEquiv icon:(NSImage *)icon
{
    return [self dejal_addItemWithTitle:aString target:target action:aSelector keyEquivalent:keyEquiv icon:icon representedObject:nil];
}

/**
 Similar to -addItemWithTitle:target:action:keyEquivalent:icon:, but allows specifying a represented object as well.  The key equivalent should be @"" if not required, not nil, though nil is also accepted by these categories.
 
 @author DJS 2004-01.
*/

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector
                   keyEquivalent:(NSString *)keyEquiv icon:(NSImage *)icon representedObject:(id)object
{
    return [self dejal_addItemWithTitle:aString target:target action:aSelector keyEquivalent:keyEquiv modifierMask:0 icon:icon representedObject:object tag:0];
}

/**
 Similar to -addItemWithTitle:target:action:keyEquivalent:icon:, but allows specifying a represented object as well.  The key equivalent should be @"" if not required, not nil, though nil is also accepted by these categories.
 
 @author DJS 2004-04.
*/

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector
                   keyEquivalent:(NSString *)keyEquiv modifierMask:(NSUInteger)modifierMask icon:(NSImage *)icon representedObject:(id)object
{
    return [self dejal_addItemWithTitle:aString target:target action:aSelector keyEquivalent:keyEquiv modifierMask:modifierMask icon:icon representedObject:object tag:0];
}

/**
 Similar to -addItemWithTitle:target:action:keyEquivalent:icon:representedObject:, but allows specifying a modifier mask as well; if zero, the mask is not changed.  The key equivalent should be @"" if not required, not nil, though nil is also accepted by these categories.
 
 @author DJS 2004-01.
 @version DJS 2004-04: changed to add modifierMask.
 @version DJS 2008-07: changed to add tag.
*/

- (NSMenuItem *)dejal_addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector
                   keyEquivalent:(NSString *)keyEquiv modifierMask:(NSUInteger)modifierMask icon:(NSImage *)icon representedObject:(id)object tag:(NSInteger)tag;
{
    if (!keyEquiv)
        keyEquiv = @"";
    
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:aString action:aSelector keyEquivalent:keyEquiv];
    
    if (modifierMask)
        [item setKeyEquivalentModifierMask:modifierMask];
    
    [item setTarget:target];
    [item setImage:icon];
    [item setRepresentedObject:object];
    [item setTag:tag];
    
    [self addItem:item];
    
    return item;
}

/**
 Removes a menu item based on its target and action.  Returns its menu item index, in case adjacent items (e.g. a divider) also need to be deleted.
 
 @author DJS 2010-11.
*/

- (NSInteger)dejal_removeItemWithTarget:(id)target andAction:(SEL)action;
{
    NSInteger itemIndex = [self indexOfItemWithTarget:target andAction:action];
    
    if (itemIndex >= 0)
        [self removeItemAtIndex:itemIndex];
    
    return itemIndex;
}

/**
 Removes all menu items based on a target and action.
 
 @author DJS 2014-11.
 */

- (void)dejal_removeItemsWithTarget:(id)target andAction:(SEL)action;
{
    NSInteger itemIndex = -1;
    
    do
    {
        itemIndex = [self indexOfItemWithTarget:target andAction:action];
        
        if (itemIndex >= 0)
        {
            [self removeItemAtIndex:itemIndex];
        }
    }
    while (itemIndex >= 0);
}

/**
 Returns the index of the first menu item in the receiver that has a specified action and target.
 
 @param target An object that is set as the target of a menu item of the receiver.
 @param action A selector identifying an action method. If actionSelector is NULL, the first menu item in the receiver that has target anObject is returned.
 @returns The menu item or nil if no such menu item is in the menu.
 
 @author DJS 2014-10.
 */

- (NSMenuItem *)dejal_itemWithTarget:(id)target andAction:(SEL)action;
{
    NSInteger idx = [self indexOfItemWithTarget:target andAction:action];
    
    if (idx >= 0)
    {
        return [self itemAtIndex:idx];
    }
    else
    {
        return nil;
    }
}

/**
 Returns the menu item in the receiver with the given target, action and tag values, if any.
 
 @param target An object that is set as the target of a menu item of the receiver.
 @param action A selector identifying an action method.
 @param tag A menu item tag value.
 @returns The found menu item, or nil if none match.
 
 @author DJS 2014-10.
 */

- (NSMenuItem *)dejal_itemWithTarget:(id)target action:(SEL)action tag:(NSInteger)tag;
{
    for (NSMenuItem *menuItem in self.itemArray)
    {
        if (menuItem.target == target && menuItem.action == action && menuItem.tag == tag)
        {
            return menuItem;
        }
    }
    
    return nil;
}

/**
 Toggles the state of all menu items in the receiver with the given target and action, so that only the matching item with the specified tag value is checked, and matching items with other tag values are unchecked.
 
 @param target An object that is set as the target of a menu item of the receiver.
 @param action A selector identifying an action method.
 @param tag A menu item tag value.
 
 @author DJS 2014-10.
 */

- (void)dejal_setCheckedItemForTarget:(id)target andAction:(SEL)action withTag:(NSInteger)tag;
{
    for (NSMenuItem *menuItem in self.itemArray)
    {
        if (menuItem.target == target && menuItem.action == action)
        {
            menuItem.state = menuItem.tag == tag;
        }
    }
}

@end


@implementation NSMenuItem (Dejal)

/**
 Returns a new menu item instance with the given title and other settings.  Perhaps kinda silly, but having to specify an empty (not nil) key equivalent is annoying, but blocks are fun.
 
 @param title The title for the menu item.
 @param block An optional block to set additional properties on the new item.  Pass nil to only set the title.
 @returns A new menu item instance.
 
 @author DJS 2015-02.
 */

+ (instancetype)dejal_menuItemWithTitle:(NSString *)title settings:(void (^)(NSMenuItem *item))block;
{
    NSMenuItem *menuItem = [[self alloc] initWithTitle:title action:nil keyEquivalent:@""];
    
    if (block)
    {
        block(menuItem);
    }
    
    return menuItem;
}

@end

