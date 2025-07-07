//
//  JJRAPIDefines.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 基础URL
#define JJR_BASE_URL @"https://jjr818.com"

#pragma mark - 应用相关接口
// 获取应用渠道信息
#define JJR_APP_CHANNEL @"/app/channel"

// 获取应用信息
#define JJR_APP_INFO @"/app/info"

// 发送验证码
#define JJR_CAPTCHA_SEND @"/app/captcha/send"

// 验证码登录
#define JJR_CAPTCHA_LOGIN @"/app/captcha/login"

// 密码登录
#define JJR_PWD_LOGIN @"/app/pwd/login"

#pragma mark - 用户信息相关接口
// 获取用户信息
#define JJR_USER_INFO @"/app/userinfo"

// 实名认证
#define JJR_REAL_NAME_AUTH @"/app/realname/auth"

#pragma mark - 表单相关接口
// 获取表单字段
#define JJR_FORM_FIELD @"/app/form/field"

// 提交表单申请
#define JJR_FORM_APPLY @"/app/form/apply"

// 获取热门城市
#define JJR_FORM_CITY_HOT @"/app/form/city/hot"

#pragma mark - 身份证相关接口
// 身份证识别
#define JJR_IDCARD_RECOGNIZE @"/app/idcard/recognize"

// 身份证验证
#define JJR_IDCARD_VERIFY @"/app/idcard/verify"

#pragma mark - 银行卡相关接口
// 获取银行卡列表
#define JJR_BANK_CARD_LIST @"/app/blank/list"

// 添加银行卡
#define JJR_BANK_CARD_ADD @"/app/blank/add"

// 删除银行卡
#define JJR_BANK_CARD_DELETE @"/app/blank/remove"

#pragma mark - 申请记录相关接口
// 获取申请记录
#define JJR_APPLY_RECORD @"/app/apply/record"

// 获取还款计划
#define JJR_REPAYMENT_PLAN @"/app/repayment/plan"

#pragma mark - 密码管理相关接口
// 初始化密码
#define JJR_PASSWORD_INIT @"/app/password/init"

// 修改密码
#define JJR_PASSWORD_MODIFY @"/app/password/modify"

// 忘记密码
#define JJR_PASSWORD_FORGET @"/app/password/forget"

#pragma mark - 反馈相关接口
// 提交反馈
#define JJR_FEEDBACK_SUBMIT @"/app/feedback/submit"

#pragma mark - 其他接口
// 获取关于我们
#define JJR_ABOUT_US @"/app/about/us"

// 获取免责声明
#define JJR_DISCLAIMER @"/app/disclaimer"

// 获取安全手册
#define JJR_SECURITY_MANUAL @"/app/security/manual"

// 获取协议内容
#define JJR_AGREEMENT @"/app/agreement"

// 获取版本信息
#define JJR_VERSION_INFO @"/app/version/info"

// 获取公告
#define JJR_NOTICE @"/app/notice"

// 获取通知设置
#define JJR_NOTIFICATION_SETTINGS @"/app/notification/settings"

// 设置通知
#define JJR_NOTIFICATION_SET @"/app/notification/set"

// 提交留言
#define JJR_MESSAGE_SUBMIT @"/app/message/submit"

#pragma mark - 文件上传相关接口
// 上传图片
#define JJR_UPLOAD_IMAGE @"/app/upload/image"

// 上传文件
#define JJR_UPLOAD_FILE @"/app/upload/file"

#pragma mark - 系统相关接口
// 获取系统配置
#define JJR_SYSTEM_CONFIG @"/app/system/config"

// 获取字典数据
#define JJR_DICT_DATA @"/app/dict/data"

// 获取城市列表
#define JJR_CITY_LIST @"/app/city/list"

// 获取省份列表
#define JJR_PROVINCE_LIST @"/app/province/list"

// 获取区县列表
#define JJR_DISTRICT_LIST @"/app/district/list"

#pragma mark - 统计相关接口
// 页面访问统计
#define JJR_PAGE_STATISTICS @"/app/statistics/page"

// 用户行为统计
#define JJR_USER_BEHAVIOR @"/app/statistics/behavior"

#pragma mark - 支付相关接口
// 创建支付订单
#define JJR_PAYMENT_CREATE @"/app/payment/create"

// 支付状态查询
#define JJR_PAYMENT_STATUS @"/app/payment/status"

// 支付回调
#define JJR_PAYMENT_CALLBACK @"/app/payment/callback"

#pragma mark - 消息相关接口
// 获取消息列表
#define JJR_MESSAGE_LIST @"/app/message/list"

// 标记消息已读
#define JJR_MESSAGE_READ @"/app/message/read"

// 删除消息
#define JJR_MESSAGE_DELETE @"/app/message/delete"

#pragma mark - 设置相关接口
// 获取用户设置
#define JJR_USER_SETTINGS @"/app/user/settings"

// 更新用户设置
#define JJR_USER_SETTINGS_UPDATE @"/app/user/settings/update"

// 获取隐私政策
#define JJR_PRIVACY_POLICY @"/app/privacy/policy"

// 获取用户协议
#define JJR_USER_AGREEMENT @"/app/user/agreement"

#pragma mark - 工具相关接口
// 获取定位信息
#define JJR_LOCATION_INFO @"/app/location/info"

// 地址解析
#define JJR_ADDRESS_PARSE @"/app/address/parse"

// 获取天气信息
#define JJR_WEATHER_INFO @"/app/weather/info"

#pragma mark - 第三方服务接口
// 高德地图API
#define AMAP_GEOCODE_URL @"https://restapi.amap.com/v3/geocode/regeo"

// 高德地图Key
#define AMAP_API_KEY @"e215040da1a6654520964514372218ce"

