#import "RealNameAuthViewController.h"
#import "NetworkService.h"
#import <Masonry/Masonry.h>

@interface RealNameAuthViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idCardTextField;
@property (nonatomic, strong) UIView *uploadView;
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, strong) UILabel *uploadLabel;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSString *uploadedImageUrl;

@end

@implementation RealNameAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self checkAuthStatus];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"实名认证";
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 头部视图
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.headerView.layer.cornerRadius = 16;
    [self.contentView addSubview:self.headerView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"实名认证";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:self.titleLabel];
    
    // 副标题
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = @"请填写真实身份信息";
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:self.subtitleLabel];
    
    // 表单视图
    self.formView = [[UIView alloc] init];
    self.formView.backgroundColor = [UIColor whiteColor];
    self.formView.layer.cornerRadius = 12;
    [self.contentView addSubview:self.formView];
    
    // 姓名输入框
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"真实姓名";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:nameLabel];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.placeholder = @"请输入真实姓名";
    self.nameTextField.font = [UIFont systemFontOfSize:16];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.formView addSubview:self.nameTextField];
    
    // 身份证号输入框
    UILabel *idCardLabel = [[UILabel alloc] init];
    idCardLabel.text = @"身份证号";
    idCardLabel.font = [UIFont systemFontOfSize:16];
    idCardLabel.textColor = [UIColor blackColor];
    [self.formView addSubview:idCardLabel];
    
    self.idCardTextField = [[UITextField alloc] init];
    self.idCardTextField.placeholder = @"请输入身份证号码";
    self.idCardTextField.font = [UIFont systemFontOfSize:16];
    self.idCardTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.idCardTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.formView addSubview:self.idCardTextField];
    
    // 上传区域
    self.uploadView = [[UIView alloc] init];
    self.uploadView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.uploadView.layer.cornerRadius = 8;
    self.uploadView.layer.borderWidth = 1;
    self.uploadView.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
    [self.formView addSubview:self.uploadView];
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadButton setImage:[UIImage systemImageNamed:@"camera"] forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:[UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.uploadButton addTarget:self action:@selector(uploadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadView addSubview:self.uploadButton];
    
    self.uploadLabel = [[UILabel alloc] init];
    self.uploadLabel.text = @"点击上传身份证照片";
    self.uploadLabel.font = [UIFont systemFontOfSize:14];
    self.uploadLabel.textColor = [UIColor lightGrayColor];
    self.uploadLabel.textAlignment = NSTextAlignmentCenter;
    [self.uploadView addSubview:self.uploadLabel];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"提交认证" forState:UIControlStateNormal];
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
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(100);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(20);
        make.top.equalTo(self.headerView).offset(20);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.formView).offset(20);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom).offset(20);
        make.left.equalTo(self.formView).offset(20);
    }];
    
    [self.idCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idCardLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idCardTextField.mas_bottom).offset(20);
        make.left.right.equalTo(self.formView).inset(20);
        make.height.mas_equalTo(120);
        make.bottom.equalTo(self.formView).offset(-20);
    }];
    
    [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.uploadView);
        make.centerY.equalTo(self.uploadView).offset(-10);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.uploadView);
        make.top.equalTo(self.uploadButton.mas_bottom).offset(10);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.formView.mas_bottom).offset(30);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)checkAuthStatus {
    [NetworkService showLoading];
    
    [[NetworkService sharedInstance] GET:@"/app/userinfo/auth/status" 
                                   params:nil 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleAuthStatus:response[@"data"] ?: @{}];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"获取认证状态失败"];
        });
    }];
}

- (void)handleAuthStatus:(NSDictionary *)data {
    NSInteger status = [data[@"status"] integerValue];
    
    if (status == 1) {
        // 已认证
        [self showAuthSuccess];
    } else if (status == 2) {
        // 认证中
        [self showAuthPending];
    } else {
        // 未认证，显示表单
        self.formView.hidden = NO;
        self.submitButton.hidden = NO;
    }
}

