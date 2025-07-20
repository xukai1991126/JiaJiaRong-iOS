//
//  JJRAIResultViewController.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseViewController.h"
#import "JJRAILoanAdvice.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRAIResultViewController : JJRBaseViewController

@property (nonatomic, strong) JJRAILoanAdvice *loanAdvice;

- (instancetype)initWithLoanAdvice:(JJRAILoanAdvice *)advice;

@end

NS_ASSUME_NONNULL_END 