//
//  JJRIdCardView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRIdCardView.h"
#import "JJRButton.h"
#import "JJRInputView.h"

@interface JJRIdCardView ()

// 步骤指示器
@property (nonatomic, strong) UIView *stepContainer;
@property (nonatomic, strong) NSArray<UIImageView *> *stepImages;
@property (nonatomic, strong) NSArray<UILabel *> *stepNumbers;
@property (nonatomic, strong) NSArray<UIView *> *stepLines;
@property (nonatomic, strong) NSArray<UILabel *> *stepTitleLabels;

// 上传页面
@property (nonatomic, strong) UIView *uploadContainer;
@property (nonatomic, strong) UILabel *uploadTitleLabel;
@property (nonatomic, strong) UILabel *uploadSubtitleLabel;
@property (nonatomic, strong) UIView *uploadImageContainer;
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *faceLabel;
@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, strong) UIView *tipsContainer;
@property (nonatomic, strong) UIView *formContainer;
@property (nonatomic, strong) JJRButton *nextButton;

// 人脸识别页面
@property (nonatomic, strong) UIView *faceVerifyContainer;
@property (nonatomic, strong) UIImageView *faceVerifyImageView;
@property (nonatomic, strong) UILabel *faceVerifyTipLabel;
@property (nonatomic, strong) UIView *agreementContainer;
@property (nonatomic, strong) UIButton *agreementCheckbox;
@property (nonatomic, strong) JJRButton *faceVerifyButton;

// 结果页面
@property (nonatomic, strong) UIView *resultContainer;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UILabel *resultTitleLabel;
@property (nonatomic, strong) JJRButton *resultButton;

// 表单输入
@property (nonatomic, strong) NSArray<JJRInputView *> *formInputs;

@end

@implementation JJRIdCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraints];
        [self setupFormInputs];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 步骤指示器
    [self setupStepIndicator];
    
    // 上传页面
    [self setupUploadPage];
    
    // 人脸识别页面
    [self setupFaceVerifyPage];
    
    // 结果页面
    [self setupResultPage];
    
    // 初始显示上传页面
    [self setStep:JJRIdCardStepUpload animated:NO];
}

- (void)setupStepIndicator {
    self.stepContainer = [[UIView alloc] init];
    [self addSubview:self.stepContainer];
    
    // 步骤图片
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *numbers = [NSMutableArray array];
    NSMutableArray *lines = [NSMutableArray array];
    NSMutableArray *titleLabels = [NSMutableArray array];
    
    NSArray *stepTitles = @[@"身份证上传", @"人脸识别", @"认证结果"];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"step_inactive"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.stepContainer addSubview:imageView];
        [images addObject:imageView];
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.text = [NSString stringWithFormat:@"%d", i + 1];
        numberLabel.font = [UIFont systemFontOfSize:12];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        // 第一个圆圈不显示数字，只显示图标
        if (i == 0) {
            numberLabel.hidden = YES;
        }
        [imageView addSubview:numberLabel];
        [numbers addObject:numberLabel];
        
        // 步骤标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = stepTitles[i];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.stepContainer addSubview:titleLabel];
        [titleLabels addObject:titleLabel];
        
        if (i < 2) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
            [self.stepContainer addSubview:line];
            [lines addObject:line];
        }
    }
    
    self.stepImages = [images copy];
    self.stepNumbers = [numbers copy];
    self.stepLines = [lines copy];
    self.stepTitleLabels = [titleLabels copy];
}

