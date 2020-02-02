//
//  MXJSMessageHandler.m
//  Yunlu
//
//  Created by Michael on 2018/7/30.
//  Copyright © 2018年 DCloud. All rights reserved.
//

#import "MXJSMessageHandler.h"

@implementation MXJSMessageHandler {
    void (^_handler)(WKUserContentController *userContentController, WKScriptMessage *message);
}

+ (instancetype)handlerWithBlock:(void(^)(WKUserContentController *userContentController, WKScriptMessage *message))block {
    MXJSMessageHandler *messageHandler = MXJSMessageHandler.new;
    messageHandler->_handler = block;
    return messageHandler;
}

#pragma mark -
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    !_handler ?: _handler(userContentController, message);
}

@end


@implementation WKWebView (MXExtensions)

/**
* @code
*   NSString *pauseAllVideosJs = @"\
        function pauseAllVideos() {\
        var allVideos = document.getElementsByTagName('video');\
        for(var i=0, length = allVideos.length; i < length; i++){\
        allVideos[i].pause();\
        }\
        }";
    [userContentController addUserScript:[[WKUserScript alloc] initWithSource:pauseAllVideosJs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
* @endcode
*/
- (void)mx_addUserScript:(WKUserScript *)userScript {
    WKUserContentController *userContentController = self.configuration.userContentController;
    !userScript ?: [userContentController addUserScript:userScript];
}

/**
* @code
*   NSString *pauseAllVideosJs = @"\
        function pauseAllVideos() {\
        var allVideos = document.getElementsByTagName('video');\
        for(var i=0, length = allVideos.length; i < length; i++){\
        allVideos[i].pause();\
        }\
        }";
    [userContentController addScriptMessageHandler:[MXJSMessageHandler handlerWithBlock:^(WKUserContentController *userContentController, WKScriptMessage *message) {
        if ([message.body isKindOfClass:[NSString class]]) {
            NSString *str = message.body;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        }
    }] name:@"PreloadImageArray"];
* @endcode
*/
- (void)mx_addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name {
    WKUserContentController *userContentController = self.configuration.userContentController;
    [userContentController addScriptMessageHandler:scriptMessageHandler name:name];
}

@end
