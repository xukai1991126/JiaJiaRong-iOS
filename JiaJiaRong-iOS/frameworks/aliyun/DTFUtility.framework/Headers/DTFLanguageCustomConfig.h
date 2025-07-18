//
//  DTFLanguageCustomConfig.h
//  DTFUtility
//
//  Created by 汪澌哲 on 2024/1/8.
//  Copyright © 2024 com.alipay.iphoneclient.zoloz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface DTFLanguageCustomGuideConfig : NSObject

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *agrtTopTipsText;
@property (nonatomic, copy) NSString *agrtAgreeText;
@property (nonatomic, copy) NSString *agrtText;
@property (nonatomic, copy) NSString *agrtBotTipsText;
@property (nonatomic, copy) NSString *startBtnText;
@property (nonatomic, copy) NSString *elderBtnText;
@property (nonatomic, copy) NSString *exitBtnText;
@property (nonatomic, copy) NSString *rareFormNameText;
@property (nonatomic, copy) NSString *rareFormIDText;
@property (nonatomic, copy) NSString *rareFormEntBtnText;
@property (nonatomic, copy) NSString *authPermissionCamera;
@property (nonatomic, copy) NSString *authPermissionAudio;
@property (nonatomic, copy) NSString *authPermissionScreenEvidence;
@property (nonatomic, copy) NSString *authPermissionToastTitle;
@property (nonatomic, copy) NSString *authPermissionToastMsg;
@property (nonatomic, copy) NSString *authPermissionAPPName;
@property (nonatomic, copy) NSString *authPermissionToastAlbumTitle;
@property (nonatomic, copy) NSString *authPermissionToastAlbumMsg;
@property (nonatomic, copy) NSString *authPermissionSDKName;
@property (nonatomic, copy) NSString *dialogExitTitle;
@property (nonatomic, copy) NSString *dialogExitMsg;
@property (nonatomic, copy) NSString *dialogExitConfirm;
@property (nonatomic, copy) NSString *dialogExitCancel;
@property (nonatomic, copy) NSString *dialogPermissionFailedTitle;
@property (nonatomic, copy) NSString *dialogPermissionFailedMsg;
@property (nonatomic, copy) NSString *dialogPermissionFailedConfirm;
@property (nonatomic, copy) NSString *dialogPermissionFailedCancel;
@property (nonatomic, copy) NSString *dialogNetworkFailedTitle;
@property (nonatomic, copy) NSString *dialogNetworkFailedMsg;
@property (nonatomic, copy) NSString *dialogNetworkFailedConfirm;
@property (nonatomic, copy) NSString *dialogSupportFailedTitle;
@property (nonatomic, copy) NSString *dialogSupportFailedMsg;
@property (nonatomic, copy) NSString *dialogSupportFailedConfirm;
@property (nonatomic, copy) NSString *settingFailReason;
@property (nonatomic, copy) NSDictionary *originMap;

@end

@interface DTFLanguageCustomFaceConfig : NSObject

@property (nonatomic, copy) NSString *faceNotFound;
@property (nonatomic, copy) NSString *faceTooFar;
@property (nonatomic, copy) NSString *faceTooClose;
@property (nonatomic, copy) NSString *faceNotIn;
@property (nonatomic, copy) NSString *badPitch;
@property (nonatomic, copy) NSString *badYaw;
@property (nonatomic, copy) NSString *faceTooMore;
@property (nonatomic, copy) NSString *faceIsMoving;
@property (nonatomic, copy) NSString *faceBrightless;
@property (nonatomic, copy) NSString *faceBadQuality;
@property (nonatomic, copy) NSString *eyesOnScreen;
@property (nonatomic, copy) NSString *blink;
@property (nonatomic, copy) NSString *leftYaw;
@property (nonatomic, copy) NSString *rightYaw;
@property (nonatomic, copy) NSString *stackTime;
@property (nonatomic, copy) NSString *isBlur;
@property (nonatomic, copy) NSString *faceInitTxt;
@property (nonatomic, copy) NSString *faceTitleBlink;
@property (nonatomic, copy) NSString *leftYawLiveness;
@property (nonatomic, copy) NSString *rightYawLiveness;
@property (nonatomic, copy) NSString *photinusCommTips;
@property (nonatomic, copy) NSString *processing;
@property (nonatomic, copy) NSString *dialogTimeOutTitle;
@property (nonatomic, copy) NSString *dialogTimeOutMsg;
@property (nonatomic, copy) NSString *dialogTimeOutConfirm;
@property (nonatomic, copy) NSString *dialogInterruptTitle;
@property (nonatomic, copy) NSString *dialogInterruptConfirm;
@property (nonatomic, copy) NSString *dialogInterruptCancel;
@property (nonatomic, copy) NSString *dialogTooManyRetriesTitle;
@property (nonatomic, copy) NSString *dialogTooManyRetriesMsg;
@property (nonatomic, copy) NSString *dialogTooManyRetriesConfirm;
@property (nonatomic, copy) NSString *dialogExitTitle;
@property (nonatomic, copy) NSString *dialogExitMsg;
@property (nonatomic, copy) NSString *dialogExitConfirm;
@property (nonatomic, copy) NSString *dialogExitCancel;
@property (nonatomic, copy) NSString *dialogCamOpenFailedTitle;
@property (nonatomic, copy) NSString *dialogCamOpenFailedMsg;
@property (nonatomic, copy) NSString *dialogCamOpenFailedCancel;
@property (nonatomic, copy) NSString *dialogCamOpenFailedConfirm;
@property (nonatomic, copy) NSString *dialogArchSysFailedTitle;
@property (nonatomic, copy) NSString *dialogArchSysFailedMsg;
@property (nonatomic, copy) NSString *dialogArchSysFailedConfirm;
@property (nonatomic, copy) NSString *dialogSDKErrTitle;
@property (nonatomic, copy) NSString *dialogSDKErrMsg;
@property (nonatomic, copy) NSString *dialogSDKErrConfirm;
@property (nonatomic, copy) NSString *dialogNetworkFailedTitle;
@property (nonatomic, copy) NSString *dialogNetworkFailedMsg;
@property (nonatomic, copy) NSString *dialogNetworkFailedConfirm;
@property (nonatomic, copy) NSString *settingFailReason;
@property (nonatomic, copy) NSString *verifyNotice;

