#import "RealNameAuthViewController.h"
#import "JJRNetworkService.h"
#import "JJRRealNameAuthModel.h"
#import "JJRAPIDefines.h"

@interface RealNameAuthViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JJRRealNameAuthModel *authInfo;
@property (nonatomic, strong) NSArray *itemTitles;

@end

@implementation RealNameAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupUI];
    [self fetchUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 确保状态栏样式更新
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setupNavigationBar {
    // 设置导航栏为白色背景
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        // 隐藏导航栏下面的分隔线
        appearance.shadowColor = [UIColor clearColor];
        appearance.shadowImage = [[UIImage alloc] init];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        // 隐藏导航栏下面的分隔线
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    self.navigationController.navigationBar.translucent = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 浅色背景使用深色状态栏文字
    return UIStatusBarStyleDefault;
}

- (void)setupUI {
    // 设置背景色：#F7F7F7 (与uni-app一致)
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"实名认证";
    
    // 初始化数据
    self.itemTitles = @[@"姓名", @"身份证号", @"证件照有效期"];
    
    // 创建顶部状态区域 (与uni-app的.sm-wrapper一致)
    self.headerView = [[UIView alloc] init];
    [self.view addSubview:self.headerView];
    
    // 图标 (与uni-app的.icon一致)
    self.iconImageView = [[UIImageView alloc] init];
    // 使用从uni-app拷贝过来的图片
    self.iconImageView.image = [UIImage imageNamed:@"img_521b8c1b1cc6"];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerView addSubview:self.iconImageView];
    
    // 状态文本 (与uni-app的.text一致)
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"未实名认证"; // 默认文本
    self.statusLabel.font = [UIFont systemFontOfSize:16]; // 32rpx -> 16pt (与uni-app一致)
    self.statusLabel.textColor = [UIColor colorWithRed:3.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0]; // #030303 (与uni-app一致)
    [self.headerView addSubview:self.statusLabel];
    
    // 创建TableView (与uni-app的.card一致)
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    // 去掉顶部和底部的额外间距
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    // iOS 15+ 设置sectionHeaderTopPadding为0
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    
    [self.view addSubview:self.tableView];
    
    // 设置约束
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(16); // 添加一点顶部间距
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50); // 减小高度，让整体更紧凑
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(24); // 48rpx -> 24pt (与uni-app一致)
        make.centerY.equalTo(self.headerView);
        make.width.height.mas_equalTo(26); // 52rpx -> 26pt (与uni-app一致)
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(6); // 12rpx -> 6pt (与uni-app一致)
        make.centerY.equalTo(self.headerView);
        make.right.lessThanOrEqualTo(self.headerView).offset(-24);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom); // 减小间距，让列表更贴近header
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Network

- (void)fetchUserInfo {
    NSLog(@"📡 开始获取用户信息...");
    
    [[JJRNetworkService sharedInstance] POST:JJR_USER_INFO params:@{} success:^(NSDictionary *responseObject) {
        NSLog(@"✅ 用户信息获取成功: %@", responseObject);
        
        NSDictionary *data = responseObject[@"data"] ?: @{};
        JJRRealNameAuthModel *authInfo = [[JJRRealNameAuthModel alloc] init];
        authInfo.name = data[@"name"] ?: @"";
        authInfo.idNo = data[@"idNo"] ?: @"";
        authInfo.validPeriod = data[@"validPeriod"] ?: @"";
        
        self.authInfo = authInfo;
        [self updateUI];
        
    } failure:^(NSError *error) {
        NSLog(@"❌ 获取用户信息失败: %@", error.localizedDescription);
        [JJRToastTool showError:@"获取用户信息失败" inView:self.view];
    }];
}

#pragma mark - UI Updates

- (void)updateUI {
    // 更新状态文本
    if (self.authInfo.name && ![self.authInfo.name isEqualToString:@"未认证"]) {
        self.statusLabel.text = @"已实名认证";
    } else {
        self.statusLabel.text = @"未实名认证";
    }
    
    // 重新加载表格
    [self.tableView reloadData];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RealNameAuthCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 自定义分隔线
        UIView *separatorLine = [[UIView alloc] init];
        separatorLine.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]; // #F2F2F2 (与uni-app一致)
        separatorLine.tag = 999;
        [cell.contentView addSubview:separatorLine];
        
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView);
            make.left.right.equalTo(cell.contentView);
            make.height.mas_equalTo(1); // 2rpx -> 1pt (与uni-app一致)
        }];
    }
    
    // 配置cell内容
    NSString *title = self.itemTitles[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt (与uni-app一致)
    cell.textLabel.textColor = [UIColor colorWithRed:3.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0]; // #030303 (与uni-app一致)
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt (与uni-app一致)
    cell.detailTextLabel.textColor = [UIColor colorWithRed:3.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0]; // #030303 (与uni-app一致)
    
    // 设置详情文本
    if (self.authInfo) {
        switch (indexPath.row) {
            case 0: // 姓名
                cell.detailTextLabel.text = self.authInfo.name;
                break;
            case 1: // 身份证号
                cell.detailTextLabel.text = self.authInfo.idNo;
                break;
            case 2: // 证件照有效期
                cell.detailTextLabel.text = self.authInfo.validPeriod;
                break;
            default:
                cell.detailTextLabel.text = @"";
                break;
        }
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    // 最后一行隐藏分隔线
    UIView *separatorLine = [cell.contentView viewWithTag:999];
    separatorLine.hidden = (indexPath.row == self.itemTitles.count - 1);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64; // 32rpx * 2 + font height ≈ 64pt (与uni-app的padding一致)
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN; // 使用最小可能值，完全去掉header间距
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN; // 使用最小可能值，完全去掉footer间距
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil; // 返回nil确保没有header view
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil; // 返回nil确保没有footer view
}

@end 
