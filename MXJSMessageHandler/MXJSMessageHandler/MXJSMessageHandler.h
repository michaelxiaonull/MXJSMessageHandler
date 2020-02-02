//
//  MXJSMessageHandler.h
//  Yunlu
//
//  Created by Michael on 2018/7/30.
//  Copyright © 2018年 DCloud. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface MXJSMessageHandler : NSObject <WKScriptMessageHandler>

+ (instancetype)handlerWithBlock:(void(^)(WKUserContentController *userContentController, WKScriptMessage *message))block;

@end

@interface WKWebView (MXExtensions)

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
- (void)mx_addUserScript:(WKUserScript *)userScript;

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
- (void)mx_addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;

@end