- (void)setupUploadPage {
    self.uploadContainer = [[UIView alloc] init];
    [self addSubview:self.uploadContainer];
    
    // 标题
    self.uploadTitleLabel = [[UILabel alloc] init];
    self.uploadTitleLabel.text = @"请拍摄您本人身份证";
    self.uploadTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.uploadTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.uploadContainer addSubview:self.uploadTitleLabel];
    
    // 副标题
    self.uploadSubtitleLabel = [[UILabel alloc] init];
    self.uploadSubtitleLabel.text = @"仅限于人民银行核查公民身份，请放心使用";
    self.uploadSubtitleLabel.font = [UIFont systemFontOfSize:14];
    self.uploadSubtitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.uploadSubtitleLabel.numberOfLines = 0;
    [self.uploadContainer addSubview:self.uploadSubtitleLabel];
    
    // 图片上传区域
    self.uploadImageContainer = [[UIView alloc] init];
    [self.uploadContainer addSubview:self.uploadImageContainer];
    
    // 正面图片
    self.faceImageView = [[UIImageView alloc] init];
    self.faceImageView.image = [UIImage imageNamed:@"idcard_face_placeholder"];
    self.faceImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.faceImageView.layer.cornerRadius = 8;
    self.faceImageView.layer.borderWidth = 1;
    self.faceImageView.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    self.faceImageView.userInteractionEnabled = YES;
    self.faceImageView.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    UITapGestureRecognizer *faceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceImageTapped)];
    [self.faceImageView addGestureRecognizer:faceTap];
    [self.uploadImageContainer addSubview:self.faceImageView];
    
    self.faceLabel = [[UILabel alloc] init];
    self.faceLabel.text = @"身份证人像面";
    self.faceLabel.font = [UIFont systemFontOfSize:12];
    self.faceLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.faceLabel.textAlignment = NSTextAlignmentCenter;
    [self.uploadImageContainer addSubview:self.faceLabel];
    
    // 背面图片
    self.backImageView = [[UIImageView alloc] init];
    self.backImageView.image = [UIImage imageNamed:@"idcard_back_placeholder"];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backImageView.layer.cornerRadius = 8;
    self.backImageView.layer.borderWidth = 1;
    self.backImageView.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    self.backImageView.userInteractionEnabled = YES;
    self.backImageView.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageTapped)];
    [self.backImageView addGestureRecognizer:backTap];
    [self.uploadImageContainer addSubview:self.backImageView];
    
    self.backLabel = [[UILabel alloc] init];
    self.backLabel.text = @"身份证国徽面";
    self.backLabel.font = [UIFont systemFontOfSize:12];
    self.backLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.backLabel.textAlignment = NSTextAlignmentCenter;
    [self.uploadImageContainer addSubview:self.backLabel];
    
    // 拍摄注意事项
    [self setupTipsContainer];
    
    // 表单容器
    self.formContainer = [[UIView alloc] init];
    self.formContainer.hidden = YES;
    [self.uploadContainer addSubview:self.formContainer];
    
    // 下一步按钮
    self.nextButton = [[JJRButton alloc] initWithTitle:@"下一步" type:JJRButtonTypePrimary];
    WeakSelf
    [self.nextButton setClickAction:^(JJRButton *button) {
        if ([weakSelf.delegate respondsToSelector:@selector(idCardViewDidTapNextStep)]) {
            [weakSelf.delegate idCardViewDidTapNextStep];
        }
    }];
    [self.uploadContainer addSubview:self.nextButton];
}

- (void)setupTipsContainer {
    self.tipsContainer = [[UIView alloc] init];
    [self.uploadContainer addSubview:self.tipsContainer];
    
    UILabel *tipsTitleLabel = [[UILabel alloc] init];
    tipsTitleLabel.text = @"拍摄注意事项";
    tipsTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    tipsTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.tipsContainer addSubview:tipsTitleLabel];
    
    [tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.tipsContainer);
        make.height.mas_equalTo(20);
    }];
    
    // 创建4个提示项
    NSArray *tips = @[
        @{@"image": @"idcard_tip_normal", @"text": @"正常识别", @"isGood": @YES},
        @{@"image": @"idcard_tip_edge", @"text": @"边缘缺失", @"isGood": @NO},
        @{@"image": @"idcard_tip_blur", @"text": @"模糊不清", @"isGood": @NO},
        @{@"image": @"idcard_tip_flash", @"text": @"闪光过度", @"isGood": @NO}
    ];
    
    UIView *tipsRow = [[UIView alloc] init];
    [self.tipsContainer addSubview:tipsRow];
    
    [tipsRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsTitleLabel.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self.tipsContainer);
        make.height.mas_equalTo(80);
    }];
    
    // 存储tipItem以便后续设置约束
    NSMutableArray *tipItems = [NSMutableArray array];
    
    for (int i = 0; i < tips.count; i++) {
        NSDictionary *tip = tips[i];
        
        UIView *tipItem = [[UIView alloc] init];
        [tipsRow addSubview:tipItem];
        [tipItems addObject:tipItem];
        
        UIImageView *tipImage = [[UIImageView alloc] init];
        tipImage.image = [UIImage imageNamed:tip[@"image"]];
        tipImage.contentMode = UIViewContentModeScaleAspectFit;
        [tipItem addSubview:tipImage];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = tip[@"text"];
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.textColor = [tip[@"isGood"] boolValue] ? [UIColor colorWithHexString:@"#00EA1F"] : [UIColor colorWithHexString:@"#EA0000"];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [tipItem addSubview:tipLabel];
        
        [tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(tipItem);
            make.width.height.mas_equalTo(40);
        }];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImage.mas_bottom).offset(5);
            make.left.right.equalTo(tipItem);
            make.height.mas_equalTo(15);
        }];
    }
    
    // 设置tipItem的水平布局约束，使其平均分布
    for (int i = 0; i < tipItems.count; i++) {
        UIView *tipItem = tipItems[i];
        [tipItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(tipsRow);
            
            if (i == 0) {
                // 第一个item：距离左边10pt，宽度相等
                make.left.equalTo(tipsRow).offset(10);
                make.width.equalTo(tipsRow).multipliedBy(0.21); // 21%的宽度
            } else {
                // 其他item：距离前一个item右边8pt，宽度相等
                UIView *preTipItem = tipItems[i-1];
                make.left.equalTo(preTipItem.mas_right).offset(8);
                make.width.equalTo(tipItems[0]); // 与第一个item宽度相等
            }
        }];
    }
}

