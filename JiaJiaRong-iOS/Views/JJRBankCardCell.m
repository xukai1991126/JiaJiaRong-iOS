//
//  JJRBankCardCell.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBankCardCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface JJRBankCardCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIImageView *bankLogoImageView;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *cardNumberLabel;
@property (nonatomic, strong) UILabel *cardTypeLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation JJRBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 卡片容器
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 12;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardView.layer.shadowOpacity = 0.1;
    self.cardView.layer.shadowRadius = 4;
    [self.contentView addSubview:self.cardView];
    
    // 银行Logo
    self.bankLogoImageView = [[UIImageView alloc] init];
    self.bankLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.cardView addSubview:self.bankLogoImageView];
    
    // 银行名称
    self.bankNameLabel = [[UILabel alloc] init];
    self.bankNameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.bankNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.cardView addSubview:self.bankNameLabel];
    
    // 卡号
    self.cardNumberLabel = [[UILabel alloc] init];
    self.cardNumberLabel.font = [UIFont systemFontOfSize:16];
    self.cardNumberLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.cardView addSubview:self.cardNumberLabel];
    
    // 卡类型
    self.cardTypeLabel = [[UILabel alloc] init];
    self.cardTypeLabel.font = [UIFont systemFontOfSize:14];
    self.cardTypeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.cardView addSubview:self.cardTypeLabel];
    
    // 删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"#FF4444"] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.deleteButton];
}

- (void)setupConstraints {
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.bankLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(20);
        make.left.equalTo(self.cardView).offset(20);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankLogoImageView);
        make.left.equalTo(self.bankLogoImageView.mas_right).offset(15);
        make.right.equalTo(self.deleteButton.mas_left).offset(-10);
        make.height.mas_equalTo(24);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(20);
        make.right.equalTo(self.cardView).offset(-20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    [self.cardNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.bankNameLabel);
        make.right.equalTo(self.cardView).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardNumberLabel.mas_bottom).offset(5);
        make.left.equalTo(self.cardNumberLabel);
        make.right.equalTo(self.cardView).offset(-20);
        make.height.mas_equalTo(18);
    }];
}

- (void)setBankCard:(JJRBankCardModel *)bankCard {
    _bankCard = bankCard;
    
    // 设置银行Logo（这里可以根据银行名称设置对应的图片）
    self.bankLogoImageView.image = [UIImage imageNamed:@"bank_logo_default"];
    
    self.bankNameLabel.text = bankCard.bankName;
    self.cardNumberLabel.text = bankCard.bankNo;
    self.cardTypeLabel.text = bankCard.cardType;
}

- (void)deleteButtonTapped {
    if (self.deleteBlock) {
        self.deleteBlock(self.bankCard);
    }
}

@end 