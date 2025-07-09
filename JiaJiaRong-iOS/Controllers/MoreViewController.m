//
//  MoreViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/1.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "MoreViewController.h"
#import "JJRUserManager.h"
#import "JJRNetworkService.h"
#import "JJRPasswordModifyViewController.h"
#import "InitPasswordViewController.h"
#import "JJRFeedbackViewController.h"
#import "LoginViewController.h"

@interface MoreViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) JJRUserManager *userManager;
@property (nonatomic, assign) NSUInteger cacheSize;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUserInfo];
    [self calculateCacheSize];
}

- (void)setupData {
    self.userManager = [JJRUserManager sharedManager];
    self.menuItems = [NSMutableArray array];
    self.cacheSize = 0;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"更多";
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 退出登陆按钮
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.logoutButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.logoutButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.logoutButton.layer.cornerRadius = 25;
    [self.logoutButton addTarget:self action:@selector(logoutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutButton];
    
    // 设置约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.logoutButton.mas_top).offset(-15);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(30);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15);
        make.height.mas_equalTo(49);
    }];
}

- (void)loadUserInfo {
    [self.menuItems removeAllObjects];
    
    BOOL isLoggedIn = self.userManager.isLoggedIn;
    
    // 根据userInfo中的initPwd字段来判断密码状态（与uni-app保持一致）
    BOOL hasInitPassword = NO;
    if (self.userManager.userInfo && self.userManager.userInfo[@"initPwd"]) {
        hasInitPassword = [self.userManager.userInfo[@"initPwd"] boolValue];
    }
    
    // 根据密码状态显示对应选项
    if (hasInitPassword) {
        [self.menuItems addObject:@{
            @"title": @"修改密码",
            @"action": @"modifyPassword"
        }];
    } else {
        [self.menuItems addObject:@{
            @"title": @"初始化密码", 
            @"action": @"initPassword"
        }];
    }
    
    // 意见反馈
    [self.menuItems addObject:@{
        @"title": @"意见反馈",
        @"action": @"feedback"
    }];
    
    // 注销账号（仅登录用户可见）
    if (isLoggedIn) {
        [self.menuItems addObject:@{
            @"title": @"注销账号",
            @"action": @"cancelAccount"
        }];
    }
    
    // 清除缓存
    [self.menuItems addObject:@{
        @"title": @"清除缓存",
        @"action": @"clearCache",
        @"subtitle": [self formatCacheSize:self.cacheSize]
    }];
    
    // 根据登录状态显示/隐藏退出登陆按钮
    self.logoutButton.hidden = !isLoggedIn;
    
    [self createMenuItems];
}

- (void)createMenuItems {
    // 清除之前的视图
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *lastView = nil;
    
    for (NSInteger i = 0; i < self.menuItems.count; i++) {
        NSDictionary *item = self.menuItems[i];
        UIView *menuItemView = [self createMenuItemWithTitle:item[@"title"] 
                                                    subtitle:item[@"subtitle"]
                                                      action:item[@"action"]
                                                        tag:i];
        [self.contentView addSubview:menuItemView];
        
        [menuItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).inset(15);
            make.height.mas_equalTo(70);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(self.contentView).offset(15);
            }
        }];
        
        lastView = menuItemView;
    }
    
    // 设置contentView的高度
    if (lastView) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    }
}

- (UIView *)createMenuItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle action:(NSString *)action tag:(NSInteger)tag {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button addTarget:self action:@selector(menuItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:button];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    [containerView addSubview:titleLabel];
    
    // 右箭头
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
    arrowImageView.tintColor = [UIColor lightGrayColor];
    [containerView addSubview:arrowImageView];
    
    // 副标题（如缓存大小）
    UILabel *subtitleLabel = nil;
    if (subtitle) {
        subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.text = subtitle;
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
        [containerView addSubview:subtitleLabel];
    }
    
    // 底部分隔线
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    [containerView addSubview:separatorLine];
    
    // 设置约束
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(0);
        make.centerY.equalTo(containerView);
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(0);
        make.centerY.equalTo(containerView);
        make.width.height.mas_equalTo(16);
    }];
    
    if (subtitleLabel) {
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-15);
            make.centerY.equalTo(containerView);
        }];
    }
    
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(containerView);
        make.height.mas_equalTo(1);
    }];
    
    return containerView;
}

