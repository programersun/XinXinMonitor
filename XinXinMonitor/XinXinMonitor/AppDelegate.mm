//
//  AppDelegate.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "AppDelegate.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "MainTabBarViewController.h"
#import "LoginViewController.h"
#import "ImageDetailViewController.h"

#define JPushKey @"88ab9b2429bf675c76b3769e"
#define BaiDuKey @"rZzjh5uvuHku5GcmoQrriEjOeYRr4Qu7"

@interface AppDelegate () <UIAlertViewDelegate>
@property (nonatomic, strong) NSDictionary *jpushInfo;
@end

BMKMapManager *_mapManager;
@implementation AppDelegate

- (NSDictionary *)jpushInfo {
    
    if (!_jpushInfo) {
        _jpushInfo = [[NSDictionary alloc] init];
    }
    return _jpushInfo;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; 
    
    //设置缓存策略(最多缓存10M图片)
    [SDImageCache sharedImageCache].maxCacheSize = 1024 * 1024 * 10;
    
    //实时监听网络状态
    [[AFNetworkingTools sharedManager] networkStateChange];
    
    //极光推送
    [self jpush:launchOptions];
    
    //获取用户位置
    [[LocationManager sharedManager] currentLocation];
    
    //启动百度地图
    [self loadBaiDuMap];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    if (dict) {
        [[UserInfoManager sharedManager] resetInfo:dict];
    }
    
    if ([[UserInfoManager sharedManager].userID isEqualToString:@""]) {
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"LoginViewStoryboard" bundle:nil] instantiateInitialViewController];
        if (vc == nil) {
            vc = [[LoginViewController alloc] init];
        }
        self.window.rootViewController = vc;
    } else {
        MainTabBarViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
        if (vc == nil) {
            vc = [[MainTabBarViewController alloc] init];
        }
        self.window.rootViewController = vc;
    }
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    //赶紧清除所有的内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    //赶紧停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [JPUSHService setBadge:0];
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [JPUSHService setBadge:0];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 百度地图
- (void)loadBaiDuMap {
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BaiDuKey
                  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark - 极光推送
- (void)jpush:(NSDictionary *)launchOptions {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        // categories 必须为nil
        [JPUSHService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
         categories:nil];
    }
    
    [self setAlias];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushKey
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [self parsePushDictionary:userInfo application:application];
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self parsePushDictionary:userInfo application:application];
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)setAlias {

    if ([[UserInfoManager sharedManager].userID isEqualToString:@""]) {
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    }else {
        [JPUSHService setAlias:[UserInfoManager sharedManager].userID callbackSelector:nil object:nil];
    }
}

/** 处理推送信息 */
- (void)parsePushDictionary:(NSDictionary*)userInfo
                application:(UIApplication*)application {

    self.jpushInfo = userInfo;
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:alert
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
        [alertView show];
    } else {
        [self pushImageDetailViewController];
    }
}

/**
 *  收到消息推送后跳转详情页面
 */
- (void)pushImageDetailViewController {
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.window.rootViewController;
    for (UINavigationController *nav in tabVC.childViewControllers) {
        [nav popToRootViewControllerAnimated:NO];
    }
    [tabVC setSelectedIndex:2];
    
    if ([[self.jpushInfo objectForKey:@"detail"] isEqualToString:@"yes"]) {
        UINavigationController *navVC = tabVC.childViewControllers[2];
        ImageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
        if (vc == nil) {
            vc = [[ImageDetailViewController alloc] init];
        }
        vc.monitorId = [self.jpushInfo objectForKey:@"monitorId"];
        [vc setHidesBottomBarWhenPushed:YES];
        [navVC pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        [self pushImageDetailViewController];
    }
}

@end
