//
//  AppDelegate.m
//  CA动画
//
//  Created by 1 on 2017/7/31.
//  Copyright © 2017年 深圳市全日康健康产业股份有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController_01.h"
#import "CALayerText.h"
#import "LayerBasic.h"
#import "ViewController.h"
@interface AppDelegate ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UITabBarController *tabbarVC;
@end

@implementation AppDelegate
- (UITabBarController *)tabbarVC{
    if (!_tabbarVC) {
        _tabbarVC = [[UITabBarController alloc]init];
    }
    return _tabbarVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *v0 = [[ViewController alloc]init];
    UIViewController *v1 = [[ViewController_01 alloc]init];
    UIViewController *v2 = [[CALayerText alloc]init];
    UIViewController *v3 = [LayerBasic new];
    v0.title = @"简单动画";
    v0.view.backgroundColor = [UIColor whiteColor];
    v1.title = @"复杂动画";
    v1.view.backgroundColor = [UIColor whiteColor];
    v2.title = @"专属图层";
    v2.view.backgroundColor = [UIColor whiteColor];
    v3.title = @"图层基础";
    v3.view.backgroundColor = [UIColor whiteColor];
    [self.tabbarVC addChildViewController:v0];
    [self.tabbarVC addChildViewController:v3];
    [self.tabbarVC addChildViewController:v2];
    [self.tabbarVC addChildViewController:v1];
    self.tabbarVC.delegate = self;
    self.window.rootViewController = self.tabbarVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    [self.tabbarVC.view.layer addAnimation:transition forKey:nil];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
