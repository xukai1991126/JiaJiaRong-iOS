#import "BankCardAddViewController.h"
#import "NetworkService.h"
#import <Masonry/Masonry.h>

@interface BankCardAddViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, strong) UITextField *cardNumberTextField;
@property (nonatomic, strong) UITextField *holderNameTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation BankCardAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"添加银行卡";
    
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
    
    // 卡号输入框
    UILabel *cardNumberLabel = [[UILabel alloc] init];
    cardNumberLabel.text = @"银行卡号";
    cardNumberLabel.font = [UIFont systemFontOfSize:16];
    cardNumberLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:cardNumberLabel];
    
    self.cardNumberTextField = [[UITextField alloc] init];
    self.cardNumberTextField.placeholder = @"请输入银行卡号";
    self.cardNumberTextField.font = [UIFont systemFontOfSize:16];
    self.cardNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.formView addSubview:self.cardNumberTextField];
    
    // 持卡人姓名
    UILabel *holderNameLabel = [[UILabel alloc] init];
    holderNameLabel.text = @"持卡人姓名";
    holderNameLabel.font = [UIFont systemFontOfSize:16];
    holderNameLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:holderNameLabel];
    
    self.holderNameTextField = [[UITextField alloc] init];
    self.holderNameTextField.placeholder = @"请输入持卡人姓名";
    self.holderNameTextField.font = [UIFont systemFontOfSize:16];
    self.holderNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.formView addSubview:self.holderNameTextField];
    
    // 手机号
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"预留手机号";
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:phoneLabel];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入银行预留手机号";
    self.phoneTextField.font = [UIFont systemFontOfSize:16];
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.formView addSubview:self.phoneTextField];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"添加银行卡" forState:UIControlStateNormal];
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
    
    [cardNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.formView).offset(20);
    }];
    
    [self.cardNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNumberLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [holderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardNumberTextField.mas_bottom).offset(20);
        make.left.equalTo(self.formView).offset(20);
    }];
    
    [self.holderNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holderNameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderNameTextField.mas_bottom).offset(20);
        make.left.equalTo(self.formView).offset(20);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).offset(10);
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
    if (self.cardNumberTextField.text.length == 0) {
        [self showAlert:@"请输入银行卡号"];
        return;
    }
    
    if (self.holderNameTextField.text.length == 0) {
        [self showAlert:@"请输入持卡人姓名"];
        return;
    }
    
    if (self.phoneTextField.text.length == 0) {
        [self showAlert:@"请输入预留手机号"];
        return;
    }
    
    if (self.phoneTextField.text.length != 11) {
        [self showAlert:@"请输入正确的手机号"];
        return;
    }
    
    [self addBankCard];
}

- (void)addBankCard {
    [NetworkService showLoading];
    
    NSDictionary *params = @{
        @"cardNo": self.cardNumberTextField.text,
        @"holderName": self.holderNameTextField.text,
        @"phone": self.phoneTextField.text
    };
    
    [[NetworkService sharedInstance] POST:@"/app/userinfo/bankcard/add" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"银行卡添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"添加失败，请重试"];
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