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
#import "JJRFaceVerifyManager.h"
#import "WebViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@interface JJRIdCardViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,JJRFaceVerifyManagerDelegate>

@property (nonatomic, strong) JJRIdCardView *idCardView;
@property (nonatomic, strong) JJRIdCardModel *form;
@property (nonatomic, copy) NSString *faceImagePath;
@property (nonatomic, copy) NSString *backImagePath;
@property (nonatomic, copy) NSString *certifyData;
@property (nonatomic, copy) NSString *metaInfo;
@property (nonatomic, copy) NSString *currentUploadType; // 记录当前上传的图片类型
@property (nonatomic, strong) JJRFaceVerifyManager *faceVerifyManager; // 人脸识别管理器
@property (nonatomic, strong) NSDictionary *certifyInfo; // 人脸识别认证信息

@end

@implementation JJRIdCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self checkPermissions];
    [self setupFaceVerifyManager];
}

- (void)setupUI {
    self.title = @"身份证";
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
        [JJRToastTool showToast:@"请上传身份证人像面"];
        return;
    }
    
    if (!self.form.backImage || self.form.backImage.length == 0) {
        [JJRToastTool showToast:@"请上传身份证国徽面"];
        return;
    }
    
    // 上传身份证信息
    [self uploadIdCardInfo];
}

- (void)idCardViewDidTapFaceVerify {
    if (!self.idCardView.isAgreementChecked) {
        [JJRToastTool showToast:@"请同意并勾选协议"];
        return;
    }
    
    // 开始人脸识别
    [self startFaceVerify];
}

- (void)idCardViewDidTapAgreement:(NSString *)type title:(NSString *)title {
    // 跳转到协议页面
    [self openAgreement:type title:title];
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
        [JJRToastTool showToast:@"设备不支持拍照"];
        return;
    }
    
    // 记录当前上传的图片类型
    self.currentUploadType = type;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)openAlbumForType:(NSString *)type {
    // 记录当前上传的图片类型
    self.currentUploadType = type;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)uploadIdCardInfo {
    [JJRNetworkService showLoading];
    
    // 构建请求参数 - 使用与uni-app相同的字段结构
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
    
    // 调用正确的保存接口
    [[JJRNetworkService sharedInstance] saveIdCardInfoWithParams:params success:^(NSDictionary *responseObject) {
        [JJRNetworkService hideLoading];
        
        if ([responseObject[@"code"] integerValue] == 0) {
            // 保存成功，进入人脸识别步骤
            [JJRToastTool showSuccess:@"上传成功"];
            
            // 延迟跳转到人脸识别页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.idCardView setStep:JJRIdCardStepFaceVerify animated:YES];
            });
        } else {
            [JJRToastTool showError:responseObject[@"err"][@"msg"] ?: @"保存失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        NSString *errorMessage = error.localizedDescription;
        if (!errorMessage || errorMessage.length == 0) {
            errorMessage = @"网络错误，请重试";
        }
        [JJRToastTool showError:errorMessage];
    }];
}

- (void)setupFaceVerifyManager {
    // 初始化人脸识别管理器
    self.faceVerifyManager = [JJRFaceVerifyManager sharedManager];
    self.faceVerifyManager.delegate = self;
    self.faceVerifyManager.presentingViewController = self;
    
    // 初始化阿里云SDK
    [self.faceVerifyManager initializeSDK];
    
    NSLog(@"🎯 人脸识别管理器初始化完成");
}

