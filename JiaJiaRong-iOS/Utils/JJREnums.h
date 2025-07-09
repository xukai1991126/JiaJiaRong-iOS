//
//  JJREnums.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/01/01.
//  Copyright © 2024 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 网络请求相关枚举

/**
 * 网络请求状态枚举
 */
typedef NS_ENUM(NSInteger, JJRNetworkStatus) {
    JJRNetworkStatusSuccess = 0,    // 成功
    JJRNetworkStatusFailed,         // 失败
    JJRNetworkStatusNoNetwork,      // 无网络
    JJRNetworkStatusTimeout         // 超时
};

/**
 * 请求方法枚举
 */
typedef NS_ENUM(NSInteger, JJRRequestMethod) {
    JJRRequestMethodGET = 0,        // GET请求
    JJRRequestMethodPOST,           // POST请求
    JJRRequestMethodPUT,            // PUT请求
    JJRRequestMethodDELETE          // DELETE请求
};

#pragma mark - 用户相关枚举

/**
 * 用户认证状态枚举
 */
typedef NS_ENUM(NSInteger, JJRUserAuthStatus) {
    JJRUserAuthStatusUnauthorized = 0,  // 未认证
    JJRUserAuthStatusAuthorized,        // 已认证
    JJRUserAuthStatusPending,           // 认证中
    JJRUserAuthStatusRejected           // 认证被拒
};

/**
 * 用户类型枚举
 */
typedef NS_ENUM(NSInteger, JJRUserType) {
    JJRUserTypeNormal = 0,          // 普通用户
    JJRUserTypeVIP,                 // VIP用户
    JJRUserTypeEnterprise           // 企业用户
};

#pragma mark - 贷款相关枚举

/**
 * 贷款申请状态枚举
 */
typedef NS_ENUM(NSInteger, JJRLoanStatus) {
    JJRLoanStatusDraft = 0,         // 草稿
    JJRLoanStatusSubmitted,         // 已提交
    JJRLoanStatusReviewing,         // 审核中
    JJRLoanStatusApproved,          // 已通过
    JJRLoanStatusRejected,          // 已拒绝
    JJRLoanStatusDisbursed,         // 已放款
    JJRLoanStatusRepaying,          // 还款中
    JJRLoanStatusCompleted,         // 已完成
    JJRLoanStatusOverdue            // 已逾期
};

/**
 * 还款状态枚举
 */
typedef NS_ENUM(NSInteger, JJRRepaymentStatus) {
    JJRRepaymentStatusPending = 0,  // 待还款
    JJRRepaymentStatusPaid,         // 已还款
    JJRRepaymentStatusOverdue,      // 已逾期
    JJRRepaymentStatusPartial       // 部分还款
};

/**
 * 银行卡类型枚举
 */
typedef NS_ENUM(NSInteger, JJRBankCardType) {
    JJRBankCardTypeDebit = 0,       // 借记卡
    JJRBankCardTypeCredit,          // 信用卡
    JJRBankCardTypeSavings          // 储蓄卡
};

#pragma mark - UI相关枚举

/**
 * 渐变方向枚举
 */
typedef NS_ENUM(NSInteger, JJRGradientDirection) {
    JJRGradientDirectionHorizontal = 0,    // 水平渐变
    JJRGradientDirectionVertical,          // 垂直渐变
    JJRGradientDirectionDiagonalUp,        // 对角线向上渐变
    JJRGradientDirectionDiagonalDown       // 对角线向下渐变
};

/**
 * 按钮样式枚举
 */
typedef NS_ENUM(NSInteger, JJRButtonStyle) {
    JJRButtonStylePrimary = 0,      // 主要按钮
    JJRButtonStyleSecondary,        // 次要按钮
    JJRButtonStyleOutline,          // 轮廓按钮
    JJRButtonStyleText              // 文本按钮
};

/**
 * 按钮大小枚举
 */
typedef NS_ENUM(NSInteger, JJRButtonSize) {
    JJRButtonSizeSmall = 0,         // 小按钮
    JJRButtonSizeMedium,            // 中等按钮
    JJRButtonSizeLarge              // 大按钮
};

/**
 * 输入框类型枚举
 */
typedef NS_ENUM(NSInteger, JJRInputType) {
    JJRInputTypeText = 0,           // 文本输入
    JJRInputTypePassword,           // 密码输入
    JJRInputTypePhone,              // 手机号输入
    JJRInputTypeIDCard,             // 身份证输入
    JJRInputTypeBankCard,           // 银行卡输入
    JJRInputTypeAmount,             // 金额输入
    JJRInputTypeEmail,              // 邮箱输入
    JJRInputTypeNumber,              // 纯数字输入
    JJRInputTypeCode                 // 验证码输入
};

/**
 * 验证码类型枚举
 */
typedef NS_ENUM(NSInteger, JJRVerifyCodeType) {
    JJRVerifyCodeTypeLogin = 0,     // 登录验证码
    JJRVerifyCodeTypeRegister,      // 注册验证码
    JJRVerifyCodeTypeResetPassword, // 重置密码验证码
    JJRVerifyCodeTypeBindPhone      // 绑定手机验证码
};

#pragma mark - 页面相关枚举

/**
 * 页面类型枚举
 */
typedef NS_ENUM(NSInteger, JJRPageType) {
    JJRPageTypeLogin = 0,           // 登录页
    JJRPageTypeRegister,            // 注册页
    JJRPageTypeHome,                // 首页
    JJRPageTypeApply,               // 申请页
    JJRPageTypeMy,                  // 我的页面
    JJRPageTypeSettings             // 设置页
};

/**
 * 导航栏样式枚举
 */
typedef NS_ENUM(NSInteger, JJRNavigationBarStyle) {
    JJRNavigationBarStyleDefault = 0,   // 默认样式
    JJRNavigationBarStyleTransparent,   // 透明样式
    JJRNavigationBarStyleWhite,         // 白色样式
    JJRNavigationBarStyleBlack          // 黑色样式
};

#pragma mark - 工具类枚举

/**
 * 日期格式枚举
 */
typedef NS_ENUM(NSInteger, JJRDateFormat) {
    JJRDateFormatFull = 0,          // 完整格式 yyyy-MM-dd HH:mm:ss
    JJRDateFormatDate,              // 日期格式 yyyy-MM-dd
    JJRDateFormatTime,              // 时间格式 HH:mm:ss
    JJRDateFormatMonth,             // 月份格式 yyyy-MM
    JJRDateFormatYear               // 年份格式 yyyy
};

/**
 * 文件类型枚举
 */
typedef NS_ENUM(NSInteger, JJRFileType) {
    JJRFileTypeImage = 0,           // 图片文件
    JJRFileTypeDocument,            // 文档文件
    JJRFileTypeVideo,               // 视频文件
    JJRFileTypeAudio                // 音频文件
};

typedef NS_ENUM(NSInteger, JJRButtonType) {
    JJRButtonTypePrimary,    // 主要按钮（橙色背景）
    JJRButtonTypeSecondary,  // 次要按钮（白色背景，蓝色边框）
    JJRButtonTypeDanger,     // 危险按钮（红色背景）
    JJRButtonTypeSuccess,    // 成功按钮（绿色背景）
    JJRButtonTypeWarning,    // 警告按钮（橙色背景）
    JJRButtonTypeText        // 文字按钮（无背景）
};


NS_ASSUME_NONNULL_END 
