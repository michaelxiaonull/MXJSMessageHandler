# MXJSMessageHandler
MXJSMessageHandler solves that WKWebView has always retained`(id<WKScriptMessageHandler> scriptMessageHandler`, scriptMessageHandler may be a controller.

解决了WKWebView的`scriptMessageHandler`有时候会是controller本身的问题，导致循环引用，内存泄漏的问题

# Screenshot
![image.png](https://upload-images.jianshu.io/upload_images/2546918-811825f0903b9b81.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/340)

# How to use 

## 原生注入js方法callNativeMethod（内部再调用原生的方法test）


``` objective-c
NSString *jsMethodName = @"callNativeMethod", *nativeMethodName = @"test";
// 1. 注入`js`方法`callNativeMethod（内部再调用原生的方法`test`）`
NSString *jsScript = [NSString stringWithFormat:@"\
function %@(data) {\
       window.webkit.messageHandlers.%@.postMessage(data)\
       }", jsMethodName, nativeMethodName];
[_webView mx_addUserScript:[[WKUserScript alloc] initWithSource:jsScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
 ```

 
## 原生调用js方法callNativeMethod，延时1S是保证让js方法调用成功（不为undefine）

``` objective-c
// 2. 原生调用js方法`callNativeMethod`，延时1S是保证让`js方法调用成功（不为undefine）`
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"%@(\"%@\")", jsMethodName, @"data: js to oc"] completionHandler:^(id data, NSError *error) {}];
});
``` 

## 监听js调用原生方法test的block

``` objective-c
// 3. 监听`js`调用原生方法`test`的`block`
    __weak __typeof(self) weakself = self;
    [_webView mx_addScriptMessageHandler:[MXJSMessageHandler handlerWithBlock:^(WKUserContentController *userContentController, WKScriptMessage *message) {
        if ([message.body isKindOfClass:[NSString class]]) {
            NSString *data = message.body;
            [weakself showData:data];
        }
    }] name:nativeMethodName];
``` 
