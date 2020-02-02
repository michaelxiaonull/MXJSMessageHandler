//
//  ViewController.m
//  MXJSMessageHandler
//
//  Created by Michael on 2020/2/2.
//  Copyright © 2020 Michael. All rights reserved.
//

#import "ViewController.h"
#import "MXJSMessageHandler.h"

@interface ViewController () {
    WKWebView *_webView;
    WKWebViewConfiguration *_config;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.config];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test.html" ofType:nil]]]];
    NSString *jsMethodName = @"callNativeMethod", *nativeMethodName = @"test";
    // 1. 注入`js`方法`callNativeMethod（内部再调用原生的方法`test`）`
    NSString *jsScript = [NSString stringWithFormat:@"\
    function %@(data) {\
         window.webkit.messageHandlers.%@.postMessage(data)\
    }", jsMethodName, nativeMethodName];
    [_webView mx_addUserScript:[[WKUserScript alloc] initWithSource:jsScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    // 2. 原生调用js方法`callNativeMethodAfter1Sec`，延时1S是保证让`js方法调用成功（不为undefine）`
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_webView evaluateJavaScript:[NSString stringWithFormat:@"%@(\"%@\")", jsMethodName, @"data: js to oc"] completionHandler:^(id data, NSError *error) {
        }];
    });
    // 3. 监听`js`调用原生方法`test`的`block`
    __weak __typeof(self) weakself = self;
    [_webView mx_addScriptMessageHandler:[MXJSMessageHandler handlerWithBlock:^(WKUserContentController *userContentController, WKScriptMessage *message) {
        if ([message.body isKindOfClass:[NSString class]]) {
            NSString *data = message.body;
            [weakself showData:data];
        }
    }] name:nativeMethodName];
}

- (void)showData:(NSString *)data {
    data = [NSString stringWithFormat:@"receive data from js\n success, %@", data];
    NSLog(@"%@", data);
    [self.view addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
        label.center = self.view.center;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = data;
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:30.0f];
        label;
    })];
}

#pragma mark - Getter
- (WKWebViewConfiguration *)config {
    if (_config) return _config;
    WKWebViewConfiguration *config = _config;
    if (!config) {
        config = [[WKWebViewConfiguration alloc] init];
        // `userContentController`
        WKUserContentController *userContentController = WKUserContentController.new;
        config.userContentController = userContentController;
    }
    return _config = config;
}

@end
