//
//  NSMethodSignature+ESUI.m
//  iosproject
//
//  Created by hlcisy on 2021/1/6.
//  Copyright © 2021 hlcisy. All rights reserved.
//

#import "NSMethodSignature+ESUI.h"
#import "ESUICore.h"

@implementation NSMethodSignature (ESUI)

+ (NSMethodSignature *)esui_avoidExceptionSignature {
    // https://github.com/facebookarchive/AsyncDisplayKit/pull/1562
    // Unfortunately, in order to get this object to work properly, the use of a method which creates an NSMethodSignature
    // from a C string. -methodSignatureForSelector is called when a compiled definition for the selector cannot be found.
    // This is the place where we have to create our own dud NSMethodSignature. This is necessary because if this method
    // returns nil, a selector not found exception is raised. The string argument to -signatureWithObjCTypes: outlines
    // the return type and arguments to the message. To return a dud NSMethodSignature, pretty much any signature will
    // suffice. Since the -forwardInvocation call will do nothing if the delegate does not respond to the selector,
    // the dud NSMethodSignature simply gets us around the exception.
    return [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

- (NSString *)esui_typeString {
    BeginIgnorePerformSelectorLeaksWarning
    NSString *typeString = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@String", @"type"])];
    EndIgnorePerformSelectorLeaksWarning
    return typeString;
}

- (const char *)esui_typeEncoding {
    return self.esui_typeString.UTF8String;
}
@end
