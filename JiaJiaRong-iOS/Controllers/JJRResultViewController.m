//
//  JJRResultViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRResultViewController.h"
#import "JJRNetworkService.h"
#import "JJRUserManager.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface JJRResultViewController ()

// 顶部步骤视图
@property (nonatomic, strong) UIView *stepView;
@property (nonatomic, strong) UIImageView *step1ImageView;
@property (nonatomic, strong) UILabel *step1Label;
@property (nonatomic, strong) UIView *stepLineView;
@property (nonatomic, strong) UIImageView *step2ImageView;
@property (nonatomic, strong) UILabel *step2Label;

// 结果内容视图
@property (nonatomic, strong) UIView *resultContentView;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UILabel *resultTitleLabel;
@property (nonatomic, strong) UILabel *resultDescLabel;
@property (nonatomic, strong) UIButton *homeButton;

// 特别提醒部分
@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic, strong) NSString *noticeDownloadText;

@end

@implementation JJRResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料审核";
    [self setupUI];
    [self fetchChannelInfo];
    [self fetchAppInfo];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
    // 顶部步骤视图
    [self setupStepView];
    
    // 结果内容视图
    [self setupResultContentView];
}

- (void)setupStepView {
    self.stepView = [[UIView alloc] init];
    self.stepView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self.view addSubview:self.stepView];
    
    // 步骤1
    self.step1ImageView = [[UIImageView alloc] init];
    self.step1ImageView.image = [UIImage imageNamed:@"img_29938b72a413"];
    self.step1ImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.stepView addSubview:self.step1ImageView];
    
    self.step1Label = [[UILabel alloc] init];
    self.step1Label.text = @"完善资料";
    self.step1Label.font = [UIFont systemFontOfSize:14];
    self.step1Label.textColor = [UIColor colorWithHexString:@"#767676"];
    self.step1Label.textAlignment = NSTextAlignmentCenter;
    [self.stepView addSubview:self.step1Label];
    
    // 连接线
    self.stepLineView = [[UIView alloc] init];
    self.stepLineView.backgroundColor = [UIColor colorWithHexString:@"#666666"];
    self.stepLineView.layer.borderWidth = 1.0;
    self.stepLineView.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    
    // 创建虚线效果
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    shapeLayer.lineWidth = 2.0;
    shapeLayer.lineDashPattern = @[@5, @5];
    [self.stepLineView.layer addSublayer:shapeLayer];
    [self.stepView addSubview:self.stepLineView];
    
    // 步骤2
    self.step2ImageView = [[UIImageView alloc] init];
    self.step2ImageView.image = [UIImage imageNamed:@"img_7a757391618c"];
    self.step2ImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.stepView addSubview:self.step2ImageView];
    
    self.step2Label = [[UILabel alloc] init];
    self.step2Label.text = @"资料审核";
    self.step2Label.font = [UIFont systemFontOfSize:14];
    self.step2Label.textColor = [UIColor colorWithHexString:@"#767676"];
    self.step2Label.textAlignment = NSTextAlignmentCenter;
    [self.stepView addSubview:self.step2Label];
    
    // 设置约束
    [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    [self.step1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stepView).offset(-15);
        make.left.equalTo(self.stepView).offset(80);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.step1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.step1ImageView.mas_bottom).offset(6);
        make.centerX.equalTo(self.step1ImageView);
    }];
    
    [self.stepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.step1ImageView);
        make.left.equalTo(self.step1ImageView.mas_right).offset(20);
        make.right.equalTo(self.step2ImageView.mas_left).offset(-20);
        make.height.mas_equalTo(2);
    }];
    
    [self.step2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stepView).offset(-15);
        make.right.equalTo(self.stepView).offset(-80);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.step2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.step2ImageView.mas_bottom).offset(6);
        make.centerX.equalTo(self.step2ImageView);
    }];
}

