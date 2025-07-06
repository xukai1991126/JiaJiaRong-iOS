//
//  JJRResultViewController.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRResultViewController : JJRBaseViewController

// 结果状态属性
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *detailMessage;
@property (nonatomic, assign) NSInteger audit; // 审核状态：1-审核中，2-审核成功，3-审核未通过

@end

NS_ASSUME_NONNULL_END 