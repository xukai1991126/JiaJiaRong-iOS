#import "ModifyPasswordViewController.h"
#import "NetworkService.h"

@interface ModifyPasswordViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, strong) UITextField *oldPasswordTextField;
@property (nonatomic, strong) UITextField *latestNewPasswordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"修改密码";
    
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
    
    // 原密码输入框
    UILabel *oldPasswordLabel = [[UILabel alloc] init];
    oldPasswordLabel.text = @"原密码";
    oldPasswordLabel.font = [UIFont systemFontOfSize:16];
    oldPasswordLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:oldPasswordLabel];
    
    self.oldPasswordTextField = [[UITextField alloc] init];
    self.oldPasswordTextField.placeholder = @"请输入原密码";
    self.oldPasswordTextField.font = [UIFont systemFontOfSize:16];
    self.oldPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.oldPasswordTextField.secureTextEntry = YES;
    [self.formView addSubview:self.oldPasswordTextField];
    
    // 新密码输入框
    UILabel *newPasswordLabel = [[UILabel alloc] init];
    newPasswordLabel.text = @"新密码";
    newPasswordLabel.font = [UIFont systemFontOfSize:16];
    newPasswordLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:newPasswordLabel];
    
    self.latestNewPasswordTextField = [[UITextField alloc] init];
    self.latestNewPasswordTextField.placeholder = @"请输入新密码";
    self.latestNewPasswordTextField.font = [UIFont systemFontOfSize:16];
    self.latestNewPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.latestNewPasswordTextField.secureTextEntry = YES;
    [self.formView addSubview:self.latestNewPasswordTextField];
    
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
    [self.submitButton setTitle:@"修改密码" forState:UIControlStateNormal];
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
    
    [oldPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.formView).offset(20);
    }];
    
    [self.oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldPasswordLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [newPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldPasswordTextField.mas_bottom).offset(20);
        make.left.equalTo(self.formView).offset(20);
    }];
    
    [self.latestNewPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newPasswordLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [confirmPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.latestNewPasswordTextField.mas_bottom).offset(20);
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
    if (self.oldPasswordTextField.text.length == 0) {
        [self showAlert:@"请输入原密码"];
        return;
    }
    
    if (self.latestNewPasswordTextField.text.length == 0) {
        [self showAlert:@"请输入新密码"];
        return;
    }
    
    if (self.confirmPasswordTextField.text.length == 0) {
        [self showAlert:@"请确认新密码"];
        return;
    }
    
    if (![self.latestNewPasswordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self showAlert:@"两次输入的密码不一致"];
        return;
    }
    
    [self modifyPassword];
}

- (void)modifyPassword {
    [NetworkService showLoading];
    
    NSDictionary *params = @{
        @"oldPassword": self.oldPasswordTextField.text,
        @"newPassword": self.latestNewPasswordTextField.text
    };
    
    [[NetworkService sharedInstance] POST:@"/app/user/modifyPassword" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"密码修改失败，请重试"];
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