- (void)setupResultContentView {
    self.resultContentView = [[UIView alloc] init];
    self.resultContentView.backgroundColor = [UIColor whiteColor];
    self.resultContentView.layer.cornerRadius = 12;
    self.resultContentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self.view addSubview:self.resultContentView];
    
    // 结果图片
    self.resultImageView = [[UIImageView alloc] init];
    self.resultImageView.image = [UIImage imageNamed:@"img_bcfb96ae035d"];
    self.resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.resultContentView addSubview:self.resultImageView];
    
    // 结果标题
    self.resultTitleLabel = [[UILabel alloc] init];
    self.resultTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.resultTitleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    self.resultTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.resultContentView addSubview:self.resultTitleLabel];
    
    // 结果描述
    self.resultDescLabel = [[UILabel alloc] init];
    self.resultDescLabel.text = @"您的申请已提交，稍后将会有专属业务员为您来电，请注意接听";
    self.resultDescLabel.font = [UIFont systemFontOfSize:14];
    self.resultDescLabel.textColor = [UIColor colorWithHexString:@"#767676"];
    self.resultDescLabel.textAlignment = NSTextAlignmentCenter;
    self.resultDescLabel.numberOfLines = 0;
    [self.resultContentView addSubview:self.resultDescLabel];
    
    // 返回首页按钮
    self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.homeButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [self.homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.homeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.homeButton.layer.cornerRadius = 36;
    
    // 设置渐变背景
    CAGradientLayer *buttonGradient = [CAGradientLayer layer];
    buttonGradient.colors = @[
        (id)[UIColor colorWithHexString:@"#3B4FDE"].CGColor,
        (id)[UIColor colorWithHexString:@"#309BFF"].CGColor
    ];
    buttonGradient.startPoint = CGPointMake(0, 0.5);
    buttonGradient.endPoint = CGPointMake(1, 0.5);
    buttonGradient.cornerRadius = 36;
    [self.homeButton.layer insertSublayer:buttonGradient atIndex:0];
    
    [self.homeButton addTarget:self action:@selector(homeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.resultContentView addSubview:self.homeButton];
    
    // 特别提醒视图
    [self setupTipsView];
    
    // 设置约束
    [self.resultContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.resultContentView);
        make.top.equalTo(self.resultContentView).offset(33);
        make.width.mas_equalTo(112);
        make.height.mas_equalTo(116);
    }];
    
    [self.resultTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.resultContentView);
        make.top.equalTo(self.resultImageView.mas_bottom).offset(16);
        make.left.right.equalTo(self.resultContentView).inset(15);
    }];
    
    [self.resultDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.resultContentView);
        make.top.equalTo(self.resultTitleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self.resultContentView).inset(15);
    }];
    
    [self.homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultDescLabel.mas_bottom).offset(25);
        make.left.right.equalTo(self.resultContentView).inset(15);
        make.height.mas_equalTo(46);
    }];
    
    // 更新按钮渐变layer的frame
    dispatch_async(dispatch_get_main_queue(), ^{
        buttonGradient.frame = self.homeButton.bounds;
    });
}

- (void)setupTipsView {
    self.tipsView = [[UIView alloc] init];
    [self.resultContentView addSubview:self.tipsView];
    
    // 左侧线条
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.tipsView addSubview:leftLine];
    
    // 特别提醒文字
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.text = @"特别提醒";
    self.tipsLabel.font = [UIFont systemFontOfSize:15];
    self.tipsLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.tipsView addSubview:self.tipsLabel];
    
    // 右侧线条
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.tipsView addSubview:rightLine];
    
    // 提醒内容
    self.noticeLabel = [[UILabel alloc] init];
    self.noticeLabel.font = [UIFont systemFontOfSize:13];
    self.noticeLabel.textColor = [UIColor colorWithHexString:@"#767676"];
    self.noticeLabel.numberOfLines = 0;
    self.noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.resultContentView addSubview:self.noticeLabel];
    
    // 设置约束
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeButton.mas_bottom).offset(30);
        make.centerX.equalTo(self.resultContentView);
        make.height.mas_equalTo(20);
        make.left.right.equalTo(self.resultContentView).inset(15);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsView);
        make.centerY.equalTo(self.tipsView);
        make.right.equalTo(self.tipsLabel.mas_left).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tipsView);
        make.width.mas_equalTo(80);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipsView);
        make.centerY.equalTo(self.tipsView);
        make.left.equalTo(self.tipsLabel.mas_right).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsView.mas_bottom).offset(12);
        make.left.right.equalTo(self.resultContentView).inset(15);
        make.bottom.lessThanOrEqualTo(self.resultContentView).offset(-20);
    }];
}

#pragma mark - Network Methods

- (void)fetchChannelInfo {
    [[JJRNetworkService sharedInstance] getAppChannelWithAppId:@"JJR" 
                                                       client:@"IOS" 
                                                      success:^(NSDictionary *response) {
        self.audit = [response[@"data"][@"audit"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateResultDisplay];
        });
    } failure:^(NSError *error) {
        NSLog(@"获取渠道信息失败: %@", error);
        // 默认显示审核中状态
        self.audit = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateResultDisplay];
        });
    }];
}

- (void)fetchAppInfo {
    [[JJRNetworkService sharedInstance] getAppInfoWithAppId:@"JJR" 
                                                         ios:YES 
                                                     success:^(NSDictionary *response) {
        self.noticeDownloadText = response[@"data"][@"noticeDownloadText"] ?: @"";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateNoticeText];
        });
    } failure:^(NSError *error) {
        NSLog(@"获取应用信息失败: %@", error);
    }];
}

- (void)updateResultDisplay {
    NSString *titleText = @"";
    
    switch (self.audit) {
        case 1:
            titleText = @"申请审核中";
            break;
        case 2:
            titleText = @"审核成功";
            break;
        case 3:
            titleText = @"审核未通过";
            break;
        default:
            titleText = @"申请审核中";
            break;
    }
    
    self.resultTitleLabel.text = titleText;
}

- (void)updateNoticeText {
    // 将HTML的<br />标签转换为换行符
    NSString *processedText = [self.noticeDownloadText stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    processedText = [processedText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    processedText = [processedText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    self.noticeLabel.text = processedText;
}

#pragma mark - Actions

- (void)homeButtonTapped {
    // 返回首页（回到TabBar的首页）
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end 