#pragma mark - Actions

- (void)menuItemTapped:(UIButton *)sender {
    NSDictionary *item = self.menuItems[sender.tag];
    NSString *action = item[@"action"];
    
    if ([action isEqualToString:@"modifyPassword"]) {
        [self navigateToModifyPassword];
    } else if ([action isEqualToString:@"initPassword"]) {
        [self navigateToInitPassword];
    } else if ([action isEqualToString:@"feedback"]) {
        [self navigateToFeedback];
    } else if ([action isEqualToString:@"cancelAccount"]) {
        [self showCancelAccountAlert];
    } else if ([action isEqualToString:@"clearCache"]) {
        [self showClearCacheAlert];
    }
}

- (void)logoutButtonTapped {
    [self showLogoutAlert];
}

#pragma mark - Navigation

- (void)navigateToModifyPassword {
    JJRPasswordModifyViewController *vc = [[JJRPasswordModifyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToInitPassword {
    InitPasswordViewController *vc = [[InitPasswordViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToFeedback {
    JJRFeedbackViewController *vc = [[JJRFeedbackViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Alert Actions

- (void)showLogoutAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确认退出登陆吗"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self performLogout];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showCancelAccountAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确认注销账户吗"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self performCancelAccount];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showClearCacheAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确认清除缓存吗"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self performClearCache];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Network Actions

- (void)performLogout {
    [[JJRNetworkService sharedInstance] logoutWithSuccess:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JJRToastTool showSuccess:@"登出成功" inView:self.view];
            // 和uni-app保持一致：清除所有存储包括token
            // uni-app中退出登录时调用uni.clearStorage()
            [self.userManager clearAllUserData];
            
            // 延迟跳转到登录页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self navigateToLogin];
            });
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JJRToastTool showError:@"登出失败，请重试"];
        });
    }];
}

- (void)performCancelAccount {
    [[JJRNetworkService sharedInstance] cancelAccountWithSuccess:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JJRToastTool showSuccess:@"注销成功" inView:self.view];
            // 和uni-app保持一致：清除所有存储包括token
            // uni-app中注销账号时调用uni.clearStorage()
            [self.userManager clearAllUserData];
            
            // 延迟跳转到登录页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self navigateToLogin];
            });
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JJRToastTool showError:@"注销失败，请重试"];
        });
    }];
}

- (void)performClearCache {
    // 清除缓存逻辑
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    
    // 清除临时文件
    NSString *tempPath = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *tempFiles = [fileManager contentsOfDirectoryAtPath:tempPath error:&error];
    for (NSString *file in tempFiles) {
        [fileManager removeItemAtPath:[tempPath stringByAppendingPathComponent:file] error:nil];
    }
    
    self.cacheSize = 0;
    [self loadUserInfo]; // 重新加载界面更新缓存大小显示
    [JJRToastTool showSuccess:@"清除成功" inView:self.view];

}

- (void)navigateToLogin {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // 获取应用程序的根视图控制器并替换
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    window.rootViewController = navController;
    [window makeKeyAndVisible];
}

#pragma mark - Cache Management

- (void)calculateCacheSize {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger cacheSize = 0;
        
        // 计算URL缓存大小
        NSURLCache *cache = [NSURLCache sharedURLCache];
        cacheSize += cache.currentDiskUsage;
        
        // 计算临时文件大小
        NSString *tempPath = NSTemporaryDirectory();
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *tempFiles = [fileManager contentsOfDirectoryAtPath:tempPath error:&error];
        for (NSString *file in tempFiles) {
            NSString *filePath = [tempPath stringByAppendingPathComponent:file];
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
            cacheSize += [attributes fileSize];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cacheSize = cacheSize;
        });
    });
}

- (NSString *)formatCacheSize:(NSUInteger)size {
    if (size == 0) {
        return @"0B";
    } else if (size < 1024) {
        return [NSString stringWithFormat:@"%luB", (unsigned long)size];
    } else if (size < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2fKB", size / 1024.0];
    } else if (size < 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2fMB", size / (1024.0 * 1024.0)];
    } else {
        return [NSString stringWithFormat:@"%.2fGB", size / (1024.0 * 1024.0 * 1024.0)];
    }
}

#pragma mark - Helper

@end 
