//
//  JJRIdCardViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRIdCardViewController.h"
#import "JJRIdCardView.h"
#import "JJRIdCardModel.h"
#import "JJRNetworkService.h"
#import "JJRShouquanshuViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>

@interface JJRIdCardViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) JJRIdCardView *idCardView;
@property (nonatomic, strong) JJRIdCardModel *form;
@property (nonatomic, copy) NSString *faceImagePath;
@property (nonatomic, copy) NSString *backImagePath;
@property (nonatomic, copy) NSString *certifyData;
@property (nonatomic, copy) NSString *metaInfo;

@end

@implementation JJRIdCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self checkPermissions];
}

- (void)setupUI {
    self.title = @"身份证认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.idCardView = [[JJRIdCardView alloc] init];
    self.idCardView.delegate = self;
    [self.view addSubview:self.idCardView];
    
    [self.idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
        make.left.right.equalTo(self.view);
    }];
}

- (void)setupData {
    self.form = [[JJRIdCardModel alloc] init];
    self.idCardView.form = self.form;
    self.idCardView.currentStep = JJRIdCardStepUpload;
}

- (void)checkPermissions {
    // 检查相机权限
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showPermissionAlert];
                });
            }
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self showPermissionAlert];
    }
    
    // 检查相册权限
    PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
    if (photoStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status != PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showPermissionAlert];
                });
            }
        }];
    } else if (photoStatus != PHAuthorizationStatusAuthorized) {
        [self showPermissionAlert];
    }
}

- (void)showPermissionAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限申请说明"
                                                                   message:@"佳佳融对照片/相机/摄像头权限申请说明：便于您使用该功能上传您的照片/图片及用于实名认证或人脸识别场景中读取和写入相册和文件内容。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - JJRIdCardViewDelegate

- (void)idCardViewDidTapUpload:(UIImageView *)imageView type:(NSString *)type {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片来源"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCameraForType:type];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openAlbumForType:type];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cameraAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)idCardViewDidTapNextStep {
    // 验证表单
    if (!self.form.faceImage || self.form.faceImage.length == 0) {
        [self showToast:@"请上传身份证人像面"];
        return;
    }
    
    if (!self.form.backImage || self.form.backImage.length == 0) {
        [self showToast:@"请上传身份证国徽面"];
        return;
    }
    
    // 上传身份证信息
    [self uploadIdCardInfo];
}

- (void)idCardViewDidTapFaceVerify {
    if (!self.idCardView.isAgreementChecked) {
        [self showToast:@"请同意并勾选协议"];
        return;
    }
    
    // 开始人脸识别
    [self startFaceVerify];
}

- (void)idCardViewDidTapAgreement:(NSString *)type {
    // 跳转到协议页面
    [self openAgreement:type];
}

- (void)idCardViewDidTapGoShouquanshu {
    // 跳转到授权书页面
    JJRShouquanshuViewController *shouquanshuVC = [[JJRShouquanshuViewController alloc] init];
    shouquanshuVC.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
    [self.navigationController pushViewController:shouquanshuVC animated:YES];
}

- (void)idCardViewDidChangeForm:(JJRIdCardModel *)form {
    self.form = form;
}

#pragma mark - Private Methods

- (void)openCameraForType:(NSString *)type {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showToast:@"设备不支持拍照"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)openAlbumForType:(NSString *)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)uploadIdCardInfo {
    [JJRNetworkService showLoading];
    
    // 构建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"idName"] = self.form.idName ?: @"";
    params[@"idNo"] = self.form.idNo ?: @"";
    params[@"address"] = self.form.address ?: @"";
    params[@"backImage"] = self.form.backImage ?: @"";
    params[@"birthDate"] = self.form.birthDate ?: @"";
    params[@"ethnicity"] = self.form.ethnicity ?: @"";
    params[@"faceImage"] = self.form.faceImage ?: @"";
    params[@"issueAuthority"] = self.form.issueAuthority ?: @"";
    params[@"sex"] = self.form.sex ?: @"";
    params[@"validPeriod"] = self.form.validPeriod ?: @"";
    
    [[JJRNetworkService sharedInstance] verifyIdCardWithParams:params success:^(NSDictionary *responseObject) {
        [JJRNetworkService hideLoading];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            // 上传成功，进入人脸识别步骤
            [self.idCardView setStep:JJRIdCardStepFaceVerify animated:YES];
        } else {
            [self showToast:responseObject[@"msg"] ?: @"上传失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [self showToast:@"网络错误，请重试"];
    }];
}

- (void)startFaceVerify {
    [JJRNetworkService showLoading];
    
    // 获取设备信息
    NSString *metaInfo = [self getMetaInfo];
    
    NSDictionary *params = @{
        @"metaInfo": metaInfo ?: @""
    };
    
    [[JJRNetworkService sharedInstance] realNameAuthWithParams:params success:^(NSDictionary *responseObject) {
        [JJRNetworkService hideLoading];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            self.certifyData = responseObject[@"data"][@"certifyData"];
            self.metaInfo = metaInfo;
            
            // 调用人脸识别SDK
            [self callFaceVerifySDK];
        } else {
            [self showToast:responseObject[@"msg"] ?: @"人脸识别初始化失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [self showToast:@"网络错误，请重试"];
    }];
}

- (void)callFaceVerifySDK {
    // 这里需要集成具体的人脸识别SDK
    // 示例代码，实际需要根据SDK文档实现
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 模拟人脸识别成功
        [self faceVerifySuccess];
    });
}

- (void)faceVerifySuccess {
    [JJRNetworkService showLoading];
    
    NSDictionary *params = @{
        @"certifyData": self.certifyData ?: @"",
        @"metaInfo": self.metaInfo ?: @""
    };
    
    [[JJRNetworkService sharedInstance] realNameAuthWithParams:params success:^(NSDictionary *responseObject) {
        [JJRNetworkService hideLoading];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            // 人脸识别成功，显示结果页
            [self.idCardView setStep:JJRIdCardStepResult animated:YES];
            [self.idCardView showResult:YES];
        } else {
            [self showToast:responseObject[@"msg"] ?: @"人脸识别失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [self showToast:@"网络错误，请重试"];
    }];
}

- (NSString *)getMetaInfo {
    // 获取设备信息，实际需要根据SDK要求实现
    NSDictionary *deviceInfo = @{
        @"platform": @"ios",
        @"version": [[UIDevice currentDevice] systemVersion],
        @"model": [[UIDevice currentDevice] model]
    };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deviceInfo options:0 error:&error];
    if (error) {
        return @"";
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)openAgreement:(NSString *)type {
    // 跳转到协议页面
    // 这里需要根据type跳转到对应的协议页面
    NSLog(@"打开协议: %@", type);
}

- (void)showToast:(NSString *)message {
    // 显示提示信息
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    // 保存图片到本地
    NSString *fileName = [NSString stringWithFormat:@"idcard_%ld.jpg", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    [imageData writeToFile:filePath atomically:YES];
    
    // 更新UI
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 拍照
        [self.idCardView setFaceImage:image];
        self.form.faceImage = filePath;
    } else {
        // 相册选择
        [self.idCardView setBackImage:image];
        self.form.backImage = filePath;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end 
