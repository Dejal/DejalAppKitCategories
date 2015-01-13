//
//  NSScreen+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on 2014-01-12.
//  Copyright (c) 2014-2015 Dejal Systems, LLC. All rights reserved.
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

#import "NSScreen+Dejal.h"


@implementation NSScreen (Dejal)

/**
 Read-only property to return the unique ID of the screen, aka the screen number.  Not the same as the screen list index.
 
 @returns The reciever's unique display ID.
 
 @author DJS 2014-01.
 */

- (NSUInteger)dejal_displayID;
{
    NSDictionary *screenDictionary = [self deviceDescription];
    NSNumber *screenID = [screenDictionary objectForKey:@"NSScreenNumber"];
    
    return [screenID unsignedIntegerValue];
}

/**
 Read-only property to return the localized name of the receiver.
 
 @returns The localized name of the screen, or nil if none is available.
 
 @author DJS 2014-01.
 */

- (NSString *)dejal_screenName;
{
    return [self dejal_screenNameForDisplayID:self.dejal_displayID];
}

/**
 Given a display ID, returns the localized screen name, or nil if none is available.
 
 @param displayID The unique ID of the screen, as returned by the displayID property.
 @returns The localized name of the screen, or nil if none is available.
 
 @author DJS 2014-01.
 */

// IODisplayCreateInfoDictionary() is deprecated as of 10.9; suppress the warning for this method, since there's no alternative:
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (NSString *)dejal_screenNameForDisplayID:(NSUInteger)displayID;
{
    NSDictionary *deviceInfo = (NSDictionary *)CFBridgingRelease(IODisplayCreateInfoDictionary(CGDisplayIOServicePort((CGDirectDisplayID)displayID), kIODisplayOnlyPreferredName));
    NSDictionary *localizedNames = [deviceInfo objectForKey:[NSString stringWithUTF8String:kDisplayProductName]];
    
    return [[localizedNames allValues] firstObject];
}

// Restore deprecation warnings:
#pragma clang diagnostic warning "-Wdeprecated-declarations"

@end