- (void)startFaceVerify {
    // 获取设备信息
    NSDictionary *metaInfoDict = [self.faceVerifyManager getMetaInfo];
    
    // 将设备信息转换为JSON字符串（与uni-app保持一致）
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:metaInfoDict options:0 error:&error];
    NSString *metaInfo = @"";
    if (!error && jsonData) {
        metaInfo = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    [JJRNetworkService showLoading];
    
    // 调用后台初始化人脸识别接口
    [[JJRNetworkService sharedInstance] initFaceVerifyWithParams:@{@"metaInfo": metaInfo} success:^(NSDictionary *responseObject) {
        [JJRNetworkService hideLoading];
        
        if ([responseObject[@"code"] integerValue] == 0) {
            // 保存认证信息
            self.certifyInfo = responseObject[@"data"];
            NSString *certifyId = self.certifyInfo[@"certifyId"];
            
            if (certifyId && certifyId.length > 0) {
                // 配置extParams，必须传入当前控制器
                NSMutableDictionary *extParams = [NSMutableDictionary dictionary];
                [extParams setValue:self forKey:@"currentCtr"];
                
                // 调用人脸识别SDK
                [self.faceVerifyManager startFaceVerifyWithCertifyId:certifyId extParams:extParams];
            } else {
                [JJRToastTool showError:@"认证ID获取失败"];
            }
        } else {
            [JJRToastTool showError:responseObject[@"err"][@"msg"] ?: @"人脸识别初始化失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        NSString *errorMessage = error.localizedDescription;
        if (!errorMessage || errorMessage.length == 0) {
            errorMessage = @"网络错误，请重试";
        }
        [JJRToastTool showError:errorMessage];
    }];
}

#pragma mark - JJRFaceVerifyManagerDelegate

- (void)faceVerifyManager:(JJRFaceVerifyManager *)manager 
        didCompleteWithResult:(JJRFaceVerifyResult)result 
                      message:(NSString *)message {
    
    NSLog(@"🎯 人脸识别结果: %ld, 消息: %@", (long)result, message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result == JJRFaceVerifyResultSuccess) {
            // 人脸识别成功
            [JJRToastTool showSuccess:@"人脸识别成功"];
            
            // 延迟显示结果页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.idCardView setStep:JJRIdCardStepResult animated:YES];
                [self.idCardView showResult:YES];
            });
        } else {
            // 人脸识别失败
            [JJRToastTool showError:message];
        }
    });
}

- (void)faceVerifyManager:(JJRFaceVerifyManager *)manager 
             didProgress:(CGFloat)progress 
                     tip:(NSString *)tip {
    NSLog(@"🎯 人脸识别进度: %.2f, 提示: %@", progress, tip);
}

- (void)openAgreement:(NSString *)type title:(NSString *)title {
    NSLog(@"🎯 打开协议页面: %@", title);
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.agreementType = type;
    webVC.title = title;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        // 先更新UI显示图片
        if ([self.currentUploadType isEqualToString:@"face"]) {
            [self.idCardView setFaceImage:image];
        } else if ([self.currentUploadType isEqualToString:@"back"]) {
            [self.idCardView setBackImage:image];
        }
        
        // 开始上传和识别流程
        [self uploadAndRecognizeImage:image forType:self.currentUploadType];
    }];
}

