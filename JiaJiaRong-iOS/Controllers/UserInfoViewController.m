#import "UserInfoViewController.h"
#import "JJRNetworkService.h"
#import "JJRUserInfoModel.h"
#import "JJRAPIDefines.h"

@interface UserInfoViewController ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) JJRUserInfoModel *userInfo;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self fetchUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 确保状态栏样式更新
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 浅色背景使用深色状态栏文字
    return UIStatusBarStyleDefault;
}

- (void)setupUI {
    // 设置背景色：#F7F7F7 (与uni-app一致)
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"个人信息";
    
    // 创建白色卡片容器 (与uni-app的.card样式一致)
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cardView];
    
    // 设置卡片约束
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
    }];
    
    // 创建信息项
    [self createInfoItemWithLabel:@"姓名" tag:100 isLast:NO];
    [self createInfoItemWithLabel:@"性别" tag:101 isLast:NO];
    [self createInfoItemWithLabel:@"手机号" tag:102 isLast:NO];
    [self createInfoItemWithLabel:@"身份证号" tag:103 isLast:YES];
}

#pragma mark - UI Helper Methods

- (void)createInfoItemWithLabel:(NSString *)labelText tag:(NSInteger)tag isLast:(BOOL)isLast {
    // 创建信息项容器 (与uni-app的.item样式一致)
    UIView *itemView = [[UIView alloc] init];
    itemView.tag = tag;
    [self.cardView addSubview:itemView];
    
    // 标签
    UILabel *label = [[UILabel alloc] init];
    label.text = labelText;
    label.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt (与uni-app一致)
    label.textColor = [UIColor colorWithRed:3.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0]; // #030303 (与uni-app一致)
    [itemView addSubview:label];
    
    // 值标签
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.tag = tag + 10; // 值标签的tag = 信息项tag + 10
    valueLabel.text = @""; // 初始为空
    valueLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt (与uni-app一致)
    valueLabel.textColor = [UIColor colorWithRed:3.0/255.0 green:3.0/255.0 blue:3.0/255.0 alpha:1.0]; // #030303 (与uni-app一致)
    valueLabel.textAlignment = NSTextAlignmentRight;
    [itemView addSubview:valueLabel];
    
    // 分隔线
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]; // #F2F2F2 (与uni-app一致)
    separatorLine.hidden = isLast; // 最后一项不显示分隔线
    [itemView addSubview:separatorLine];
    
    // 设置约束
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (tag == 100) {
            // 第一项
            make.top.equalTo(self.cardView);
        } else {
            // 其他项
            UIView *previousItem = [self.cardView viewWithTag:tag - 1];
            make.top.equalTo(previousItem.mas_bottom);
        }
        make.left.right.equalTo(self.cardView);
        make.height.mas_equalTo(64); // 32rpx * 2 + font height ≈ 64pt (与uni-app的padding一致)
        
        if (isLast) {
            // 最后一项设置卡片底部约束
            make.bottom.equalTo(self.cardView);
        }
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemView).offset(24); // 48rpx -> 24pt (与uni-app一致)
        make.centerY.equalTo(itemView);
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(itemView).offset(-24); // 48rpx -> 24pt (与uni-app一致)
        make.centerY.equalTo(itemView);
        make.left.greaterThanOrEqualTo(label.mas_right).offset(20);
    }];
    
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(itemView);
        make.left.right.equalTo(itemView);
        make.height.mas_equalTo(1); // 2rpx -> 1pt (与uni-app一致)
    }];
}

#pragma mark - Network

- (void)fetchUserInfo {
    NSLog(@"📡 开始获取用户信息...");
    
    [[JJRNetworkService sharedInstance] POST:JJR_USER_INFO params:@{} success:^(NSDictionary *responseObject) {
        NSLog(@"✅ 用户信息获取成功: %@", responseObject);
        
        NSDictionary *data = responseObject[@"data"] ?: @{};
        JJRUserInfoModel *userInfo = [[JJRUserInfoModel alloc] init];
        userInfo.name = data[@"name"] ?: @"";
        userInfo.sex = data[@"sex"] ?: @"";
        userInfo.mobile = data[@"mobile"] ?: @"";
        userInfo.idNo = data[@"idNo"] ?: @"";
        
        self.userInfo = userInfo;
        [self updateUI];
        
    } failure:^(NSError *error) {
        NSLog(@"❌ 获取用户信息失败: %@", error.localizedDescription);
        [self showToast:@"获取用户信息失败"];
    }];
}

#pragma mark - UI Updates

- (void)updateUI {
    if (!self.userInfo) {
        return;
    }
    
    // 更新各个信息项的值
    UILabel *nameValueLabel = [self.cardView viewWithTag:110]; // 100 + 10
    nameValueLabel.text = self.userInfo.name;
    
    UILabel *sexValueLabel = [self.cardView viewWithTag:111]; // 101 + 10
    sexValueLabel.text = self.userInfo.sex;
    
    UILabel *mobileValueLabel = [self.cardView viewWithTag:112]; // 102 + 10
    mobileValueLabel.text = self.userInfo.mobile;
    
    UILabel *idNoValueLabel = [self.cardView viewWithTag:113]; // 103 + 10
    idNoValueLabel.text = self.userInfo.idNo;
}

- (void)showToast:(NSString *)message {
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:toast animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismissViewControllerAnimated:YES completion:nil];
    });
}

@end 