@end

@interface DTFLanguageCustomDocConfig : NSObject

@property (nonatomic, copy) NSString *stageFrontTips;//人像面
@property (nonatomic, copy) NSString *stageBackTips;//国徽面
@property (nonatomic, copy) NSString *stageLivenessTips;//实人认证
@property (nonatomic, copy) NSString *frontInfoTips;//拍摄人像面
@property (nonatomic, copy) NSString *frontInfoBottomTips;//证件人像面
@property (nonatomic, copy) NSString *backInfoBottomTips;//证件国徽面
@property (nonatomic, copy) NSString *backInfoTips;//拍摄国徽面
@property (nonatomic, copy) NSString *takeRequireTxt;//拍摄要求
@property (nonatomic, copy) NSString *takeRequireTitle;//拍摄要求
@property (nonatomic, copy) NSString *resultCheckTips;//请确认以下身份信息，如有误请点击修改
@property (nonatomic, copy) NSString *certNameTitle;//姓名
@property (nonatomic, copy) NSString *certNameHint;//请输入姓名
@property (nonatomic, copy) NSString *certNoTitle;//身份证号
@property (nonatomic, copy) NSString *certNoHint;//请输入身份证号
@property (nonatomic, copy) NSString *nextTxt;//下一步
@property (nonatomic, copy) NSString *confirmTxt;//确认身份信息无误
@property (nonatomic, copy) NSString *livenessTips;//实人认证
@property (nonatomic, copy) NSString *livenessMsg;//拍摄您本人人脸，请确保正对手机，光线充足
@property (nonatomic, copy) NSString *livenessLoadingMsg;//即将进入刷脸页...
@property (nonatomic, copy) NSString *dialogIdentityFailTitle;//识别失败
@property (nonatomic, copy) NSString *dialogIdentityFailRequireTitle;//证件图像未符合要求
@property (nonatomic, copy) NSString *dialogIdentityFailRequireMsg;//请按要求拍摄本人有效身份证
@property (nonatomic, copy) NSString *dialogIdentityFailRetry;//重新拍摄
@property (nonatomic, copy) NSString *dialogIdentityFailReUpload;//重新上传
@property (nonatomic, copy) NSString *dialogNetworkTimeOutTitle;//识别超时
@property (nonatomic, copy) NSString *dialogNetworkTimeOutMsg;//网络连接超时，请重新识别
@property (nonatomic, copy) NSString *dialogNetworkTimeOutConfirm;//重新识别
@property (nonatomic, copy) NSString *dialogNetworkTimeOutCancel;//退出
@property (nonatomic, copy) NSString *identityLoadingMsg;//识别中
@property (nonatomic, copy) NSString *dialogExitTitle;//确定退出吗？
@property (nonatomic, copy) NSString *dialogExitMsg;//拍张照就能通过
@property (nonatomic, copy) NSString *dialogExitCancel;//取消
@property (nonatomic, copy) NSString *dialogExitConfirm;//确定
@property (nonatomic, copy) NSString *dialogTooManyRetriesTitle;//识别失败次数过多
@property (nonatomic, copy) NSString *dialogTooManyRetriesMsg;//请退出后重试
@property (nonatomic, copy) NSString *dialogTooManyRetriesConfirm;//退出
@property (nonatomic, copy) NSString *dialogNoPermissionTitle;//温馨提示
@property (nonatomic, copy) NSString *dialogNoPermissionMsg;//请打开摄像头权限
@property (nonatomic, copy) NSString *dialogNoPermissionCancel;//取消
@property (nonatomic, copy) NSString *dialogNoPermissionToSet;//去设置
@property (nonatomic, copy) NSString *takeFrontTips;//拍摄身份证人像面
@property (nonatomic, copy) NSString *takeBackTips;//拍摄身份证国徽面
/// 图片来源弹框“拍照”文案
@property (nonatomic, copy) NSString *chooseTakePhoto;
//图片来源弹框“从相册中选择”文案
@property (nonatomic, copy) NSString *chooseFromAlbum;
/// 图片来源弹框“取消”文案
@property (nonatomic, copy) NSString *chooseCancel;
/// 请打开相册权限
@property (nonatomic, copy) NSString *dialogNoAlbumPermissionMsg;

@property (nonatomic, assign) BOOL successConfigFlag;//配置成功标志
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface DTFLanguageCustomConfig : NSObject
@property (strong, nonatomic) DTFLanguageCustomGuideConfig *guideConfig;
@property (strong, nonatomic) DTFLanguageCustomFaceConfig *faceConfig;
@property (strong, nonatomic) DTFLanguageCustomDocConfig *docConfig;

- (instancetype)initWithString:(NSString *)string type:(NSString *)type error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