- (void)setupFaceVerifyPage {
    self.faceVerifyContainer = [[UIView alloc] init];
    [self addSubview:self.faceVerifyContainer];
    
    // 标题
    UILabel *faceVerifyTitleLabel = [[UILabel alloc] init];
    faceVerifyTitleLabel.text = @"即将进行人脸识别";
    faceVerifyTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    faceVerifyTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    faceVerifyTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.faceVerifyContainer addSubview:faceVerifyTitleLabel];
    
    // 副标题
    UILabel *faceVerifySubtitleLabel = [[UILabel alloc] init];
    faceVerifySubtitleLabel.text = @"请衣着整齐，平视屏幕，请保持光线充足";
    faceVerifySubtitleLabel.font = [UIFont systemFontOfSize:14];
    faceVerifySubtitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    faceVerifySubtitleLabel.textAlignment = NSTextAlignmentCenter;
    faceVerifySubtitleLabel.numberOfLines = 0;
    [self.faceVerifyContainer addSubview:faceVerifySubtitleLabel];
    
    // 人脸识别图片
    self.faceVerifyImageView = [[UIImageView alloc] init];
    self.faceVerifyImageView.image = [UIImage imageNamed:@"face_verify_image"];
    self.faceVerifyImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.faceVerifyContainer addSubview:self.faceVerifyImageView];
    
    // 提示文字
    self.faceVerifyTipLabel = [[UILabel alloc] init];
    self.faceVerifyTipLabel.text = @"请确保是本人操作";
    self.faceVerifyTipLabel.font = [UIFont systemFontOfSize:16];
    self.faceVerifyTipLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.faceVerifyTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.faceVerifyContainer addSubview:self.faceVerifyTipLabel];
    
    // 协议
    [self setupAgreementContainer];
    
    // 开始识别按钮
    self.faceVerifyButton = [[JJRButton alloc] initWithTitle:@"开始识别" type:JJRButtonTypePrimary];
    [self.faceVerifyButton setCornerRadius:23];
    WeakSelf
    [self.faceVerifyButton setClickAction:^(JJRButton *button) {
        StrongSelf
        if ([strongSelf.delegate respondsToSelector:@selector(idCardViewDidTapFaceVerify)]) {
            [strongSelf.delegate idCardViewDidTapFaceVerify];
        }
    }];
    [self.faceVerifyContainer addSubview:self.faceVerifyButton];
    
    // 约束
    [faceVerifyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceVerifyContainer);
        make.left.right.equalTo(self.faceVerifyContainer);
        make.height.mas_equalTo(22);
    }];
    
    [faceVerifySubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(faceVerifyTitleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.faceVerifyContainer);
        make.height.mas_equalTo(20);
    }];
    
    [self.faceVerifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(faceVerifySubtitleLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.faceVerifyContainer);
        make.width.height.mas_equalTo(200);
    }];
    
    [self.faceVerifyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceVerifyImageView.mas_bottom).offset(20);
        make.left.right.equalTo(self.faceVerifyContainer);
        make.height.mas_equalTo(20);
    }];
}

