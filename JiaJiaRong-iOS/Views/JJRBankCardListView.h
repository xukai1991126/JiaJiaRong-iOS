//
//  JJRBankCardListView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JJRDeleteBankCardBlock)(JJRBankCardModel *bankCard);
typedef void(^JJRSelectBankCardBlock)(JJRBankCardModel *bankCard);

@interface JJRBankCardListView : UIView

@property (nonatomic, copy) JJRDeleteBankCardBlock deleteBankCardBlock;
@property (nonatomic, copy) JJRSelectBankCardBlock selectBankCardBlock;

- (void)updateBankCards:(NSArray<JJRBankCardModel *> *)bankCards;

@end

NS_ASSUME_NONNULL_END 