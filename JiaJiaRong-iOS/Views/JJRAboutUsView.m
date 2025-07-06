//
//  JJRAboutUsView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAboutUsView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface JJRAboutUsView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *copyrightLabel;

@end

@implementation JJRAboutUsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // Logo图片
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"app_logo"];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.layer.cornerRadius = 20;
    self.logoImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.logoImageView];
    
    // 应用名称
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.text = @"家家融";
    self.appNameLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    self.appNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.appNameLabel];
    
    // 版本号
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.text = @"版本 1.0.0";
    self.versionLabel.font = [UIFont systemFontOfSize:14];
    self.versionLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.versionLabel];
    
    // 应用描述
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.text = @"家家融是一款专业的金融服务平台，致力于为用户提供便捷、安全、透明的借贷服务。我们拥有专业的团队和先进的技术，为用户提供全方位的金融解决方案。";
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    self.descriptionLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.descriptionLabel];
    
    // 版权信息
    self.copyrightLabel = [[UILabel alloc] init];
    self.copyrightLabel.text = @"© 2024 家家融. All rights reserved.";
    self.copyrightLabel.font = [UIFont systemFontOfSize:12];
    self.copyrightLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.copyrightLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.copyrightLabel];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(60);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(120);
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionLabel.mas_bottom).offset(40);
        make.left.equalTo(self.contentView).offset(30);
        make.right.equalTo(self.contentView).offset(-30);
    }];
    
    [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(60);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
}

@end 