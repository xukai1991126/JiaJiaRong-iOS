//
//  JJRRepaymentPlanCell.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/01/01.
//

#import "JJRRepaymentPlanCell.h"
#import <Masonry/Masonry.h>

@interface JJRRepaymentPlanCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *periodLabel;
@property (nonatomic, strong) UILabel *payDateLabel;
@property (nonatomic, strong) UIView *separatorLine;

@property (nonatomic, strong) UIView *principalItemView;
@property (nonatomic, strong) UILabel *principalTitleLabel;
@property (nonatomic, strong) UILabel *principalValueLabel;

@property (nonatomic, strong) UIView *interestItemView;
@property (nonatomic, strong) UILabel *interestTitleLabel;
@property (nonatomic, strong) UILabel *interestValueLabel;

@property (nonatomic, strong) UIView *serviceFeeItemView;
@property (nonatomic, strong) UILabel *serviceFeeTitleLabel;
@property (nonatomic, strong) UILabel *serviceFeeValueLabel;

@property (nonatomic, strong) UIView *guaranteeFeeItemView;
@property (nonatomic, strong) UILabel *guaranteeFeeTitleLabel;
@property (nonatomic, strong) UILabel *guaranteeFeeValueLabel;

@property (nonatomic, strong) UIView *otherFeeItemView;
@property (nonatomic, strong) UILabel *otherFeeTitleLabel;
@property (nonatomic, strong) UILabel *otherFeeValueLabel;

@end

@implementation JJRRepaymentPlanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 创建卡片视图
    [self createCardView];
    
    // 创建头部视图
    [self createHeaderView];
    
    // 创建详细视图
    [self createDetailView];
}

- (void)createCardView {
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 16.0;
    self.cardView.layer.shadowColor = [UIColor colorWithRed:0.79 green:0.80 blue:0.82 alpha:0.3].CGColor;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cardView.layer.shadowOpacity = 1.0;
    self.cardView.layer.shadowRadius = 12.0;
    [self.contentView addSubview:self.cardView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(6);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
}

- (void)createHeaderView {
    self.headerView = [[UIView alloc] init];
    [self.cardView addSubview:self.headerView];
    
    // 还款日期
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0]; // #767676
    [self.headerView addSubview:self.dateLabel];
    
    // 应还金额
    self.amountLabel = [[UILabel alloc] init];
    self.amountLabel.font = [UIFont boldSystemFontOfSize:20];
    self.amountLabel.textColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1.0]; // #030303
    [self.headerView addSubview:self.amountLabel];
    
    // 箭头图标
    self.arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerView addSubview:self.arrowImageView];
    
    // 设置约束
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.cardView);
        make.height.mas_equalTo(80);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(16);
        make.top.equalTo(self.headerView).offset(14);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-16);
        make.centerY.equalTo(self.headerView);
        make.width.height.mas_equalTo(12);
    }];
}

- (void)createDetailView {
    self.detailView = [[UIView alloc] init];
    self.detailView.hidden = YES;
    [self.cardView addSubview:self.detailView];
    
    // 统计周期
    self.periodLabel = [[UILabel alloc] init];
    self.periodLabel.font = [UIFont systemFontOfSize:12];
    self.periodLabel.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0]; // #767676
    [self.detailView addSubview:self.periodLabel];
    
    // 本期还款日
    self.payDateLabel = [[UILabel alloc] init];
    self.payDateLabel.font = [UIFont systemFontOfSize:12];
    self.payDateLabel.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0]; // #767676
    [self.detailView addSubview:self.payDateLabel];
    
    // 分割线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]; // #f2f2f2
    [self.detailView addSubview:self.separatorLine];
    
    // 创建费用项目视图
    [self createFeeItemViews];
    
    // 设置约束
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.cardView);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailView).offset(16);
        make.top.equalTo(self.detailView).offset(0);
    }];
    
    [self.payDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel);
        make.top.equalTo(self.periodLabel.mas_bottom).offset(6);
    }];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailView).offset(16);
        make.right.equalTo(self.detailView).offset(-16);
        make.top.equalTo(self.payDateLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    
    // 费用项目约束
    [self.principalItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailView);
        make.top.equalTo(self.separatorLine.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.interestItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailView);
        make.top.equalTo(self.principalItemView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.serviceFeeItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailView);
        make.top.equalTo(self.interestItemView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.guaranteeFeeItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailView);
        make.top.equalTo(self.serviceFeeItemView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.otherFeeItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailView);
        make.top.equalTo(self.guaranteeFeeItemView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.detailView).offset(-14);
    }];
}

- (void)createFeeItemViews {
    // 应还本金
    UILabel *principalTitle = nil;
    UILabel *principalValue = nil;
    self.principalItemView = [self createItemViewWithTitle:@"应还本金" titleLabel:&principalTitle valueLabel:&principalValue];
    self.principalTitleLabel = principalTitle;
    self.principalValueLabel = principalValue;
    
    // 应还利息
    UILabel *interestTitle = nil;
    UILabel *interestValue = nil;
    self.interestItemView = [self createItemViewWithTitle:@"应还利息" titleLabel:&interestTitle valueLabel:&interestValue];
    self.interestTitleLabel = interestTitle;
    self.interestValueLabel = interestValue;
    
    // 服务费
    UILabel *serviceFeeTitle = nil;
    UILabel *serviceFeeValue = nil;
    self.serviceFeeItemView = [self createItemViewWithTitle:@"服务费" titleLabel:&serviceFeeTitle valueLabel:&serviceFeeValue];
    self.serviceFeeTitleLabel = serviceFeeTitle;
    self.serviceFeeValueLabel = serviceFeeValue;
    
    // 担保费
    UILabel *guaranteeFeeTitle = nil;
    UILabel *guaranteeFeeValue = nil;
    self.guaranteeFeeItemView = [self createItemViewWithTitle:@"担保费" titleLabel:&guaranteeFeeTitle valueLabel:&guaranteeFeeValue];
    self.guaranteeFeeTitleLabel = guaranteeFeeTitle;
    self.guaranteeFeeValueLabel = guaranteeFeeValue;
    
    // 其他费用
    UILabel *otherFeeTitle = nil;
    UILabel *otherFeeValue = nil;
    self.otherFeeItemView = [self createItemViewWithTitle:@"其他费用" titleLabel:&otherFeeTitle valueLabel:&otherFeeValue];
    self.otherFeeTitleLabel = otherFeeTitle;
    self.otherFeeValueLabel = otherFeeValue;
}

