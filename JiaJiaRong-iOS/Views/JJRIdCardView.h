//
//  JJRIdCardView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRIdCardModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JJRIdCardStep) {
    JJRIdCardStepUpload = 0,    // 身份证上传
    JJRIdCardStepFaceVerify,    // 人脸识别
    JJRIdCardStepResult         // 认证结果
};

@protocol JJRIdCardViewDelegate <NSObject>

- (void)idCardViewDidTapUpload:(UIImageView *)imageView type:(NSString *)type;
- (void)idCardViewDidTapNextStep;
- (void)idCardViewDidTapFaceVerify;
- (void)idCardViewDidTapAgreement:(NSString *)type;
- (void)idCardViewDidTapGoShouquanshu;
- (void)idCardViewDidChangeForm:(JJRIdCardModel *)form;

@end

@interface JJRIdCardView : UIView

@property (nonatomic, weak) id<JJRIdCardViewDelegate> delegate;
@property (nonatomic, assign) JJRIdCardStep currentStep;
@property (nonatomic, strong) JJRIdCardModel *form;
@property (nonatomic, assign) BOOL isAgreementChecked;

- (void)setFaceImage:(UIImage *)image;
- (void)setBackImage:(UIImage *)image;
- (void)setStep:(JJRIdCardStep)step animated:(BOOL)animated;
- (void)showResult:(BOOL)success;
- (void)setFormVisible:(BOOL)visible;

@end

NS_ASSUME_NONNULL_END 