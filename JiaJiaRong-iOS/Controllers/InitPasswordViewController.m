#import "InitPasswordViewController.h"
#import "JJRNetworkService.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "ToastTool.h"
#import "JJRUserManager.h"

@interface InitPasswordViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
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
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 大标题 - 对应uni-app的"初始化密码"
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"初始化密码";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20]; // 40rpx ≈ 20pt
    self.titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.titleLabel];
    
    // 描述文字 - 对应uni-app的"由8-16位数字及字母组成"
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.text = @"由8-16位数字及字母组成";
    self.descLabel.font = [UIFont systemFontOfSize:14]; // 28rpx ≈ 14pt
    self.descLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.descLabel];
    
    // 密码输入框 - 对应uni-app的"请输入新密码"
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"请输入新密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:14];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];

    self.passwordTextField.layer.cornerRadius = 6;
    self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.passwordTextField];
    
    // 确认密码输入框 - 对应uni-app的"请再次输入新密码"
    self.confirmPasswordTextField = [[UITextField alloc] init];
    self.confirmPasswordTextField.placeholder = @"请再次输入新密码";
    self.confirmPasswordTextField.font = [UIFont systemFontOfSize:14];
    self.confirmPasswordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.confirmPasswordTextField.layer.cornerRadius = 6;
    self.confirmPasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.confirmPasswordTextField];
    
    // 提交按钮 - 对应uni-app的"确认提交"
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:14]; // 28rpx ≈ 14pt
    self.submitButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"]; // #3B4FDE
    self.submitButton.layer.cornerRadius = 23;
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
    
    // 标题 - 距离顶部30rpx ≈ 15pt
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15); // 30rpx ≈ 15pt
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    // 描述文字 - 距离标题20rpx ≈ 10pt
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    // 密码输入框 - 距离描述文字20rpx ≈ 10pt
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(46); // 对应uni-app的46px
    }];
    
    // 确认密码输入框 - 紧贴密码输入框
    [self.confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.passwordTextField);
    }];
    
    // 提交按钮 - 距离确认密码框20rpx ≈ 10pt，高度92rpx ≈ 46pt
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordTextField.mas_bottom).offset(10);
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(46);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)submitButtonTapped {
    if (self.passwordTextField.text.length == 0) {
        [ToastTool showToast:@"请输入新密码" inView:self.view];
        return;
    }
    
    // 密码格式验证：8-16位数字及字母组成
    if (self.passwordTextField.text.length < 8 || self.passwordTextField.text.length > 16) {
        [ToastTool showToast:@"密码长度必须为8-16位" inView:self.view];
        return;
    }
    
    // 检查密码是否包含数字和字母
    NSString *passwordRegex = @"^(?=.*\\d)(?=.*[a-zA-Z])[a-zA-Z\\d]{8,16}$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    if (![passwordPredicate evaluateWithObject:self.passwordTextField.text]) {
        [ToastTool showToast:@"密码必须由8-16位数字及字母组成" inView:self.view];
        return;
    }
    
    if (self.confirmPasswordTextField.text.length == 0) {
        [ToastTool showToast:@"请确认新密码" inView:self.view];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [ToastTool showToast:@"两次输入的密码不一致" inView:self.view];
        return;
    }
    
    [self initPassword];
}

- (void)initPassword {
    [JJRNetworkService showLoading];
    
    NSDictionary *params = @{@"pwd": self.passwordTextField.text,@"checkPwd": self.confirmPasswordTextField.text};
    
    [[JJRNetworkService sharedInstance] initPasswordWithParams:params 
                                                       success:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ToastTool showToastInKeWindow:@"密码设置成功"];
            // 更新用户信息
            NSDictionary *userInfo = [[JJRUserManager sharedManager] userInfo];
            NSMutableDictionary *updatedUserInfo = [userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
            updatedUserInfo[@"initPwd"] = @YES;
            [[JJRUserManager sharedManager] updateUserInfo:updatedUserInfo];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ToastTool showToast:@"密码设置失败，请重试" inView:self.view];
        });
    }];
}



@end 
