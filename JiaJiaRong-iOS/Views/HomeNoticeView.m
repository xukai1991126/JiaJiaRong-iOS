//
//  HomeNoticeView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "HomeNoticeView.h"

@implementation HomeNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 申请须知标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"申请须知";
    titleLabel.font = FONT_BOLD(16);
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    // 助贷机构信息
    UIView *institutionView = [self createInfoRowWithTitle:@"助贷机构：" 
                                                   content:@"普洛互联网金融信息服务（上海）有限公司"];
    [self addSubview:institutionView];
    
    // 资金来源信息
    UIView *fundingView = [self createInfoRowWithTitle:@"资金来源：" 
                                                content:@"南京市天下提融互联网科技小额贷款有限公司"];
    [self addSubview:fundingView];
    
    // 温馨提示
    UILabel *warningTitleLabel = [[UILabel alloc] init];
    warningTitleLabel.text = @"温馨提示：";
    warningTitleLabel.font = FONT_BOLD(14);
    warningTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:warningTitleLabel];
    
    UILabel *warningContentLabel = [[UILabel alloc] init];
    warningContentLabel.text = @"贷款有风险，借款需谨慎。请根据个人能力合理贷款，理性消费，避免过期贷款额度，公积金相关资料仅作为贷款服务验证证明，放款时间以实际审批结果为准，含类产品综合年利率：6%-24%（单利）";
    warningContentLabel.font = FONT_REGULAR(12);
    warningContentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    warningContentLabel.numberOfLines = 0;
    [self addSubview:warningContentLabel];
    
    // 设置约束
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
    }];
    
    [institutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.height.mas_equalTo(20);
    }];
    
    [fundingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(institutionView.mas_bottom).offset(10);
        make.left.right.equalTo(self).inset(20);
        make.height.mas_equalTo(20);
    }];
    
    [warningTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fundingView.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
    }];
    
    [warningContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(warningTitleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self).inset(20);
        make.bottom.equalTo(self).offset(-20);
    }];
}

- (UIView *)createInfoRowWithTitle:(NSString *)title content:(NSString *)content {
    UIView *rowView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = FONT_REGULAR(14);
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [rowView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = content;
    contentLabel.font = FONT_REGULAR(14);
    contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [rowView addSubview:contentLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(rowView);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.right.centerY.equalTo(rowView);
    }];
    
    return rowView;
}

@end 