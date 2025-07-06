//
//  JJRBankCardModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRBankCardModel : JJRBaseModel

@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *bankNo;      // 银行卡号，对应uni-app的bankNo字段
@property (nonatomic, strong) NSString *cardType;    // 卡片类型
@property (nonatomic, strong) NSString *bankName;    // 银行名称
@property (nonatomic, strong) NSString *bankCode;    // 银行代码
@property (nonatomic, strong) NSString *bankLogo;    // 银行logo
@property (nonatomic, strong) NSString *cardholderName; // 持卡人姓名
@property (nonatomic, strong) NSString *phoneNumber; // 手机号
@property (nonatomic, assign) BOOL isDefault;        // 是否默认卡
@property (nonatomic, assign) BOOL isVerified;       // 是否已验证
@property (nonatomic, strong) NSString *createTime;  // 创建时间
@property (nonatomic, strong) NSString *updateTime;  // 更新时间

@end

NS_ASSUME_NONNULL_END 
