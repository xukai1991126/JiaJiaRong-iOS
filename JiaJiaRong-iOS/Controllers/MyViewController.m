#import "MyViewController.h"
#import "NetworkService.h"
#import "LoginViewController.h"
#import "ApplicationRecordViewController.h"
#import "BankCardListViewController.h"
#import "UserInfoViewController.h"
#import "RealNameAuthViewController.h"
#import "AboutUsViewController.h"
#import "JJRUserManager.h"
#import <Masonry/Masonry.h>

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *userInfoView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *loginPromptLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSString *mobile;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUserInfo];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"我的";
    
    // 背景图片
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.image = [UIImage imageNamed:@"my_background"];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    // 用户信息视图
    self.userInfoView = [[UIView alloc] init];
    self.userInfoView.backgroundColor = [UIColor whiteColor];
    self.userInfoView.layer.cornerRadius = 12;
    [self.view addSubview:self.userInfoView];
    
    // 头像
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
    self.avatarImageView.layer.cornerRadius = 32;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    [self.userInfoView addSubview:self.avatarImageView];
    
    // 用户名
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.font = [UIFont systemFontOfSize:16];
    self.userNameLabel.textColor = [UIColor blackColor];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.userInfoView addSubview:self.userNameLabel];
    
    // 登录提示
    self.loginPromptLabel = [[UILabel alloc] init];
    self.loginPromptLabel.font = [UIFont boldSystemFontOfSize:14];
    self.loginPromptLabel.textColor = [UIColor blackColor];
    self.loginPromptLabel.text = @"去登录";
    self.loginPromptLabel.textAlignment = NSTextAlignmentCenter;
    self.loginPromptLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTapped)];
    [self.loginPromptLabel addGestureRecognizer:loginTap];
    [self.userInfoView addSubview:self.loginPromptLabel];
    
    // 菜单列表
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    // 设置约束
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(120);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.userInfoView);
        make.top.equalTo(self.userInfoView).offset(-32);
        make.width.height.mas_equalTo(64);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(20);
        make.left.right.equalTo(self.userInfoView);
        make.height.mas_equalTo(20);
    }];
    
    [self.loginPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(20);
        make.left.right.equalTo(self.userInfoView);
        make.height.mas_equalTo(20);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInfoView.mas_bottom).offset(20);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // 初始化菜单项
    [self setupMenuItems];
}

- (void)setupMenuItems {
    self.menuItems = @[
        @{@"title": @"申请记录", @"icon": @"record_icon", @"action": @"applicationRecord"},
        @{@"title": @"银行卡", @"icon": @"bank_icon", @"action": @"bankCard"},
        @{@"title": @"个人信息", @"icon": @"info_icon", @"action": @"myInfo"},
        @{@"title": @"实名认证", @"icon": @"auth_icon", @"action": @"realNameAuth"},
        @{@"title": @"关于我们", @"icon": @"about_icon", @"action": @"aboutUs"}
    ];
}

- (void)loadUserInfo {
    // 使用JJRUserManager获取登录状态和用户信息
    JJRUserManager *userManager = [JJRUserManager sharedManager];
    BOOL isLoggedIn = userManager.isLoggedIn;
    self.mobile = userManager.mobile;
    
    NSLog(@"🎯 MyViewController - 加载用户信息: isLoggedIn=%@, mobile=%@", isLoggedIn ? @"是" : @"否", self.mobile ?: @"无");
    
    if (isLoggedIn && self.mobile) {
        // 隐藏手机号中间4位
        NSString *maskedMobile = [self.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.userNameLabel.text = maskedMobile;
        self.userNameLabel.hidden = NO;
        self.loginPromptLabel.hidden = YES;
    } else {
        self.userNameLabel.hidden = YES;
        self.loginPromptLabel.hidden = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)loginTapped {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showLoginAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" 
                                                                   message:@"您还未登录请前往登录" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:nil];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"去登录" 
                                                          style:UIAlertActionStyleDefault 
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self loginTapped];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:loginAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 图标
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.tag = 100;
        [cell.contentView addSubview:iconImageView];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 101;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        
        // 箭头
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"go_back"];
        arrowImageView.tintColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:arrowImageView];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(20);
            make.centerY.equalTo(cell.contentView);
            make.width.height.mas_equalTo(24);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(15);
            make.centerY.equalTo(cell.contentView);
        }];
        
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-20);
            make.centerY.equalTo(cell.contentView);
            make.width.height.mas_equalTo(16);
        }];
    }
    
    NSDictionary *item = self.menuItems[indexPath.row];
    
    UIImageView *iconImageView = [cell.contentView viewWithTag:100];
    UILabel *titleLabel = [cell.contentView viewWithTag:101];
    
    iconImageView.image = [UIImage imageNamed:item[@"icon"]];
    titleLabel.text = item[@"title"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 使用JJRUserManager判断登录状态
    if (![[JJRUserManager sharedManager] isLoggedIn]) {
        NSLog(@"🎯 MyViewController - 用户未登录，显示登录提示");
        [self showLoginAlert];
        return;
    }
    
    NSDictionary *item = self.menuItems[indexPath.row];
    NSString *action = item[@"action"];
    
    if ([action isEqualToString:@"applicationRecord"]) {
        ApplicationRecordViewController *vc = [[ApplicationRecordViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"bankCard"]) {
        BankCardListViewController *vc = [[BankCardListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"myInfo"]) {
        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"realNameAuth"]) {
        RealNameAuthViewController *vc = [[RealNameAuthViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"aboutUs"]) {
        AboutUsViewController *vc = [[AboutUsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end 
