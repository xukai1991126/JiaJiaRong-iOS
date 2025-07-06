#import "UserInfoViewController.h"
#import "NetworkService.h"
#import <Masonry/Masonry.h>

@interface UserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate> 

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self fetchUserInfo];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"个人信息";
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 头像区域
    self.avatarView = [[UIView alloc] init];
    self.avatarView.backgroundColor = [UIColor whiteColor];
    self.avatarView.layer.cornerRadius = 12;
    [self.contentView addSubview:self.avatarView];
    
    UILabel *avatarLabel = [[UILabel alloc] init];
    avatarLabel.text = @"头像";
    avatarLabel.font = [UIFont systemFontOfSize:16];
    avatarLabel.textColor = [UIColor blackColor];
    [self.avatarView addSubview:avatarLabel];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage systemImageNamed:@"person.circle.fill"];
    self.avatarImageView.tintColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImageView.layer.cornerRadius = 30;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.avatarView addSubview:self.avatarImageView];
    
    UIButton *changeAvatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeAvatarButton setTitle:@"更换头像" forState:UIControlStateNormal];
    [changeAvatarButton setTitleColor:[UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    changeAvatarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [changeAvatarButton addTarget:self action:@selector(changeAvatarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.avatarView addSubview:changeAvatarButton];
    
    // 信息区域
    self.infoView = [[UIView alloc] init];
    self.infoView.backgroundColor = [UIColor whiteColor];
    self.infoView.layer.cornerRadius = 12;
    [self.contentView addSubview:self.infoView];
    
    // 昵称
    UILabel *nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.text = @"昵称";
    nicknameLabel.font = [UIFont systemFontOfSize:16];
    nicknameLabel.textColor = [UIColor blackColor];
    [self.infoView addSubview:nicknameLabel];
    
    self.nicknameTextField = [[UITextField alloc] init];
    self.nicknameTextField.placeholder = @"请输入昵称";
    self.nicknameTextField.font = [UIFont systemFontOfSize:16];
    self.nicknameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.infoView addSubview:self.nicknameTextField];
    
    // 手机号
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"手机号";
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.textColor = [UIColor blackColor];
    [self.infoView addSubview:phoneLabel];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入手机号";
    self.phoneTextField.font = [UIFont systemFontOfSize:16];
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.infoView addSubview:self.phoneTextField];
    
    // 邮箱
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.text = @"邮箱";
    emailLabel.font = [UIFont systemFontOfSize:16];
    emailLabel.textColor = [UIColor blackColor];
    [self.infoView addSubview:emailLabel];
    
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.placeholder = @"请输入邮箱";
    self.emailTextField.font = [UIFont systemFontOfSize:16];
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.infoView addSubview:self.emailTextField];
    
    // 保存按钮
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.saveButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.saveButton.layer.cornerRadius = 25;
    [self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.saveButton];
    
    // 设置约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(80);
    }];
    
    [avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView).offset(20);
        make.centerY.equalTo(self.avatarView);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(changeAvatarButton.mas_left).offset(-20);
        make.centerY.equalTo(self.avatarView);
        make.width.height.mas_equalTo(60);
    }];
    
    [changeAvatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarView).offset(-20);
        make.centerY.equalTo(self.avatarView);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
    }];
    
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.infoView).offset(20);
    }];
    
    [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nicknameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.infoView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameTextField.mas_bottom).offset(20);
        make.left.equalTo(self.infoView).offset(20);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.infoView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(20);
        make.left.equalTo(self.infoView).offset(20);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.infoView).inset(20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.infoView).offset(-20);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(30);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)fetchUserInfo {
    [NetworkService showLoading];
    
    [[NetworkService sharedInstance] GET:@"/app/userinfo/profile" 
                                   params:nil 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleUserInfo:response[@"data"] ?: @{}];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"获取用户信息失败"];
        });
    }];
}

- (void)handleUserInfo:(NSDictionary *)userInfo {
    self.userInfo = userInfo;
    
    self.nicknameTextField.text = userInfo[@"nickname"] ?: @"";
    self.phoneTextField.text = userInfo[@"phone"] ?: @"";
    self.emailTextField.text = userInfo[@"email"] ?: @"";
    
    // 如果有头像URL，加载头像
    if (userInfo[@"avatar"]) {
        // 这里可以使用SDWebImage加载网络图片
        // [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo[@"avatar"]]];
    }
}

- (void)changeAvatarButtonTapped {
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

- (void)saveButtonTapped {
    [self saveUserInfo];
}

- (void)saveUserInfo {
    [NetworkService showLoading];
    
    NSDictionary *params = @{
        @"nickname": self.nicknameTextField.text ?: @"",
        @"phone": self.phoneTextField.text ?: @"",
        @"email": self.emailTextField.text ?: @""
    };
    
    [[NetworkService sharedInstance] POST:@"/app/userinfo/update" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"保存成功"];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"保存失败，请重试"];
        });
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadAvatar:selectedImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadAvatar:(UIImage *)image {
    [NetworkService showLoading];
    
    
    [[NetworkService sharedInstance] uploadImage:image 
                                        success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.avatarImageView.image = image;
            [self showAlert:@"头像上传成功"];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"头像上传失败，请重试"];
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
