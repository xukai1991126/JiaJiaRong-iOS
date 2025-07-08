#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "MyViewController.h"

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
    
    // 我的
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *myNav = [[UINavigationController alloc] initWithRootViewController:myVC];
    myNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                     image:[UIImage imageNamed:@"2"]
                                             selectedImage:[UIImage imageNamed:@"s-2"]];
    
    // 只设置首页和我的两个tab
    self.viewControllers = @[homeNav, myNav];
}

- (void)setupTabBarAppearance {
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#FF772C"];
    self.tabBar.backgroundColor = [UIColor whiteColor];
}

@end 
