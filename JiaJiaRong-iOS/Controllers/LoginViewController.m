#import "LoginViewController.h"
#import "JJRNetworkService.h"
#import "JJRUserManager.h"
#import "MainTabBarController.h"
#import "WebViewController.h"
#import <CoreText/CoreText.h>
#import <YYKit/YYKit.h>
#import "JJRPasswordModifyViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *welcomeLabel1;
@property (nonatomic, strong) UILabel *welcomeLabel2;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *formContainer;
@property (nonatomic, strong) UIView *tabContainer;
@property (nonatomic, strong) UIButton *captchaTabButton;
@property (nonatomic, strong) UIButton *passwordTabButton;
@property (nonatomic, strong) UIView *tabIndicator;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic, strong) UIButton *protocolCheckbox;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;

@property (nonatomic, assign) BOOL captchaLogin;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger countdownSeconds;
@property (nonatomic, assign) BOOL protocolChecked;

@end

@implementation LoginViewController

- (BOOL)requiresLogin {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"🎯 LoginViewController - viewDidLoad called");
    self.captchaLogin = YES;
    self.protocolChecked = NO;
    [self setupUI];
    [self setupConstraints];
    [self setupActions];
    [self fetchAppChannelInfo];
    NSLog(@"🎯 LoginViewController - setup completed");
}

