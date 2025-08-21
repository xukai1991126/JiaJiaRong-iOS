//
//  JJRAIResultViewController.h
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseViewController.h"
#import "JJRAILoanAdvice.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRAIResultViewController : JJRBaseViewController

@property (nonatomic, strong) JJRAILoanAdvice *loanAdvice;

- (instancetype)initWithLoanAdvice:(JJRAILoanAdvice *)advice;

@end

NS_ASSUME_NONNULL_END 