- (void)showAuthSuccess {
    self.formView.hidden = YES;
    self.submitButton.hidden = YES;
    
    UIView *successView = [[UIView alloc] init];
    successView.backgroundColor = [UIColor whiteColor];
    successView.layer.cornerRadius = 12;
    [self.contentView addSubview:successView];
    
    UIImageView *successImageView = [[UIImageView alloc] init];
    successImageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
    successImageView.tintColor = [UIColor systemGreenColor];
    [successView addSubview:successImageView];
    
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"实名认证成功";
    successLabel.font = [UIFont boldSystemFontOfSize:18];
    successLabel.textColor = [UIColor blackColor];
    successLabel.textAlignment = NSTextAlignmentCenter;
    [successView addSubview:successLabel];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"您的身份信息已通过验证";
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = [UIColor lightGrayColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [successView addSubview:infoLabel];
    
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(200);
    }];
    
    [successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.equalTo(successView).offset(30);
        make.width.height.mas_equalTo(60);
    }];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.equalTo(successImageView.mas_bottom).offset(20);
    }];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.equalTo(successLabel.mas_bottom).offset(10);
    }];
}

- (void)showAuthPending {
    self.formView.hidden = YES;
    self.submitButton.hidden = YES;
    
    UIView *pendingView = [[UIView alloc] init];
    pendingView.backgroundColor = [UIColor whiteColor];
    pendingView.layer.cornerRadius = 12;
    [self.contentView addSubview:pendingView];
    
    UIImageView *pendingImageView = [[UIImageView alloc] init];
    pendingImageView.image = [UIImage systemImageNamed:@"clock.fill"];
    pendingImageView.tintColor = [UIColor systemOrangeColor];
    [pendingView addSubview:pendingImageView];
    
    UILabel *pendingLabel = [[UILabel alloc] init];
    pendingLabel.text = @"认证审核中";
    pendingLabel.font = [UIFont boldSystemFontOfSize:18];
    pendingLabel.textColor = [UIColor blackColor];
    pendingLabel.textAlignment = NSTextAlignmentCenter;
    [pendingView addSubview:pendingLabel];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"请耐心等待审核结果";
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = [UIColor lightGrayColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [pendingView addSubview:infoLabel];
    
    [pendingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(200);
    }];
    
    [pendingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pendingView);
        make.top.equalTo(pendingView).offset(30);
        make.width.height.mas_equalTo(60);
    }];
    
    [pendingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pendingView);
        make.top.equalTo(pendingImageView.mas_bottom).offset(20);
    }];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pendingView);
        make.top.equalTo(pendingLabel.mas_bottom).offset(10);
    }];
}

- (void)uploadButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片来源" 
                                                                   message:nil 
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"从相册选择" 
                                                                 style:UIAlertActionStyleDefault 
                                                               handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:nil];
    
    [alert addAction:cameraAction];
    [alert addAction:photoLibraryAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showAlert:@"设备不支持拍照功能"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)submitButtonTapped {
    if (self.nameTextField.text.length == 0) {
        [self showAlert:@"请输入真实姓名"];
        return;
    }
    
    if (self.idCardTextField.text.length == 0) {
        [self showAlert:@"请输入身份证号码"];
        return;
    }
    
    if (!self.uploadedImageUrl) {
        [self showAlert:@"请上传身份证照片"];
        return;
    }
    
    [self submitAuth];
}

- (void)submitAuth {
    [NetworkService showLoading];
    
    NSDictionary *params = @{
        @"realName": self.nameTextField.text,
        @"idCard": self.idCardTextField.text,
        @"idCardImage": self.uploadedImageUrl
    };
    
    [[NetworkService sharedInstance] POST:@"/app/userinfo/auth/submit" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"认证信息提交成功，请等待审核"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"提交失败，请重试"];
        });
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:selectedImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image {
    [NetworkService showLoading];

    
    [[NetworkService sharedInstance] uploadImage:image
                                        success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *imageUrl = response[@"data"][@"url"];
            self.uploadedImageUrl = imageUrl;
            [self.uploadButton setImage:image forState:UIControlStateNormal];
            self.uploadLabel.text = @"身份证照片已上传";
            self.uploadLabel.textColor = [UIColor systemGreenColor];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"图片上传失败，请重试"];
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
