//
//  JJRIdCardModel.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRIdCardModel : JJRBaseModel

@property (nonatomic, copy) NSString *idName;
@property (nonatomic, copy) NSString *idNo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *backImage;
@property (nonatomic, copy) NSString *birthDate;
@property (nonatomic, copy) NSString *ethnicity;
@property (nonatomic, copy) NSString *faceImage;
@property (nonatomic, copy) NSString *issueAuthority;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *validPeriod;

@end

NS_ASSUME_NONNULL_END 