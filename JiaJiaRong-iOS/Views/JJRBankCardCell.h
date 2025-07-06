//
//  JJRBankCardCell.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
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