- (void)setupAgreementContainer {
    self.agreementContainer = [[UIView alloc] init];
    [self.faceVerifyContainer addSubview:self.agreementContainer];
    
    self.agreementCheckbox = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreementCheckbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141_unselect"] forState:UIControlStateNormal];
    [self.agreementCheckbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141"] forState:UIControlStateSelected];
    [self.agreementCheckbox addTarget:self action:@selector(agreementCheckboxTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.agreementContainer addSubview:self.agreementCheckbox];
    
    // 创建一个容器来放置协议文本
    UILabel *agreementPrefixLabel = [[UILabel alloc] init];
    agreementPrefixLabel.text = @"我已阅读并同意";
    agreementPrefixLabel.font = [UIFont systemFontOfSize:12];
    agreementPrefixLabel.textColor = [UIColor colorWithHexString:@"#97999E"];
    [self.agreementContainer addSubview:agreementPrefixLabel];
    
    // 用户服务协议按钮
    UIButton *userAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userAgreementButton setTitle:@" 《用户服务协议》" forState:UIControlStateNormal];
    [userAgreementButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    userAgreementButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [userAgreementButton addTarget:self action:@selector(userAgreementTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.agreementContainer addSubview:userAgreementButton];
    
    // 隐私协议按钮
    UIButton *privacyAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [privacyAgreementButton setTitle:@" 《隐私协议》" forState:UIControlStateNormal];
    [privacyAgreementButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    privacyAgreementButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [privacyAgreementButton addTarget:self action:@selector(privacyAgreementTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.agreementContainer addSubview:privacyAgreementButton];
    
    // 设置约束
    [self.agreementCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.agreementContainer);
        make.width.height.mas_equalTo(20);
    }];
    
    [agreementPrefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreementCheckbox.mas_right).offset(10);
        make.centerY.equalTo(self.agreementContainer);
        make.height.mas_equalTo(20);
    }];
    
    [userAgreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreementPrefixLabel.mas_right).offset(0);
        make.centerY.equalTo(self.agreementContainer);
        make.height.mas_equalTo(20);
    }];
    
    [privacyAgreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userAgreementButton.mas_right).offset(0);
        make.centerY.equalTo(self.agreementContainer);
        make.height.mas_equalTo(20);
        make.right.lessThanOrEqualTo(self.agreementContainer).offset(-10);
    }];
}


- (void)handleAgreement:(NSString *)type title:(NSString *)title {
    NSLog(@"🎯 打开协议页面: %@", title);
    // 通过委托回调给控制器处理跳转
    if ([self.delegate respondsToSelector:@selector(idCardViewDidTapAgreement:title:)]) {
        [self.delegate idCardViewDidTapAgreement:type title:title];
    }
}



- (void)setupResultPage {
    self.resultContainer = [[UIView alloc] init];
    [self addSubview:self.resultContainer];
    
    // 成功图标
    self.resultImageView = [[UIImageView alloc] init];
    self.resultImageView.image = [UIImage imageNamed:@"success_icon"];
    self.resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.resultContainer addSubview:self.resultImageView];
    
    // 成功标题
    self.resultTitleLabel = [[UILabel alloc] init];
    self.resultTitleLabel.text = @"身份证认证成功";
    self.resultTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.resultTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.resultTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.resultContainer addSubview:self.resultTitleLabel];
    
    // 立即申请按钮
    self.resultButton = [[JJRButton alloc] initWithTitle:@"立即申请担保额度" type:JJRButtonTypePrimary];
    WeakSelf
    [self.resultButton setClickAction:^(JJRButton *button) {
        StrongSelf
        if ([strongSelf.delegate respondsToSelector:@selector(idCardViewDidTapGoShouquanshu)]) {
            [strongSelf.delegate idCardViewDidTapGoShouquanshu];
        }
    }];
    [self.resultContainer addSubview:self.resultButton];
}

- (void)setupFormInputs {
    // 简化的表单输入设置
}

