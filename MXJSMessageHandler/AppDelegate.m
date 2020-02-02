//
//  AppDelegate.m
//  MXJSMessageHandler
//
//  Created by Michael on 2020/2/2.
//  Copyright © 2020 Michael. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = ViewController.new;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