- (void)setupUI {
    NSLog(@"🎯 LoginViewController - setupUI called");
    
    // 设置背景渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#F2582B"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1"].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    // 欢迎文字
    self.welcomeLabel1 = [[UILabel alloc] init];
    self.welcomeLabel1.text = @"你好！";
    self.welcomeLabel1.font = [UIFont boldSystemFontOfSize:20];
    self.welcomeLabel1.textColor = [UIColor whiteColor];
    [self.view addSubview:self.welcomeLabel1];
    
    self.welcomeLabel2 = [[UILabel alloc] init];
    self.welcomeLabel2.text = @"欢迎使用佳佳融";
    self.welcomeLabel2.font = [UIFont boldSystemFontOfSize:20];
    self.welcomeLabel2.textColor = [UIColor whiteColor];
    [self.view addSubview:self.welcomeLabel2];
    
    // Logo图片
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"logo"];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.logoImageView];
    
    // 表单容器
    self.formContainer = [[UIView alloc] init];
    self.formContainer.backgroundColor = [UIColor whiteColor];
    self.formContainer.layer.cornerRadius = 12;
    self.formContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.formContainer.layer.shadowOffset = CGSizeMake(0, 4);
    self.formContainer.layer.shadowOpacity = 0.08;
    self.formContainer.layer.shadowRadius = 8;
    [self.view addSubview:self.formContainer];
    
    // 切换标签
    self.tabContainer = [[UIView alloc] init];
    [self.formContainer addSubview:self.tabContainer];
    
    self.captchaTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.captchaTabButton setTitle:@"验证码登录" forState:UIControlStateNormal];
    [self.captchaTabButton setTitleColor:[UIColor colorWithHexString:@"#030303"] forState:UIControlStateNormal];
    self.captchaTabButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.captchaTabButton addTarget:self action:@selector(switchToCaptchaLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.tabContainer addSubview:self.captchaTabButton];
    
    self.passwordTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.passwordTabButton setTitle:@"密码登录" forState:UIControlStateNormal];
    [self.passwordTabButton setTitleColor:[UIColor colorWithHexString:@"#030303"] forState:UIControlStateNormal];
    self.passwordTabButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.passwordTabButton addTarget:self action:@selector(switchToPasswordLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.tabContainer addSubview:self.passwordTabButton];
    
    self.tabIndicator = [[UIView alloc] init];
    self.tabIndicator.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.tabIndicator.layer.cornerRadius = 3;
    [self.tabContainer addSubview:self.tabIndicator];
    
    // 手机号输入
    self.mobileLabel = [[UILabel alloc] init];
    self.mobileLabel.text = @"手机号码";
    self.mobileLabel.font = [UIFont systemFontOfSize:14];
    self.mobileLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    [self.formContainer addSubview:self.mobileLabel];
    
    self.mobileTextField = [[UITextField alloc] init];
    self.mobileTextField.placeholder = @"请输入您的手机号";
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.font = [UIFont systemFontOfSize:14];
    self.mobileTextField.backgroundColor = [UIColor colorWithHexString:@"#F4F6F9"];
    self.mobileTextField.layer.cornerRadius = 6;
    self.mobileTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    self.mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.formContainer addSubview:self.mobileTextField];
    
    // 验证码/密码输入
    self.codeLabel = [[UILabel alloc] init];
    self.codeLabel.text = @"验证码";
    self.codeLabel.font = [UIFont systemFontOfSize:14];
    self.codeLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    [self.formContainer addSubview:self.codeLabel];
    
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.font = [UIFont systemFontOfSize:14];
    self.codeTextField.backgroundColor = [UIColor colorWithHexString:@"#F4F6F9"];
    self.codeTextField.layer.cornerRadius = 6;
    self.codeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.codeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.formContainer addSubview:self.codeTextField];
    
    // 发送验证码按钮
    self.sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendCodeButton setTitleColor:[UIColor colorWithHexString:@"#3B4FDE"] forState:UIControlStateNormal];
    self.sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.sendCodeButton.layer.cornerRadius = 6;
    [self.sendCodeButton addTarget:self action:@selector(sendCodeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.formContainer addSubview:self.sendCodeButton];
    
    // 协议勾选
    self.protocolCheckbox = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.protocolCheckbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141_unselect"] forState:UIControlStateNormal];
    [self.protocolCheckbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141"] forState:UIControlStateSelected];
    [self.protocolCheckbox addTarget:self action:@selector(protocolCheckboxTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.formContainer addSubview:self.protocolCheckbox];
    
    self.protocolLabel = [[UILabel alloc] init];
    self.protocolLabel.font = [UIFont systemFontOfSize:12];
    self.protocolLabel.userInteractionEnabled = YES;
    [self setupProtocolText];
    [self.formContainer addSubview:self.protocolLabel];
    
    // 登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.loginButton addTarget:self action:@selector(loginTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.formContainer addSubview:self.loginButton];
    
    // 忘记密码按钮
    self.forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.forgetPasswordButton addTarget:self action:@selector(forgetPasswordTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.formContainer addSubview:self.forgetPasswordButton];
    
    NSLog(@"🎯 LoginViewController - UI setup completed");
}

- (void)setupConstraints {
    // 检测屏幕高度，为小屏幕设备优化间距
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    BOOL isSmallScreen = screenHeight <= 667; // iPhone SE, iPhone 6/7/8
    
    CGFloat topOffset = isSmallScreen ? 20 : 40;
    CGFloat logoTopOffset = isSmallScreen ? 10 : 20;
    CGFloat containerTopOffset = isSmallScreen ? 16 : 20;
    CGFloat tabContainerOffset = isSmallScreen ? 12 : 16;
    CGFloat labelSpacing = isSmallScreen ? 16 : 20;
    CGFloat inputSpacing = isSmallScreen ? 4 : 6;
    CGFloat sectionSpacing = isSmallScreen ? 10 : 12;
    
    // 布局部分 - 优化为响应式布局
    [self.welcomeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(topOffset);
        make.left.equalTo(self.view).offset(32);
    }];
    
    [self.welcomeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.welcomeLabel1.mas_bottom).offset(4);
        make.left.equalTo(self.view).offset(32);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(logoTopOffset);
        make.right.equalTo(self.view).offset(-32);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(48);
    }];
    
    [self.formContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.welcomeLabel2.mas_bottom).offset(containerTopOffset);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.lessThanOrEqualTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
    }];
    
    [self.tabContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.formContainer).offset(tabContainerOffset);
        make.left.right.equalTo(self.formContainer);
        make.height.mas_equalTo(32);
    }];
    
    [self.captchaTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabContainer).offset(24);
        make.centerY.equalTo(self.tabContainer);
        make.width.mas_equalTo(100);
    }];
    
    [self.passwordTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.captchaTabButton.mas_right).offset(24);
        make.centerY.equalTo(self.tabContainer);
        make.width.mas_equalTo(100);
    }];
    
    [self.tabIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tabContainer);
        make.centerX.equalTo(self.captchaTabButton);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(4);
    }];
    
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabContainer.mas_bottom).offset(labelSpacing);
        make.left.equalTo(self.formContainer).offset(16);
    }];
    
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileLabel.mas_bottom).offset(inputSpacing);
        make.left.equalTo(self.formContainer).offset(16);
        make.right.equalTo(self.formContainer).offset(-16);
        make.height.mas_equalTo(40);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileTextField.mas_bottom).offset(sectionSpacing);
        make.left.equalTo(self.formContainer).offset(16);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).offset(inputSpacing);
        make.left.equalTo(self.formContainer).offset(16);
        make.right.equalTo(self.sendCodeButton.mas_left).offset(-8);
        make.height.mas_equalTo(40);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).offset(inputSpacing);
        make.right.equalTo(self.formContainer).offset(-16);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    [self.protocolCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextField.mas_bottom).offset(sectionSpacing);
        make.left.equalTo(self.formContainer).offset(16);
        make.width.height.mas_equalTo(16);
    }];
    
    // 协议标签约束现在在setupProtocolText方法中设置
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.protocolCheckbox.mas_bottom).offset(sectionSpacing);
        make.left.equalTo(self.formContainer).offset(16);
        make.right.equalTo(self.formContainer).offset(-16);
        make.height.mas_equalTo(40);
    }];
    
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(sectionSpacing);
        make.right.equalTo(self.formContainer).offset(-16);
        make.bottom.equalTo(self.formContainer).offset(-16);
    }];
}

