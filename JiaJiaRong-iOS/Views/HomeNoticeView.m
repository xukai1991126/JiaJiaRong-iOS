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
    
    // 助贷机构
    UILabel *institutionTitleLabel = [[UILabel alloc] init];
    institutionTitleLabel.text = @"助贷机构：";
    institutionTitleLabel.font = FONT_REGULAR(14);
    institutionTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    institutionTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:institutionTitleLabel];

    UILabel *institutionContentLabel = [[UILabel alloc] init];
    institutionContentLabel.text = @"广东南枫";
    institutionContentLabel.font = FONT_REGULAR(14);
    institutionContentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    institutionContentLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:institutionContentLabel];

    // 资金来源
    UILabel *fundingTitleLabel = [[UILabel alloc] init];
    fundingTitleLabel.text = @"资金来源：";
    fundingTitleLabel.font = FONT_REGULAR(14);
    fundingTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    fundingTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:fundingTitleLabel];

    UILabel *fundingContentLabel = [[UILabel alloc] init];
    fundingContentLabel.text = @"广东南枫融资担保有限公司";
    fundingContentLabel.font = FONT_REGULAR(14);
    fundingContentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    fundingContentLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:fundingContentLabel];
    
    // 温馨提示
    UILabel *warningTitleLabel = [[UILabel alloc] init];
    warningTitleLabel.text = @"温馨提示：";
    warningTitleLabel.font = FONT_BOLD(14);
    warningTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:warningTitleLabel];
    
    UILabel *warningContentLabel = [[UILabel alloc] init];
    warningContentLabel.text = @"本平台仅提供融资担保增信服务，协助对接持牌金融机构(最终额度、费率以机构审批为准)。若对方案（金额、费率、合同）有异议，请立即终止申请并联系客服核实；您可自主选择申请渠道，平台不强制使用且无隐藏费用。";
    warningContentLabel.font = FONT_REGULAR(12);
    warningContentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    warningContentLabel.numberOfLines = 0;
    [self addSubview:warningContentLabel];
    
    // 设置约束
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
    }];
    
    [institutionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
    }];
    [institutionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(institutionTitleLabel.mas_right);
        make.centerY.equalTo(institutionTitleLabel);
        make.right.lessThanOrEqualTo(self).offset(-20);
    }];
    [fundingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(institutionTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
    }];
    [fundingContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fundingTitleLabel.mas_right);
        make.centerY.equalTo(fundingTitleLabel);
        make.right.lessThanOrEqualTo(self).offset(-20);
    }];
    
    [warningTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fundingContentLabel.mas_bottom).offset(20);
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
    contentLabel.textAlignment = NSTextAlignmentLeft;
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
