#import "ForgetPasswordViewController.h"
#import "NetworkService.h"
#import <Masonry/Masonry.h>

@interface ForgetPasswordViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger countdown;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"忘记密码";
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 表单视图
    self.formView = [[UIView alloc] init];
    self.formView.backgroundColor = [UIColor whiteColor];
    self.formView.layer.cornerRadius = 12;
    [self.contentView addSubview:self.formView];
    
    // 手机号输入框
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"手机号";
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:phoneLabel];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入手机号";
    self.phoneTextField.font = [UIFont systemFontOfSize:16];
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.formView addSubview:self.phoneTextField];
    
    // 验证码输入框
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.text = @"验证码";
    codeLabel.font = [UIFont systemFontOfSize:16];
    codeLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:codeLabel];
    
    UIView *codeContainer = [[UIView alloc] init];
    [self.formView addSubview:codeContainer];
    
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.font = [UIFont systemFontOfSize:16];
    self.codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [codeContainer addSubview:self.codeTextField];
    
    self.sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendCodeButton setTitleColor:[UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.sendCodeButton.layer.borderWidth = 1;
    self.sendCodeButton.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
    self.sendCodeButton.layer.cornerRadius = 5;
    [self.sendCodeButton addTarget:self action:@selector(sendCodeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [codeContainer addSubview:self.sendCodeButton];
    
    // 新密码输入框
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"新密码";
    passwordLabel.font = [UIFont systemFontOfSize:16];
    passwordLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:passwordLabel];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"请输入新密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:16];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    [self.formView addSubview:self.passwordTextField];
    
    // 确认密码输入框
    UILabel *confirmPasswordLabel = [[UILabel alloc] init];
    confirmPasswordLabel.text = @"确认密码";
    confirmPasswordLabel.font = [UIFont systemFontOfSize:16];
    confirmPasswordLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:confirmPasswordLabel];
    
    self.confirmPasswordTextField = [[UITextField alloc] init];
    self.confirmPasswordTextField.placeholder = @"请再次输入新密码";
    self.confirmPasswordTextField.font = [UIFont systemFontOfSize:16];
    self.confirmPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.confirmPasswordTextField.secureTextEntry = YES;
    [self.formView addSubview:self.confirmPasswordTextField];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"重置密码" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.submitButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.submitButton.layer.cornerRadius = 25;
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.submitButton];
    
    // 设置约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.formView).offset(20);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(20);
        make.left.equalTo(self.formView).offset(20);
    }];
    
    [codeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(codeContainer);
        make.right.equalTo(self.sendCodeButton.mas_left).offset(-10);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(codeContainer);
        make.width.mas_equalTo(100);
    }];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeContainer.mas_bottom).offset(20);
        make.left.equalTo(self.formView).offset(20);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [confirmPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(20);
        make.left.equalTo(self.formView).offset(20);
    }];
    
    [self.confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPasswordLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.formView).offset(-20);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.formView.mas_bottom).offset(30);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)sendCodeButtonTapped {
    if (self.phoneTextField.text.length == 0) {
        [self showAlert:@"请输入手机号"];
        return;
    }
    
    if (self.phoneTextField.text.length != 11) {
        [self showAlert:@"请输入正确的手机号"];
        return;
    }
    
    [self sendVerificationCode];
}

- (void)sendVerificationCode {
    [NetworkService showLoading];
    
    NSDictionary *params = @{@"phone": self.phoneTextField.text};
    [[NetworkService sharedInstance] POST:@"/app/user/sendCode" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"验证码发送成功"];
            [self startCountdown];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"验证码发送失败，请重试"];
        });
    }];
}

- (void)startCountdown {
    self.countdown = 60;
    self.sendCodeButton.enabled = NO;
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                           target:self 
                                                         selector:@selector(updateCountdown) 
                                                         userInfo:nil 
                                                          repeats:YES];
}

- (void)updateCountdown {
    self.countdown--;
    [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%lds", (long)self.countdown] forState:UIControlStateNormal];
    
    if (self.countdown <= 0) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        self.sendCodeButton.enabled = YES;
        [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
}

- (void)submitButtonTapped {
    if (self.phoneTextField.text.length == 0) {
        [self showAlert:@"请输入手机号"];
        return;
    }
    
    if (self.codeTextField.text.length == 0) {
        [self showAlert:@"请输入验证码"];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        [self showAlert:@"请输入新密码"];
        return;
    }
    
    if (self.confirmPasswordTextField.text.length == 0) {
        [self showAlert:@"请确认新密码"];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self showAlert:@"两次输入的密码不一致"];
        return;
    }
    
    [self resetPassword];
}

- (void)resetPassword {
    [NetworkService showLoading];
    
    NSDictionary *params = @{
        @"phone": self.phoneTextField.text,
        @"code": self.codeTextField.text,
        @"password": self.passwordTextField.text
    };
    
    [[NetworkService sharedInstance] POST:@"/app/user/resetPassword" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"密码重置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"密码重置失败，请重试"];
        });
    }];
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    if (self.countdownTimer) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

@end 