- (void)setupActions {
    // 初始化时隐藏忘记密码按钮
    self.forgetPasswordButton.hidden = YES;
}

- (void)setupProtocolText {
    // 移除原来的协议标签
    [self.protocolLabel removeFromSuperview];
    
    // 创建协议容器视图
    UIView *protocolContainer = [[UIView alloc] init];
    [self.formContainer addSubview:protocolContainer];
    
    // 创建"我已阅读并同意"标签
    UILabel *prefixLabel = [[UILabel alloc] init];
    prefixLabel.text = @"我已阅读并同意";
    prefixLabel.font = [UIFont systemFontOfSize:12];
    prefixLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [protocolContainer addSubview:prefixLabel];
    
    // 创建服务协议按钮
    UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceButton setTitle:@" 《服务协议》" forState:UIControlStateNormal];
    [serviceButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    serviceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    serviceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [serviceButton addTarget:self action:@selector(showServiceAgreement) forControlEvents:UIControlEventTouchUpInside];
    [protocolContainer addSubview:serviceButton];
    
    // 创建隐私协议按钮
    UIButton *privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [privacyButton setTitle:@" 《隐私协议》" forState:UIControlStateNormal];
    [privacyButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    privacyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    privacyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [privacyButton addTarget:self action:@selector(showPrivacyAgreement) forControlEvents:UIControlEventTouchUpInside];
    [protocolContainer addSubview:privacyButton];
    
    // 设置约束
    [protocolContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.protocolCheckbox.mas_right).offset(8);
        make.centerY.equalTo(self.protocolCheckbox);
        make.right.lessThanOrEqualTo(self.formContainer.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    [prefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(protocolContainer);
        make.centerY.equalTo(protocolContainer);
    }];
    
    [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(prefixLabel.mas_right);
        make.centerY.equalTo(protocolContainer);
        make.height.equalTo(protocolContainer);
    }];
    
    [privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serviceButton.mas_right);
        make.centerY.equalTo(protocolContainer);
        make.height.equalTo(protocolContainer);
        make.right.lessThanOrEqualTo(protocolContainer.mas_right);
    }];
    
    // 更新protocolLabel引用指向容器
    self.protocolLabel = (UILabel *)protocolContainer;
}

- (void)createProtocolButtons {
    // 这个方法现在不需要了，因为我们直接创建了按钮
}

- (void)layoutProtocolButtons:(UIButton *)serviceButton privacyButton:(UIButton *)privacyButton {
    // 这个方法现在不需要了
}

#pragma mark - Actions

