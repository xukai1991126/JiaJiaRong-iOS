#import "MyViewController.h"
#import "LoginViewController.h"
#import "ApplicationRecordViewController.h"
#import "BankCardListViewController.h"
#import "UserInfoViewController.h"
#import "RealNameAuthViewController.h"
#import "AboutUsViewController.h"
#import "MoreViewController.h"
#import "JJRUserManager.h"
#import <Masonry/Masonry.h>

@interface MyViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *whiteCardView;
@property (nonatomic, strong) UIView *avatarContainer;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *loginPromptLabel;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) BOOL isLoggedIn;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuItems];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // 设置状态栏样式为浅色内容（白色文字）
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    }
    [self loadUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 恢复导航栏显示，避免影响其他页面
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    // 恢复状态栏样式为默认（黑色文字）
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    }
}

// 重写状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"我的";
    
    // 创建滚动视图而不是TableView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    
    // 创建Header视图
    [self setupHeaderView];
    
    // 将header视图添加到内容视图
    [contentView addSubview:self.headerView];
    
    // 设置约束
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view); // 从屏幕最顶部开始，不使用safeArea
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
        make.height.mas_greaterThanOrEqualTo(800);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
}

- (void)setupHeaderView {
    // 计算总高度：状态栏+背景(401pt) + 白色容器起始位置(186pt) + 白色容器高度(520pt) + 底部间距(20pt) = 727pt
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 727)];
    self.headerView.backgroundColor = [UIColor clearColor];
    
    // 背景视图
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    
    // 背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"img_e91c0ba3be4d"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [self.backgroundView addSubview:backgroundImageView];
    [self.headerView addSubview:self.backgroundView];
    
    // 白色卡片视图 - 包含用户信息和所有菜单项
    self.whiteCardView = [[UIView alloc] init];
    self.whiteCardView.backgroundColor = [UIColor whiteColor];
    self.whiteCardView.layer.cornerRadius = 12;
    self.whiteCardView.layer.masksToBounds = YES;
    [self.headerView addSubview:self.whiteCardView];
    
    // 头像容器 - 添加到headerView的最外层，确保在最上层
    self.avatarContainer = [[UIView alloc] init];
    self.avatarContainer.backgroundColor = [UIColor whiteColor];
    self.avatarContainer.layer.cornerRadius = 32;
    self.avatarContainer.layer.masksToBounds = YES;
    // 添加阴影效果
    self.avatarContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.avatarContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.avatarContainer.layer.shadowOpacity = 0.1;
    self.avatarContainer.layer.shadowRadius = 4;
    [self.headerView addSubview:self.avatarContainer];
    
    // 头像图片
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage imageNamed:@"img_982d3ec7af00"];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.avatarContainer addSubview:self.avatarImageView];
    
    // 用户名标签
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.font = [UIFont systemFontOfSize:16];
    self.userNameLabel.textColor = [UIColor colorWithRed:3.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.hidden = YES;
    [self.whiteCardView addSubview:self.userNameLabel];
    
    // 登录提示标签
    self.loginPromptLabel = [[UILabel alloc] init];
    self.loginPromptLabel.text = @"去登陆";
    self.loginPromptLabel.font = [UIFont boldSystemFontOfSize:14];
    self.loginPromptLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    self.loginPromptLabel.textAlignment = NSTextAlignmentCenter;
    self.loginPromptLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTapped)];
    [self.loginPromptLabel addGestureRecognizer:loginTap];
    [self.whiteCardView addSubview:self.loginPromptLabel];
    
    // 创建菜单项 - 直接添加到白色容器内
    [self createMenuItemsInWhiteCard];
    
    // 设置约束
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(-44); // 向上延伸44pt覆盖状态栏
        make.left.right.equalTo(self.headerView);
        make.height.mas_equalTo(445); // 357 + 44(状态栏高度) + 44(向上延伸) = 445pt
    }];
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView);
    }];
    
    // 白色卡片视图 - 考虑状态栏高度，从186pt开始(142 + 44)
    [self.whiteCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(186);
        make.left.equalTo(self.headerView).offset(15);
        make.right.equalTo(self.headerView).offset(-15);
        make.height.mas_equalTo(400); // 固定高度：用户信息区域(80) + 6个菜单项(6*50=300) + 间距(20) = 520pt
    }];
    
    // 头像容器
    [self.avatarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(self.whiteCardView).offset(-32);
        make.width.height.mas_equalTo(64);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarContainer);
        make.width.height.mas_equalTo(58);
    }];
    
    // 用户信息标签
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteCardView);
        make.top.equalTo(self.whiteCardView).offset(40);
    }];
    
    [self.loginPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteCardView);
        make.top.equalTo(self.whiteCardView).offset(40);
    }];
}

