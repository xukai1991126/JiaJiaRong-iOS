//
//  JJRRepaymentPlanCell.h
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/01.
//

#import <UIKit/UIKit.h>
#import "JJRRepaymentPlanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRRepaymentPlanCell : UITableViewCell

@property (nonatomic, strong) JJRRepaymentPlanModel *model;

+ (CGFloat)cellHeightForModel:(JJRRepaymentPlanModel *)model;

@end

NS_ASSUME_NONNULL_END 
