#import "InitPasswordViewController.h"
#import "NetworkService.h"
#import <Masonry/Masonry.h>

@interface InitPasswordViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation InitPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"设置密码";
    
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
    
    // 密码输入框
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"设置密码";
    passwordLabel.font = [UIFont systemFontOfSize:16];
    passwordLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:passwordLabel];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"请输入密码";
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
    self.confirmPasswordTextField.placeholder = @"请再次输入密码";
    self.confirmPasswordTextField.font = [UIFont systemFontOfSize:16];
    self.confirmPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.confirmPasswordTextField.secureTextEntry = YES;
    [self.formView addSubview:self.confirmPasswordTextField];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"确认设置" forState:UIControlStateNormal];
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
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.formView).offset(20);
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

- (void)submitButtonTapped {
    if (self.passwordTextField.text.length == 0) {
        [self showAlert:@"请输入密码"];
        return;
    }
    
    if (self.confirmPasswordTextField.text.length == 0) {
        [self showAlert:@"请确认密码"];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self showAlert:@"两次输入的密码不一致"];
        return;
    }
    
    [self initPassword];
}

- (void)initPassword {
    [NetworkService showLoading];
    
    NSDictionary *params = @{@"password": self.passwordTextField.text};
    
    [[NetworkService sharedInstance] POST:@"/app/user/initPassword" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"密码设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"密码设置失败，请重试"];
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

@end 