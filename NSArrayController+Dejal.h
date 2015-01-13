//
//  NSArrayController+Dejal.h
//  Shared categories
//
//  Created by David Sinclair on 2007-11-13.
//  Copyright (c) 2007-2012 Dejal Systems, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//  
//  Redistributions of source code must retain this list of conditions and the following disclaimer.
//  
//  The name of Dejal Systems, LLC may not be used to endorse or promote products derived from this
//  software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//  PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THIS SOFTWARE.
//

#import <Cocoa/Cocoa.h>


@interface NSArrayController (Dejal)

- (void)moveObjectsFromArrangedObjectIndexes:(NSIndexSet *)indexSet toIndex:(NSUInteger)insertIndex;

@end