- (void)createMenuItemsInWhiteCard {
    UIView *previousView = self.userNameLabel; // 从用户信息标签开始
    
    for (NSInteger i = 0; i < self.menuItems.count; i++) {
        NSDictionary *item = self.menuItems[i];
        
        // 创建菜单项视图
        UIView *menuItemView = [[UIView alloc] init];
        menuItemView.backgroundColor = [UIColor whiteColor];
        menuItemView.userInteractionEnabled = YES;
        
        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemTapped:)];
        [menuItemView addGestureRecognizer:tap];
        menuItemView.tag = i;
        
        [self.whiteCardView addSubview:menuItemView];
        
        // 图标
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:item[@"icon"]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [menuItemView addSubview:iconImageView];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = item[@"title"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        [menuItemView addSubview:titleLabel];
        
        // 右箭头
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [menuItemView addSubview:arrowImageView];
        
        // 分隔线（除了最后一个）
        if (i < self.menuItems.count - 1) {
            UIView *separatorLine = [[UIView alloc] init];
            separatorLine.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
            [menuItemView addSubview:separatorLine];
            
            [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(menuItemView);
                make.height.mas_equalTo(1);
            }];
        }
        
        // 设置约束
        [menuItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(previousView.mas_bottom); // 第一个菜单项与用户信息间距30pt
            make.left.right.equalTo(self.whiteCardView);
            make.height.mas_equalTo(50);
            if (i == self.menuItems.count - 1) {
                make.bottom.equalTo(self.whiteCardView); // 最后一个菜单项底部间距
            }
        }];
        
        // 图标约束
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(menuItemView).offset(14);
            make.centerY.equalTo(menuItemView);
            make.width.height.mas_equalTo(24);
        }];
        
        // 标题约束
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(10);
            make.centerY.equalTo(menuItemView);
        }];
        
        // 右箭头约束
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(menuItemView).offset(-14);
            make.centerY.equalTo(menuItemView);
            make.width.height.mas_equalTo(16);
        }];
        
        previousView = menuItemView;
    }
}

- (void)setupMenuItems {
    self.menuItems = @[
        @{@"title": @"申请记录", @"icon": @"img_f3a1bcaeb890", @"action": @"applicationRecord"},
        @{@"title": @"银行卡", @"icon": @"img_df756e927d8c", @"action": @"bankCard"},
        @{@"title": @"个人信息", @"icon": @"img_99989676adae", @"action": @"myInfo"},
        @{@"title": @"实名认证", @"icon": @"img_086dbc95f35e", @"action": @"realNameAuth"},
        @{@"title": @"关于我们", @"icon": @"img_7fbefa7b102b", @"action": @"aboutUs"},
        @{@"title": @"更多", @"icon": @"img_0e5ca9fea6ca", @"action": @"more"}
    ];
}

- (void)loadUserInfo {
    JJRUserManager *userManager = [JJRUserManager sharedManager];
    self.isLoggedIn = userManager.isLoggedIn;
    self.mobile = userManager.mobile;
    
    NSLog(@"🎯 MyViewController - 加载用户信息: isLoggedIn=%@, mobile=%@", self.isLoggedIn ? @"是" : @"否", self.mobile ?: @"无");
    
    if (self.isLoggedIn && self.mobile) {
        NSString *maskedMobile = [self.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.userNameLabel.text = maskedMobile;
        self.userNameLabel.hidden = NO;
        self.loginPromptLabel.hidden = YES;
    } else {
        self.userNameLabel.hidden = YES;
        self.loginPromptLabel.hidden = NO;
        
        if (!self.isLoggedIn) {
            [self showLoginAlert];
        }
    }
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
        
        // 添加圆角
        cell.layer.cornerRadius = 12;
        cell.layer.masksToBounds = YES;
        
        // 设置内边距
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    
    NSDictionary *item = self.menuItems[indexPath.row];
    
    // 设置图标 - 48rpx -> 24pt
    UIImage *iconImage = [UIImage imageNamed:item[@"icon"]];
    cell.imageView.image = iconImage;
    
    // 设置标题
    cell.textLabel.text = item[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    cell.textLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    
    // 设置右箭头
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImageView.frame = CGRectMake(0, 0, 16, 16);
    cell.accessoryView = arrowImageView;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50; // padding: 35rpx -> 70pt总高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01; // 很小的高度，几乎不可见
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01; // 很小的高度，几乎不可见
}

// 添加cell之间的间距
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 检查登录状态
    if (!self.isLoggedIn) {
        return;
    }
    
    NSDictionary *item = self.menuItems[indexPath.row];
    NSString *action = item[@"action"];
    
    if ([action isEqualToString:@"applicationRecord"]) {
        ApplicationRecordViewController *vc = [[ApplicationRecordViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"bankCard"]) {
        BankCardListViewController *vc = [[BankCardListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"myInfo"]) {
        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"realNameAuth"]) {
        RealNameAuthViewController *vc = [[RealNameAuthViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"aboutUs"]) {
        AboutUsViewController *vc = [[AboutUsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"more"]) {
        MoreViewController *vc = [[MoreViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" 
                                                            style:UIAlertActionStyleDefault 
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [self loginTapped];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:nil];
    
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)menuItemTapped:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    
    // 检查登录状态
    if (!self.isLoggedIn) {
        return;
    }
    
    NSDictionary *item = self.menuItems[index];
    NSString *action = item[@"action"];
    
    if ([action isEqualToString:@"applicationRecord"]) {
        ApplicationRecordViewController *vc = [[ApplicationRecordViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"bankCard"]) {
        BankCardListViewController *vc = [[BankCardListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"myInfo"]) {
        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"realNameAuth"]) {
        RealNameAuthViewController *vc = [[RealNameAuthViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"aboutUs"]) {
        AboutUsViewController *vc = [[AboutUsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([action isEqualToString:@"more"]) {
        MoreViewController *vc = [[MoreViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end 