- (void)uploadAndRecognizeImage:(UIImage *)image forType:(NSString *)type {
    [JJRNetworkService showLoading];
    
    // 第一步：上传图片到服务器
    [[JJRNetworkService sharedInstance] uploadIdCardImage:image success:^(NSDictionary *responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSString *imageUrl = responseObject[@"data"];
            if (imageUrl && imageUrl.length > 0) {
                // 第二步：调用OCR识别接口
                [self recognizeIdCardWithImageUrl:imageUrl forType:type];
            } else {
                [JJRNetworkService hideLoading];
                NSString *errorMessage = responseObject[@"err"][@"msg"] ?: @"图片上传失败，请重试";
                [JJRToastTool showError:errorMessage];
            }
        } else {
            [JJRNetworkService hideLoading];
            [JJRToastTool showError:responseObject[@"msg"] ?: @"图片上传失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        NSString *errorMessage = error.localizedDescription;
        if (!errorMessage || errorMessage.length == 0) {
            errorMessage = @"网络错误，请重试";
        }
        [JJRToastTool showError:errorMessage];
    }];
}

- (void)recognizeIdCardWithImageUrl:(NSString *)imageUrl forType:(NSString *)type {
    if ([type isEqualToString:@"face"]) {
        // 识别身份证人像面
        [[JJRNetworkService sharedInstance] recognizeIdCardFaceWithImageUrl:imageUrl success:^(NSDictionary *responseObject) {
            [JJRNetworkService hideLoading];
            
            if ([responseObject[@"code"] integerValue] == 0) {
                // 解析识别结果并更新表单
                NSDictionary *data = responseObject[@"data"];
                NSLog(@"🎯 人像面OCR识别结果: %@", data);
                
                self.form.faceImage = imageUrl;
                self.form.idName = data[@"name"] ?: @"";
                self.form.idNo = data[@"idNumber"] ?: @"";
                self.form.address = data[@"address"] ?: @"";
                self.form.birthDate = data[@"birthDate"] ?: @"";
                self.form.ethnicity = data[@"ethnicity"] ?: @"";
                self.form.sex = data[@"sex"] ?: @"";
                
                NSLog(@"🎯 设置到模型:");
                NSLog(@"🎯 姓名: %@", self.form.idName);
                NSLog(@"🎯 身份证号: %@", self.form.idNo);
                NSLog(@"🎯 地址: %@", self.form.address);
                
                // 更新视图显示识别结果
                [self.idCardView updateFormWithData:self.form];
            } else {
                NSLog(@"🎯 人像面OCR识别失败: %@", responseObject[@"err"][@"msg"]);
                [JJRToastTool showError:responseObject[@"err"][@"msg"] ?: @"身份证识别失败，请重新上传"];
                // 清空图片
                self.form.faceImage = @"";
                [self.idCardView setFaceImage:[UIImage imageNamed:@"idcard_face_placeholder"]];
            }
        } failure:^(NSError *error) {
            [JJRNetworkService hideLoading];
            NSString *errorMessage = error.localizedDescription;
            if (!errorMessage || errorMessage.length == 0) {
                errorMessage = @"网络错误，请重试";
            }
            [JJRToastTool showError:errorMessage];
        }];
    } else if ([type isEqualToString:@"back"]) {
        // 识别身份证国徽面
        [[JJRNetworkService sharedInstance] recognizeIdCardBackWithImageUrl:imageUrl success:^(NSDictionary *responseObject) {
            [JJRNetworkService hideLoading];
            
            if ([responseObject[@"code"] integerValue] == 0) {
                // 解析识别结果并更新表单
                NSDictionary *data = responseObject[@"data"];
                NSLog(@"🎯 国徽面OCR识别结果: %@", data);
                
                self.form.backImage = imageUrl;
                self.form.issueAuthority = data[@"issueAuthority"] ?: @"";
                self.form.validPeriod = data[@"validPeriod"] ?: @"";
                
                NSLog(@"🎯 设置到模型:");
                NSLog(@"🎯 签发机关: %@", self.form.issueAuthority);
                NSLog(@"🎯 有效期: %@", self.form.validPeriod);
                
                // 更新视图显示识别结果
                [self.idCardView updateFormWithData:self.form];
            } else {
                NSLog(@"🎯 国徽面OCR识别失败: %@", responseObject[@"err"][@"msg"]);
                [JJRToastTool showError:responseObject[@"err"][@"msg"] ?: @"身份证识别失败，请重新上传"];
                // 清空图片
                self.form.backImage = @"";
                [self.idCardView setBackImage:[UIImage imageNamed:@"idcard_back_placeholder"]];
            }
        } failure:^(NSError *error) {
            [JJRNetworkService hideLoading];
            NSString *errorMessage = error.localizedDescription;
            if (!errorMessage || errorMessage.length == 0) {
                errorMessage = @"网络错误，请重试";
            }
            [JJRToastTool showError:errorMessage];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end 