- (UIView *)createItemViewWithTitle:(NSString *)title titleLabel:(UILabel **)titleLabel valueLabel:(UILabel **)valueLabel {
    UIView *itemView = [[UIView alloc] init];
    [self.detailView addSubview:itemView];
    
    *titleLabel = [[UILabel alloc] init];
    (*titleLabel).text = title;
    (*titleLabel).font = [UIFont systemFontOfSize:14];
    (*titleLabel).textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0]; // #767676
    [itemView addSubview:*titleLabel];
    
    *valueLabel = [[UILabel alloc] init];
    (*valueLabel).font = [UIFont systemFontOfSize:14];
    (*valueLabel).textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0]; // #767676
    (*valueLabel).textAlignment = NSTextAlignmentRight;
    [itemView addSubview:*valueLabel];
    
    [*titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemView).offset(16);
        make.centerY.equalTo(itemView);
    }];
    
    [*valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(itemView).offset(-16);
        make.centerY.equalTo(itemView);
    }];
    
    return itemView;
}

- (void)setModel:(JJRRepaymentPlanModel *)model {
    _model = model;
    
    if (!model) return;
    
    // 更新头部信息
    self.dateLabel.text = [NSString stringWithFormat:@"还款日：%@", model.payDate ?: @""];
    
    // 创建应还金额的富文本
    NSString *amountText = [NSString stringWithFormat:@"应还金额：%.2f", model.totalAmt];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:amountText];
    
    // 设置"应还金额："部分的颜色和字体
    [attributedString addAttribute:NSForegroundColorAttributeName 
                             value:[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0] 
                             range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSFontAttributeName 
                             value:[UIFont systemFontOfSize:14] 
                             range:NSMakeRange(0, 5)];
    
    // 设置金额部分的颜色和字体
    [attributedString addAttribute:NSForegroundColorAttributeName 
                             value:[UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1.0] 
                             range:NSMakeRange(5, amountText.length - 5)];
    [attributedString addAttribute:NSFontAttributeName 
                             value:[UIFont boldSystemFontOfSize:20] 
                             range:NSMakeRange(5, amountText.length - 5)];
    
    self.amountLabel.attributedText = attributedString;
    
    // 更新箭头图标
    if (model.selected) {
        self.arrowImageView.image = [self arrowUpImage];
    } else {
        self.arrowImageView.image = [self arrowDownImage];
    }
    
    // 更新详细信息
    if (model.selected) {
        self.detailView.hidden = NO;
        
        // 统计周期
        NSString *endDate = [self addOneMonth:model.payDate];
        self.periodLabel.text = [NSString stringWithFormat:@"统计周期：%@至%@", model.payDate ?: @"", endDate];
        
        // 本期还款日
        self.payDateLabel.text = [NSString stringWithFormat:@"本期还款日：%@", model.payDate ?: @""];
        
        // 更新费用信息
        self.principalValueLabel.text = [NSString stringWithFormat:@"%.2f", model.totalAmt];
        self.interestValueLabel.text = [NSString stringWithFormat:@"%.2f", model.interest];
        self.serviceFeeValueLabel.text = [NSString stringWithFormat:@"%.2f", model.serviceFee];
        self.guaranteeFeeValueLabel.text = [NSString stringWithFormat:@"%.2f", model.guaranteeFee];
        self.otherFeeValueLabel.text = [NSString stringWithFormat:@"%.2f", model.otherFee];
    } else {
        self.detailView.hidden = YES;
    }
}

+ (CGFloat)cellHeightForModel:(JJRRepaymentPlanModel *)model {
    if (model.selected) {
        // 展开状态：头部(80) + 周期和还款日(36) + 分割线(1) + 5个费用项目(20*5) + 间距(10*4) + 底部边距(14) + 卡片边距(12)
        return 80 + 36 + 1 + 100 + 40 + 14 + 12;
    } else {
        // 收起状态：头部(80) + 卡片边距(12)
        return 80 + 12;
    }
}

- (NSString *)addOneMonth:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date = [formatter dateFromString:dateStr];
    if (!date) return dateStr;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    return [formatter stringFromDate:newDate];
}

- (UIImage *)arrowDownImage {
    // 创建向下箭头图标
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(12, 12), NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(2, 4)];
    [path addLineToPoint:CGPointMake(6, 8)];
    [path addLineToPoint:CGPointMake(10, 4)];
    path.lineWidth = 1.5;
    [[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.0] setStroke]; // #AAAAAA
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)arrowUpImage {
    // 创建向上箭头图标
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(12, 12), NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(2, 8)];
    [path addLineToPoint:CGPointMake(6, 4)];
    [path addLineToPoint:CGPointMake(10, 8)];
    path.lineWidth = 1.5;
    [[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.0] setStroke]; // #AAAAAA
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end 
