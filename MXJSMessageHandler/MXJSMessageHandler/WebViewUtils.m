//
//  WebViewUtils.m
//  Yunlu
//
//  Created by Michael on 2018/8/8.
//  Copyright © 2018年 DCloud. All rights reserved.
//

#import "WebViewUtils.h"
#import <objc/message.h>

/*
 #define AVAILABLE_WHEN_IOS_VERSION(SYSTEM_VERSION_FLOAT_VALUE, SYSTEM_VERSION_GT_SHOULD_GO, SYSTEM_VERSION_LT_SHOULD_GO)\
if (@available(iOS SYSTEM_VERSION_FLOAT_VALUE, *)) {\
SYSTEM_VERSION_GT_SHOULD_GO;\
} else {\
SYSTEM_VERSION_LT_SHOULD_GO;\
}

// Add method + swizzle
void MXExchangeMethod(Class c, SEL origSEL, SEL newSEL, IMP impl) {
    Method origMethod = class_getInstanceMethod(c, origSEL);
    class_addMethod(c, newSEL, impl, method_getTypeEncoding(origMethod));
    Method newMethod = class_getInstanceMethod(c, newSEL);
    if (class_addMethod(c, origSEL, impl, method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

static void (*originalIMP)(id self, SEL _cmd, void* arg0, BOOL arg1, BOOL arg2, id arg3, id arg4) = NULL;
void interceptIMP (id self, SEL _cmd, void* arg0, BOOL arg1, BOOL arg2, id arg3, id arg4) {
    originalIMP(self, _cmd, arg0, TRUE, arg2, arg3, arg4);
}

@implementation WebViewUtils

+ (void)wkWebViewShowKeybord {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"WKContentView");
        NSString *originalMethodStr = nil;
        AVAILABLE_WHEN_IOS_VERSION(11.3, originalMethodStr = @"_startAssistingNode:userIsInteracting:blurPreviousNode:changingActivityState:userObject:", originalMethodStr = @"_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:")
        SEL originalSelector = NSSelectorFromString(originalMethodStr);
        SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"new_%@", originalMethodStr]);
        if (![cls instancesRespondToSelector:originalSelector]) return;
        IMP new_IMP = nil;
        if (@available(ios 11.3, *)) {
            new_IMP = imp_implementationWithBlock(^(id _self, void* arg0, BOOL arg1, BOOL arg2, BOOL arg3, id arg4) {
                ((void (*)(id, SEL, void*, BOOL, BOOL, BOOL, id))objc_msgSend)(_self, newSelector, arg0, TRUE, arg2, arg3, arg4);
            });
        } else {
            new_IMP = imp_implementationWithBlock(^(id _self, void* arg0, BOOL arg1, BOOL arg2, id arg3) {
                ((void (*)(id, SEL, void*, BOOL, BOOL, id))objc_msgSend)(_self, newSelector, arg0, TRUE, arg2, arg3);
            });
        }
        MXExchangeMethod(cls, originalSelector, newSelector, new_IMP);
    });
}

@end
*/