- (void)setupConstraints {
    // 步骤指示器约束
    [self.stepContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.height.mas_equalTo(40); // 增加高度以容纳标题文字
    }];
    
    // 步骤图片约束
    for (int i = 0; i < self.stepImages.count; i++) {
        UIImageView *imageView = self.stepImages[i];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.stepContainer);
            make.width.height.mas_equalTo(30);
            if (i == 0) {
                make.left.equalTo(self.stepContainer).offset(30); // 距离左边30pt
            } else if (i == 1) {
                make.centerX.equalTo(self.stepContainer);
            } else {
                make.right.equalTo(self.stepContainer).offset(-30); // 距离右边30pt
            }
        }];
        
        UILabel *numberLabel = self.stepNumbers[i];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imageView);
        }];
    }
    
    // 步骤线条约束
    for (int i = 0; i < self.stepLines.count; i++) {
        UIView *line = self.stepLines[i];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.stepContainer);
            make.height.mas_equalTo(2);
            if (i == 0) {
                make.left.equalTo(self.stepImages[0].mas_right).offset(10);
                make.right.equalTo(self.stepImages[1].mas_left).offset(-10);
            } else {
                make.left.equalTo(self.stepImages[1].mas_right).offset(10);
                make.right.equalTo(self.stepImages[2].mas_left).offset(-10);
            }
        }];
    }
    
    // 步骤标题约束
    for (int i = 0; i < self.stepTitleLabels.count; i++) {
        UILabel *titleLabel = self.stepTitleLabels[i];
        UIImageView *imageView = self.stepImages[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stepContainer.mas_bottom).offset(1);
            make.centerX.equalTo(imageView);
            make.height.mas_equalTo(20);
            make.width.mas_lessThanOrEqualTo(80); // 设置最大宽度，避免文字过长时重叠
        }];
    }
    
    // 上传页面约束
    [self.uploadContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepTitleLabels.firstObject.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.bottom.equalTo(self).offset(-200);
    }];
    
    [self.uploadTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.uploadContainer);
        make.height.mas_equalTo(25);
    }];
    
    [self.uploadSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadTitleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.uploadContainer);
        make.height.mas_equalTo(20);
    }];
    
    [self.uploadImageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadSubtitleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.uploadContainer);
        make.height.mas_equalTo(150);
    }];
    
    // 正面图片约束
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.uploadImageContainer);
        make.width.equalTo(self.uploadImageContainer).multipliedBy(0.48);
        make.height.mas_equalTo(120);
    }];
    
    [self.faceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self.faceImageView);
        make.height.mas_equalTo(15);
    }];
    
    // 背面图片约束
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.uploadImageContainer);
        make.width.equalTo(self.uploadImageContainer).multipliedBy(0.48);
        make.height.mas_equalTo(120);
    }];
    
    [self.backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self.backImageView);
        make.height.mas_equalTo(15);
    }];
    
    // 提示容器约束
    [self.tipsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadImageContainer.mas_bottom).offset(20);
        make.left.right.equalTo(self.uploadContainer);
        make.height.mas_equalTo(120);
    }];
    
    // 表单容器约束
    [self.formContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsContainer.mas_bottom).offset(20);
        make.left.right.equalTo(self.uploadContainer);
        make.height.mas_equalTo(300);
    }];
    
    // 表单输入约束
    for (int i = 0; i < self.formInputs.count; i++) {
        JJRInputView *input = self.formInputs[i];
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.formContainer);
            make.height.mas_equalTo(60);
            if (i == 0) {
                make.top.equalTo(self.formContainer);
            } else {
                make.top.equalTo(self.formInputs[i-1].mas_bottom).offset(10);
            }
        }];
    }
    
    // 下一步按钮约束
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.uploadContainer);
        make.left.right.equalTo(self.uploadContainer);
        make.height.mas_equalTo(44);
    }];
    
    // 人脸识别页面约束
    [self.faceVerifyContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepTitleLabels.firstObject.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.bottom.equalTo(self).offset(-100);
    }];
    
    // 修复头像位置：头像应该在副标题下方，而不是在容器顶部
    [self.faceVerifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceVerifyContainer).offset(80); // 为标题和副标题留出空间
        make.centerX.equalTo(self.faceVerifyContainer);
        make.width.height.mas_equalTo(200);
    }];
    
    [self.faceVerifyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceVerifyImageView.mas_bottom).offset(20);
        make.left.right.equalTo(self.faceVerifyContainer);
        make.height.mas_equalTo(20);
    }];
    
    [self.agreementContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceVerifyTipLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self.faceVerifyContainer);
        make.height.mas_equalTo(40);
    }];
    
    [self.agreementCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.agreementContainer);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.faceVerifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.faceVerifyContainer).offset(-30);
        make.left.right.equalTo(self.faceVerifyContainer);
        make.height.mas_equalTo(46);
    }];
    
    // 结果页面约束
    [self.resultContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepTitleLabels.firstObject.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.bottom.equalTo(self).offset(-100);
    }];
    
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.resultContainer);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.resultTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultImageView.mas_bottom).offset(20);
        make.left.right.equalTo(self.resultContainer);
        make.height.mas_equalTo(25);
    }];
    
    [self.resultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.resultContainer);
        make.centerX.equalTo(self.resultContainer);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Public Methods