- (void)switchToCaptchaLogin {
    self.captchaLogin = YES;
    self.codeLabel.text = @"验证码";
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.secureTextEntry = NO;
    self.sendCodeButton.hidden = NO;
    self.forgetPasswordButton.hidden = YES;
    
    // 检测屏幕高度，使用动态间距
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    BOOL isSmallScreen = screenHeight <= 667;
    CGFloat inputSpacing = isSmallScreen ? 4 : 6;
    
    // 恢复验证码输入框的约束，为发送验证码按钮留出空间
    [self.codeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).offset(inputSpacing);
        make.left.equalTo(self.formContainer).offset(16);
        make.right.equalTo(self.sendCodeButton.mas_left).offset(-8);
        make.height.mas_equalTo(40);
    }];
    
    [self.tabIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tabContainer);
        make.centerX.equalTo(self.captchaTabButton);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(4);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)switchToPasswordLogin {
    self.captchaLogin = NO;
    self.codeLabel.text = @"密码";
    self.codeTextField.placeholder = @"请输入您的密码";
    self.codeTextField.keyboardType = UIKeyboardTypeDefault;
    self.codeTextField.secureTextEntry = YES;
    self.sendCodeButton.hidden = YES;
    self.forgetPasswordButton.hidden = NO;
    
    // 检测屏幕高度，使用动态间距
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    BOOL isSmallScreen = screenHeight <= 667;
    CGFloat inputSpacing = isSmallScreen ? 4 : 6;
    
    // 重新设置密码输入框的约束，让它和手机号输入框宽度一致
    [self.codeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).offset(inputSpacing);
        make.left.equalTo(self.formContainer).offset(16);
        make.right.equalTo(self.formContainer).offset(-16);
        make.height.mas_equalTo(40);
    }];
    
    [self.tabIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tabContainer);
        make.centerX.equalTo(self.passwordTabButton);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(4);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)sendCodeTapped {
    if (self.countdownSeconds > 0) {
        return;
    }
    
    if (![self validateMobile]) {
        return;
    }
    
    NSLog(@"🎯 开始发送验证码");
    [JJRNetworkService showLoading];
    
    // 获取手机号
    NSString *mobile = [self.mobileTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 加密手机号
    NSString *encryptedMobile = [JJRNetworkService encryptMobile:mobile];
    NSString *md5Mobile = [JJRNetworkService encryptMobileMd5:mobile];
    
    // 调用发送验证码接口
    [[JJRNetworkService sharedInstance] sendCaptchaWithType:@"LOGIN" 
                                                     mobile:encryptedMobile 
                                                        md5:md5Mobile 
                                                    success:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        NSLog(@"🎯 验证码发送成功: %@", response);
        [JJRToastTool showToast:@"验证码已发送"];
        [self startCountdown];
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        NSLog(@"🎯 验证码发送失败: %@", error.localizedDescription);
        NSString *errorMessage = error.localizedDescription;
        if (!errorMessage || errorMessage.length == 0) {
            errorMessage = @"验证码发送失败，请稍后重试";
        }
        [JJRToastTool showError:errorMessage];
    }];
}

