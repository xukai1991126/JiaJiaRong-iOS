#import "FeedbackViewController.h"
#import "NetworkService.h"
#import <Masonry/Masonry.h>

@interface FeedbackViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UITextField *contactTextField;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"意见反馈";
    
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
    
    // 反馈内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"反馈内容";
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:contentLabel];
    
    UIView *textViewContainer = [[UIView alloc] init];
    textViewContainer.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    textViewContainer.layer.cornerRadius = 8;
    [self.formView addSubview:textViewContainer];
    
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.font = [UIFont systemFontOfSize:16];
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.delegate = self;
    [textViewContainer addSubview:self.contentTextView];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"请详细描述您遇到的问题或建议...";
    self.placeholderLabel.font = [UIFont systemFontOfSize:16];
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    [textViewContainer addSubview:self.placeholderLabel];
    
    // 联系方式
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.text = @"联系方式（选填）";
    contactLabel.font = [UIFont systemFontOfSize:16];
    contactLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:contactLabel];
    
    self.contactTextField = [[UITextField alloc] init];
    self.contactTextField.placeholder = @"请输入您的手机号或邮箱";
    self.contactTextField.font = [UIFont systemFontOfSize:16];
    self.contactTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.formView addSubview:self.contactTextField];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"提交反馈" forState:UIControlStateNormal];
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
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.formView).offset(20);
    }];
    
    [textViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(120);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(textViewContainer).inset(10);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(textViewContainer).offset(15);
    }];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textViewContainer.mas_bottom).offset(20);
        make.left.equalTo(self.formView).offset(20);
    }];
    
    [self.contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactLabel.mas_bottom).offset(10);
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
    if (self.contentTextView.text.length == 0) {
        [self showAlert:@"请输入反馈内容"];
        return;
    }
    
    [self submitFeedback];
}

- (void)submitFeedback {
    [NetworkService showLoading];
    
    NSDictionary *params = @{
        @"content": self.contentTextView.text,
        @"contact": self.contactTextField.text ?: @""
    };
    
    [[NetworkService sharedInstance] POST:@"/app/feedback/submit" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"反馈提交成功，感谢您的建议"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"提交失败，请重试"];
        });
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
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