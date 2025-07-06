#import "LaunchViewController.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "JJRUserManager.h"
#import <Masonry/Masonry.h>

@interface LaunchViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *sloganLabel;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"🎯 LaunchViewController - viewDidLoad called");
    [self setupUI];
    [self performSelector:@selector(checkLoginStatus) withObject:nil afterDelay:2.0];
}

- (void)setupUI {
    NSLog(@"🎯 LaunchViewController - setupUI called");
    
    // 设置背景色
    self.view.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    NSLog(@"🎯 Background color set to blue");
    
    // Logo
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage systemImageNamed:@"building.2"];
    self.logoImageView.tintColor = [UIColor whiteColor];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.logoImageView];
    NSLog(@"🎯 Logo image view added");
    
    // 应用名称
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.text = @"家家融";
    self.appNameLabel.font = [UIFont boldSystemFontOfSize:32];
    self.appNameLabel.textColor = [UIColor whiteColor];
    self.appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.appNameLabel];
    NSLog(@"🎯 App name label added");
    
    // 标语
    self.sloganLabel = [[UILabel alloc] init];
    self.sloganLabel.text = @"专业的金融服务平台";
    self.sloganLabel.font = [UIFont systemFontOfSize:16];
    self.sloganLabel.textColor = [UIColor whiteColor];
    self.sloganLabel.textAlignment = NSTextAlignmentCenter;
    self.sloganLabel.alpha = 0.8;
    [self.view addSubview:self.sloganLabel];
    NSLog(@"🎯 Slogan label added");
    
    // 设置约束
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-60);
        make.width.height.mas_equalTo(120);
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(30);
    }];
    
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.appNameLabel.mas_bottom).offset(10);
    }];
    
    NSLog(@"🎯 LaunchViewController - UI setup completed");
}

- (void)checkLoginStatus {
    NSLog(@"🎯 LaunchViewController - checkLoginStatus called");
    
    // 使用用户管理器检查登录状态
    JJRUserManager *userManager = [JJRUserManager sharedManager];
    NSLog(@"🎯 UserManager状态: %@", userManager);
    
    // 直接检查NSUserDefaults中的值
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *storedUserInfo = [defaults objectForKey:@"JJRUserInfo"];
    NSString *storedUserToken = [defaults objectForKey:@"userToken"];
    NSString *storedChannelToken = [defaults objectForKey:@"token"];
    NSString *storedMobile = [defaults objectForKey:@"mobile"];
    
    NSLog(@"🎯 === 缓存状态检查 ===");
    NSLog(@"🎯 NSUserDefaults中的值:");
    NSLog(@"🎯 - JJRUserInfo: %@", storedUserInfo ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - userToken: %@", storedUserToken ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - channelToken: %@", storedChannelToken ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - mobile: %@", storedMobile ?: @"❌ 无数据");
    
    NSLog(@"🎯 UserManager的属性值:");
    NSLog(@"🎯 - userInfo: %@", userManager.userInfo ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - userToken: %@", userManager.userToken ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - channelToken: %@", userManager.token ? @"✅ 有数据" : @"❌ 无数据");
    NSLog(@"🎯 - mobile: %@", userManager.mobile ?: @"❌ 无数据");
    
    BOOL isLoggedIn = userManager.isLoggedIn;
    NSLog(@"🎯 === 最终登录状态: %@ ===", isLoggedIn ? @"✅ 已登录" : @"❌ 未登录");
    
    if (isLoggedIn) {
        // 已登录，跳转到主页面
        NSLog(@"🎯 User is logged in, navigating to main");
        [self navigateToMain];
    } else {
        // 未登录，跳转到登录页面
        NSLog(@"🎯 User is not logged in, navigating to login");
        [self navigateToLogin];
    }
}

- (void)navigateToMain {
    NSLog(@"🎯 LaunchViewController - navigateToMain called");
    MainTabBarController *mainVC = [[MainTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
    
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

- (void)navigateToLogin {
    NSLog(@"🎯 LaunchViewController - navigateToLogin called");
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    // 直接设置根视图控制器，不使用动画
    [UIApplication sharedApplication].keyWindow.rootViewController = navController;
    NSLog(@"🎯 LoginViewController set as root view controller");
}

@end 