- (void)setFaceImage:(UIImage *)image {
    self.faceImageView.image = image;
    self.faceImageView.layer.borderColor = [UIColor colorWithHexString:@"#007AFF"].CGColor;
}

- (void)setBackImage:(UIImage *)image {
    self.backImageView.image = image;
    self.backImageView.layer.borderColor = [UIColor colorWithHexString:@"#007AFF"].CGColor;
}

- (void)setStep:(JJRIdCardStep)step animated:(BOOL)animated {
    self.currentStep = step;
    
    // 更新步骤指示器
    [self updateStepIndicator:step];
    
    // 隐藏所有容器
    self.uploadContainer.hidden = YES;
    self.faceVerifyContainer.hidden = YES;
    self.resultContainer.hidden = YES;
    
    // 显示对应容器
    switch (step) {
        case JJRIdCardStepUpload:
            self.uploadContainer.hidden = NO;
            break;
            
        case JJRIdCardStepFaceVerify:
            self.faceVerifyContainer.hidden = NO;
            break;
            
        case JJRIdCardStepResult:
            self.resultContainer.hidden = NO;
            break;
    }
}

- (void)updateStepIndicator:(JJRIdCardStep)step {
    for (int i = 0; i < self.stepImages.count; i++) {
        UIImageView *imageView = self.stepImages[i];
        UILabel *numberLabel = self.stepNumbers[i];
        UILabel *titleLabel = self.stepTitleLabels[i];
        
        // 第一个圆圈始终不显示数字，只显示图标
        if (i == 0) {
            numberLabel.hidden = YES;
        }
        
        if (i < step) {
            // 已完成的步骤
            imageView.image = [UIImage imageNamed:@"step_active"];
            if (i != 0) numberLabel.hidden = YES; // 第一个圆圈已经在上面处理了
            titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            titleLabel.font = [UIFont systemFontOfSize:12];
        } else if (i == step) {
            // 当前步骤
            imageView.image = [UIImage imageNamed:@"step_active"];
            if (i != 0) numberLabel.hidden = NO; // 第一个圆圈不显示数字
            titleLabel.textColor = [UIColor colorWithHexString:@"#1a1a1a"];
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
        } else {
            // 未完成的步骤
            imageView.image = [UIImage imageNamed:@"step_inactive"];
            if (i != 0) numberLabel.hidden = NO; // 第一个圆圈不显示数字
            titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            titleLabel.font = [UIFont systemFontOfSize:12];
        }
    }
}

- (void)showResult:(BOOL)success {
    if (success) {
        self.resultImageView.image = [UIImage imageNamed:@"success_icon"];
        self.resultTitleLabel.text = @"身份证认证成功";
    } else {
        self.resultImageView.image = [UIImage imageNamed:@"error_icon"];
        self.resultTitleLabel.text = @"身份证认证失败";
    }
}

- (void)setFormVisible:(BOOL)visible {
    self.formContainer.hidden = !visible;
}

#pragma mark - Actions

- (void)faceImageTapped {
    if ([self.delegate respondsToSelector:@selector(idCardViewDidTapUpload:type:)]) {
        [self.delegate idCardViewDidTapUpload:self.faceImageView type:@"face"];
    }
}

- (void)backImageTapped {
    if ([self.delegate respondsToSelector:@selector(idCardViewDidTapUpload:type:)]) {
        [self.delegate idCardViewDidTapUpload:self.backImageView type:@"back"];
    }
}

- (void)agreementCheckboxTapped {
    self.agreementCheckbox.selected = !self.agreementCheckbox.selected;
    self.isAgreementChecked = self.agreementCheckbox.selected;
}

- (void)userAgreementTapped {
    if ([self.delegate respondsToSelector:@selector(idCardViewDidTapAgreement:title:)]) {
        [self.delegate idCardViewDidTapAgreement:@"user" title:@"用户服务协议"];
    }
}

- (void)privacyAgreementTapped {
    if ([self.delegate respondsToSelector:@selector(idCardViewDidTapAgreement:title:)]) {
        [self.delegate idCardViewDidTapAgreement:@"privacy" title:@"隐私协议"];
    }
}

@end 
