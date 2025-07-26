//
//  LoanAssessmentStep1View.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "LoanAssessmentStep1View.h"
#import "JJRLoanAssessmentViewModel.h"

@interface LoanAssessmentStep1View ()

@property (nonatomic, strong) JJRLoanAssessmentViewModel *viewModel;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIView *cardContainer;
@property (nonatomic, strong) NSMutableArray<UIButton *> *optionButtons;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation LoanAssessmentStep1View

- (instancetype)initWithViewModel:(JJRLoanAssessmentViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        _optionButtons = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 白色卡片容器
    self.cardContainer = [[UIView alloc] init];
    self.cardContainer.backgroundColor = [UIColor whiteColor];
    self.cardContainer.layer.cornerRadius = 16;
    self.cardContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardContainer.layer.shadowOpacity = 0.1;
    self.cardContainer.layer.shadowRadius = 8;
    [self addSubview:self.cardContainer];
    
    // 单选题标签
    UILabel *singleChoiceLabel = [[UILabel alloc] init];
    singleChoiceLabel.text = @"单选题";
    singleChoiceLabel.font = FONT_REGULAR(14);
    singleChoiceLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    singleChoiceLabel.backgroundColor = [UIColor colorWithHexString:@"#EFF6FF"];
    singleChoiceLabel.textAlignment = NSTextAlignmentCenter;
    singleChoiceLabel.layer.cornerRadius = 12;
    singleChoiceLabel.clipsToBounds = YES;
    [self.cardContainer addSubview:singleChoiceLabel];
    
    // 问题标题
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.text = @"1. 您需要的借款额度是？";
    self.questionLabel.font = FONT_BOLD(18);
    self.questionLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    self.questionLabel.numberOfLines = 0;
    [self.cardContainer addSubview:self.questionLabel];
    
    // 创建选项按钮
    [self createOptionButtons];
    
    // 下一步按钮
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = FONT_BOLD(16);
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.nextButton.layer.cornerRadius = 25;
    self.nextButton.enabled = NO;
    self.nextButton.alpha = 0.6;
    [self.nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextButton];
    
    [self setupConstraints];
}

- (void)createOptionButtons {
    NSArray<NSString *> *options = self.viewModel.allOptions[0]; // 直接使用第一步的选项
    
    for (int i = 0; i < options.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:options[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = FONT_REGULAR(16);
        button.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        button.layer.cornerRadius = 8;
        button.tag = i;
        [button addTarget:self action:@selector(optionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.cardContainer addSubview:button];
        [self.optionButtons addObject:button];
    }
}

- (void)setupConstraints {
    [self.cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self).inset(20);
    }];
    
    UILabel *singleChoiceLabel = self.cardContainer.subviews[0];
    [singleChoiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardContainer).offset(20);
        make.left.equalTo(self.cardContainer).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(24);
    }];
    
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(singleChoiceLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.cardContainer).inset(20);
    }];
    
    // 选项按钮约束
    UIButton *previousButton = nil;
    for (UIButton *button in self.optionButtons) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (previousButton) {
                make.top.equalTo(previousButton.mas_bottom).offset(12);
            } else {
                make.top.equalTo(self.questionLabel.mas_bottom).offset(30);
            }
            make.left.right.equalTo(self.cardContainer).inset(20);
            make.height.mas_equalTo(50);
        }];
        previousButton = button;
    }
    
    // 设置卡片容器的底部约束
    UIButton *lastButton = self.optionButtons.lastObject;
    [self.cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastButton.mas_bottom).offset(30);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardContainer.mas_bottom).offset(40);
        make.left.right.equalTo(self).inset(20);
        make.height.mas_equalTo(50);
        make.bottom.lessThanOrEqualTo(self).offset(-40);
    }];
}

#pragma mark - Actions

- (void)optionButtonTapped:(UIButton *)sender {
    NSInteger selectedIndex = sender.tag;
    
    // 重置所有按钮状态
    for (UIButton *button in self.optionButtons) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    
    // 设置选中状态
    sender.selected = YES;
    sender.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    
    // 更新ViewModel
    [self.viewModel selectOptionAtIndex:selectedIndex];
    
    // 更新下一步按钮状态
    [self updateNextButtonState];
}

- (void)nextButtonTapped {
    if ([self.viewModel canProceedToNextStep]) {
        [self.viewModel goToNextStep];
    }
}

- (void)updateNextButtonState {
    BOOL canProceed = [self.viewModel canProceedToNextStep];
    self.nextButton.enabled = canProceed;
    self.nextButton.alpha = canProceed ? 1.0 : 0.6;
}

- (void)updateDisplay {
    // 更新选项按钮状态
    id selected = [self.viewModel selectedForCurrentStep];
    NSInteger selectedIndex = [selected isKindOfClass:[NSNumber class]] ? [selected integerValue] : -1;
    
    for (int i = 0; i < self.optionButtons.count; i++) {
        UIButton *button = self.optionButtons[i];
        if (i == selectedIndex) {
            button.selected = YES;
            button.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
        } else {
            button.selected = NO;
            button.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        }
    }
    
    [self updateNextButtonState];
}

@end 