- (void)startCountdown {
    self.countdownSeconds = 60;
    [self.sendCodeButton setEnabled:NO];
    [self updateCountdownDisplay];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

- (void)updateCountdown {
    self.countdownSeconds--;
    if (self.countdownSeconds <= 0) {
        [self stopCountdown];
    } else {
        [self updateCountdownDisplay];
    }
}

- (void)updateCountdownDisplay {
    if (self.countdownSeconds > 0) {
        [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%lds", (long)self.countdownSeconds] forState:UIControlStateNormal];
    } else {
        [self.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)stopCountdown {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    [self.sendCodeButton setEnabled:YES];
    [self.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)protocolCheckboxTapped {
    [self.view endEditing:YES];
    self.protocolChecked = !self.protocolChecked;
    self.protocolCheckbox.selected = self.protocolChecked;
}

- (void)loginTapped {
    [self.view endEditing:YES];
    if (![self validateMobile]) {
        return;
    }
    
    if (self.captchaLogin) {
        if (![self validateCaptcha]) {
            return;
        }
    } else {
        if (![self validatePassword]) {
            return;
        }
    }
    
    if (!self.protocolChecked) {
        [JJRToastTool showToast:@"请阅读并勾选协议框"];
        return;
    }
    
    NSString *mobile = self.mobileTextField.text;
    NSString *text = self.codeTextField.text;
    
    // 加密手机号
    NSString *encryptedMobile = [JJRNetworkService encryptMobile:mobile];
    NSString *mobileMd5 = [JJRNetworkService encryptMobileMd5:mobile];
    
    NSLog(@"🎯 开始登录: mobile=%@", mobile);
    [JJRNetworkService showLoading];
    
    if (self.captchaLogin) {
        // 验证码登录
        [[JJRNetworkService sharedInstance] loginWithCaptcha:text 
                                                      mobile:encryptedMobile 
                                                         md5:mobileMd5 
                                                     success:^(NSDictionary *response) {
            [JJRNetworkService hideLoading];
            [self handleLoginSuccess:response mobile:mobile];
        } failure:^(NSError *error) {
            [JJRNetworkService hideLoading];
            NSString *errorMessage = error.localizedDescription;
            if (!errorMessage || errorMessage.length == 0) {
                errorMessage = @"登录失败，请重试";
            }
            [JJRToastTool showToast:errorMessage];
        }];
    } else {
        // 密码登录
        [[JJRNetworkService sharedInstance] loginWithPassword:text 
                                                        mobile:encryptedMobile 
                                                           md5:mobileMd5 
                                                       success:^(NSDictionary *response) {
            [JJRNetworkService hideLoading];
            [self handleLoginSuccess:response mobile:mobile];
        } failure:^(NSError *error) {
            [JJRNetworkService hideLoading];
            NSString *errorMessage = error.localizedDescription;
            if (!errorMessage || errorMessage.length == 0) {
                errorMessage = @"登录失败，请重试";
            }
            [JJRToastTool showToast:errorMessage];
        }];
    }
}

- (void)handleLoginSuccess:(NSDictionary *)response mobile:(NSString *)mobile {
    NSLog(@"🎯 登录成功: %@", response);
    
    // 保存登录信息到用户管理器
    // 和uni-app保持一致，登录成功后只保存用户信息和手机号，不更新token
    NSDictionary *userInfo = response[@"data"];
    NSLog(@"🎯 准备保存的用户信息: %@", userInfo);
    NSLog(@"🎯 准备保存的手机号: %@", mobile);
    
    // 和uni-app一致：登录成功后不处理token，继续使用渠道token
    [[JJRUserManager sharedManager] saveLoginInfo:userInfo mobile:mobile];
    
    // 验证保存后的状态
    JJRUserManager *userManager = [JJRUserManager sharedManager];
    NSLog(@"🎯 保存后的UserManager状态:");
    NSLog(@"🎯 - isLoggedIn: %@", userManager.isLoggedIn ? @"YES" : @"NO");
    NSLog(@"🎯 - userInfo: %@", userManager.userInfo);
    NSLog(@"🎯 - token: %@", userManager.token);
    NSLog(@"🎯 - mobile: %@", userManager.mobile);
    
    // 验证NSUserDefaults中的值
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"🎯 保存后NSUserDefaults中的值:");
    NSLog(@"🎯 - JJRUserInfo: %@", [defaults objectForKey:@"JJRUserInfo"]);
    NSLog(@"🎯 - token: %@", [defaults objectForKey:@"token"]);
    NSLog(@"🎯 - mobile: %@", [defaults objectForKey:@"mobile"]);
    
    [JJRToastTool showSuccess:@"登录成功"];
    
    // 跳转到主页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MainTabBarController *mainVC = [[MainTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
    });
}

- (void)forgetPasswordTapped {
    JJRPasswordModifyViewController *vc = [[JJRPasswordModifyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)showServiceAgreement {
    [self showAgreementWithType:@"user" title:@"服务协议"];
}

- (void)showPrivacyAgreement {
    [self showAgreementWithType:@"privacy" title:@"隐私协议"];
}

- (void)showAgreementWithType:(NSString *)type title:(NSString *)title {
    // 创建WebViewController来显示协议内容
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.agreementType = type;
    webVC.title = title;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Validation

- (BOOL)validateMobile {
    NSString *mobile = [self.mobileTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (mobile.length == 0) {
        [JJRToastTool showToast:@"请输入手机号"];
        return NO;
    }
    
    NSString *phoneRegex = @"^1[3-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if (![phoneTest evaluateWithObject:mobile]) {
        [JJRToastTool showToast:@"请输入正确的手机号"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateCaptcha {
    NSString *captcha = [self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (captcha.length == 0) {
        [JJRToastTool showToast:@"请输入验证码"];
        return NO;
    }
    
    if (captcha.length != 4) {
        [JJRToastTool showToast:@"验证码格式不正确"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validatePassword {
    NSString *password = [self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (password.length == 0) {
        [JJRToastTool showToast:@"请输入密码"];
        return NO;
    }
    
    return YES;
}


- (void)fetchAppChannelInfo {
    NSLog(@"🎯 开始获取应用渠道信息");
    
    // 和uni-app保持一致：每次都获取token，不检查本地是否已有
    // uni-app中每次进入相关页面都会直接调用/app/channel接口
    
    [[JJRNetworkService sharedInstance] getAppChannelWithAppId:@"JJR" 
                                                       client:@"IOS" 
                                                      success:^(NSDictionary *response) {
        
        NSString *token = response[@"data"][@"tk"];  // 服务端返回的是tk字段
        if (token) {
            [[JJRUserManager sharedManager] saveToken:token];
            NSLog(@"🎯 保存token (tk): %@", token);
        }
    } failure:^(NSError *error) {
        NSLog(@"🎯 应用渠道信息获取失败: %@", error.localizedDescription);
    }];
}

- (void)dealloc {
    [self.countdownTimer invalidate];
}

@end 

