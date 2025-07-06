#import "AuthorizationViewController.h"
#import "NetworkService.h"
#import "ResultViewController.h"
#import "JJRUserManager.h"
#import <Masonry/Masonry.h>

@interface AuthorizationViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *disagreeButton;

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"授权书";
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    // 创建内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 使用Masonry设置约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"征信查询授权书";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    // 内容
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentTextView.text = @"本人授权佳佳融平台及其合作的金融机构查询、使用本人的征信信息，用于贷款审批、风险评估等业务。\n\n本人承诺提供的所有信息真实、准确、完整，如有虚假信息，本人承担相应法律责任。\n\n本授权书自签署之日起生效，有效期至贷款结清之日。";
    self.contentTextView.font = [UIFont systemFontOfSize:14];
    self.contentTextView.textColor = [UIColor blackColor];
    self.contentTextView.editable = NO;
    self.contentTextView.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
    self.contentTextView.layer.borderWidth = 1;
    self.contentTextView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.contentTextView];
    
    // 同意按钮
    self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.agreeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.agreeButton setTitle:@"同意授权" forState:UIControlStateNormal];
    [self.agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.agreeButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.agreeButton.layer.cornerRadius = 25;
    [self.agreeButton addTarget:self action:@selector(agreeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.agreeButton];
    
    // 不同意按钮
    self.disagreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.disagreeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.disagreeButton setTitle:@"不同意" forState:UIControlStateNormal];
    [self.disagreeButton setTitleColor:[UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.disagreeButton.backgroundColor = [UIColor whiteColor];
    self.disagreeButton.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
    self.disagreeButton.layer.borderWidth = 1;
    self.disagreeButton.layer.cornerRadius = 25;
    [self.disagreeButton addTarget:self action:@selector(disagreeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.disagreeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:30],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        
        [self.contentTextView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:30],
        [self.contentTextView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.contentTextView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        [self.contentTextView.heightAnchor constraintEqualToConstant:300],
        
        [self.agreeButton.topAnchor constraintEqualToAnchor:self.contentTextView.bottomAnchor constant:40],
        [self.agreeButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.agreeButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        [self.agreeButton.heightAnchor constraintEqualToConstant:50],
        
        [self.disagreeButton.topAnchor constraintEqualToAnchor:self.agreeButton.bottomAnchor constant:20],
        [self.disagreeButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.disagreeButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        [self.disagreeButton.heightAnchor constraintEqualToConstant:50],
        [self.disagreeButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-30]
    ]];
}

#pragma mark - Actions

- (void)agreeButtonTapped {
    // 提交授权
    [[NetworkService sharedInstance] POST:@"/app/authorization/submit" 
                                   params:@{} 
                                 success:^(NSDictionary *response) {
        // 更新用户信息（使用JJRUserManager）
        JJRUserManager *userManager = [JJRUserManager sharedManager];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:userManager.userInfo];
        userInfo[@"authority"] = @YES;
        [userManager updateUserInfo:userInfo];
        NSLog(@"🎯 AuthorizationViewController - 更新用户授权状态");
        
        [self showAlert:@"授权成功" completion:^{
            // 跳转到结果页面
            ResultViewController *resultVC = [[ResultViewController alloc] init];
            resultVC.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
            [self.navigationController pushViewController:resultVC animated:YES];
        }];
    } failure:^(NSError *error) {
        [self showAlert:@"授权失败"];
    }];
}

- (void)disagreeButtonTapped {
    [self showAlert:@"您需要同意授权才能继续申请"];
}

#pragma mark - Helper

- (void)showAlert:(NSString *)message {
    [self showAlert:message completion:nil];
}

- (void)showAlert:(NSString *)message completion:(void(^)(void))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end 