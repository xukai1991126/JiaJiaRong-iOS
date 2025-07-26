//
//  RealNameAuthAmountCardView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "RealNameAuthAmountCardView.h"
#import "JJRRealNameAuthViewModel.h"

@interface RealNameAuthAmountCardView ()

@property (nonatomic, strong) JJRRealNameAuthViewModel *viewModel;
@property (nonatomic, strong) UIView *cardContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIView *periodContainer;
@property (nonatomic, strong) UILabel *periodTitleLabel;
@property (nonatomic, strong) UILabel *periodValueLabel;

@end

@implementation RealNameAuthAmountCardView

- (instancetype)initWithViewModel:(JJRRealNameAuthViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 卡片容器
    self.cardContainer = [[UIView alloc] init];
    self.cardContainer.backgroundColor = [UIColor whiteColor];
    self.cardContainer.layer.cornerRadius = 16;
    self.cardContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardContainer.layer.shadowOpacity = 0.1;
    self.cardContainer.layer.shadowRadius = 8;
    [self addSubview:self.cardContainer];
    
    // 左侧橙色装饰线
    UIView *leftDecorationLine = [[UIView alloc] init];
    leftDecorationLine.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    leftDecorationLine.layer.cornerRadius = 1;
    [self.cardContainer addSubview:leftDecorationLine];
    
    // 右侧橙色装饰线
    UIView *rightDecorationLine = [[UIView alloc] init];
    rightDecorationLine.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    rightDecorationLine.layer.cornerRadius = 1;
    [self.cardContainer addSubview:rightDecorationLine];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"最高可借额度（元）";
    self.titleLabel.font = FONT_REGULAR(16);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardContainer addSubview:self.titleLabel];
    
    // 额度背景容器
    UIView *amountBgView = [[UIView alloc] init];
    amountBgView.backgroundColor = [UIColor colorWithHexString:@"#F0F7FF"];
    amountBgView.layer.cornerRadius = 8;
    [self.cardContainer addSubview:amountBgView];
    
    // 额度数字
    self.amountLabel = [[UILabel alloc] init];
    self.amountLabel.text = self.viewModel.maxAmount;
    self.amountLabel.font = FONT_BOLD(36);
    self.amountLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    [amountBgView addSubview:self.amountLabel];
    
    // 期限信息容器
    self.periodContainer = [[UIView alloc] init];
    [self.cardContainer addSubview:self.periodContainer];
    
    // 期限标题
    self.periodTitleLabel = [[UILabel alloc] init];
    self.periodTitleLabel.text = @"借款期限";
    self.periodTitleLabel.font = FONT_REGULAR(14);
    self.periodTitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.periodTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.periodContainer addSubview:self.periodTitleLabel];
    
    // 期限值
    self.periodValueLabel = [[UILabel alloc] init];
    self.periodValueLabel.text = self.viewModel.maxPeriod;
    self.periodValueLabel.font = FONT_REGULAR(14);
    self.periodValueLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.periodValueLabel.textAlignment = NSTextAlignmentRight;
    [self.periodContainer addSubview:self.periodValueLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 左侧装饰线
    UIView *leftDecorationLine = self.cardContainer.subviews[0];
    [leftDecorationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardContainer).offset(20);
        make.centerY.equalTo(self.titleLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
    }];
    
    // 右侧装饰线  
    UIView *rightDecorationLine = self.cardContainer.subviews[1];
    [rightDecorationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardContainer).offset(-20);
        make.centerY.equalTo(self.titleLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardContainer).offset(30);
        make.centerX.equalTo(self.cardContainer);
        make.height.mas_equalTo(20);
    }];
    
    // 额度背景容器
    UIView *amountBgView = self.cardContainer.subviews[2];
    [amountBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.height.mas_equalTo(80);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(amountBgView);
        make.height.mas_equalTo(40);
    }];
    
    [self.periodContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountBgView.mas_bottom).offset(20);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.bottom.equalTo(self.cardContainer).offset(-30);
        make.height.mas_equalTo(20);
    }];
    
    [self.periodTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.periodContainer);
        make.height.mas_equalTo(20);
    }];
    
    [self.periodValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.periodContainer);
        make.height.mas_equalTo(20);
    }];
}

@end 