//
//  JJRBankCardCell.h
//  JiaJiaRong-iOS
//
//  Created by json on 2025/7/5.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRDeleteBankCardBlock)(JJRBankCardModel *bankCard);

@interface JJRBankCardCell : UITableViewCell

@property (nonatomic, strong) JJRBankCardModel *bankCard;
@property (nonatomic, copy) JJRDeleteBankCardBlock deleteBlock;

@end

NS_ASSUME_NONNULL_END 
