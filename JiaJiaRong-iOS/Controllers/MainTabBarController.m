#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "JJRNewFeaturesViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarControllers];
    [self setupTabBarAppearance];
}

- (void)setupTabBarControllers {
    // 首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" 
                                                       image:[UIImage imageNamed:@"1"] 
                                               selectedImage:[UIImage imageNamed:@"s-1"]];
    
    // 智能服务
    JJRNewFeaturesViewController *servicesVC = [[JJRNewFeaturesViewController alloc] init];
    UINavigationController *servicesNav = [[UINavigationController alloc] initWithRootViewController:servicesVC];
    servicesNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"智能服务"
                                                           image:[UIImage systemImageNamed:@"brain.head.profile"]
                                                   selectedImage:[UIImage systemImageNamed:@"brain.head.profile.fill"]];
    
    // 我的
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *myNav = [[UINavigationController alloc] initWithRootViewController:myVC];
    myNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                     image:[UIImage imageNamed:@"2"]
                                             selectedImage:[UIImage imageNamed:@"s-2"]];
    
    // 设置三个tab：首页、智能服务、我的
    self.viewControllers = @[homeNav, servicesNav, myNav];
}

- (void)setupTabBarAppearance {
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#FF772C"];
    self.tabBar.backgroundColor = [UIColor whiteColor];
}

@end 
