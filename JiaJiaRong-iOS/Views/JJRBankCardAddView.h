//
//  JJRBankCardAddView.h
//  JiaJiaRong-iOS
//
//  Created by json on 2025/7/5.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRAddBankCardBlock)(NSString *cardNumber, NSString *cardHolder, NSString *idNumber, NSString *phone);

@interface JJRBankCardAddView : UIView

@property (nonatomic, copy) JJRAddBankCardBlock addBankCardBlock;

@end

NS_ASSUME_NONNULL_END 
