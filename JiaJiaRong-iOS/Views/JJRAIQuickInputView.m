//
//  JJRAIQuickInputView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAIQuickInputView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface JJRAIQuickInputView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JJRAIUserProfile *userProfile;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *formData;
@property (nonatomic, strong) NSMutableDictionary *selectedValues;

@end

@implementation JJRAIQuickInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupData {
    self.userProfile = [[JJRAIUserProfile alloc] init];
    self.selectedValues = [[NSMutableDictionary alloc] init];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 16;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 8;
    
    [self setupTableView];
    [self loadDefaultFormData];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).inset(16);
    }];
}

- (void)loadDefaultFormData {
    // 默认表单数据，匹配uni-app的字段
    NSArray *defaultData = @[
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"有"},
                @{@"key": @"0", @"name": @"无"}
            ],
            @"field": @"house",
            @"fieldName": @"房"
        },
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"有"},
                @{@"key": @"0", @"name": @"无"}
            ],
            @"field": @"car",
            @"fieldName": @"车"
        },
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"有"},
                @{@"key": @"0", @"name": @"无"}
            ],
            @"field": @"socialSecurity",
            @"fieldName": @"社保"
        },
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"有"},
                @{@"key": @"0", @"name": @"无"}
            ],
            @"field": @"providentFund",
            @"fieldName": @"公积金"
        },
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"公务员"},
                @{@"key": @"2", @"name": @"上班族"},
                @{@"key": @"3", @"name": @"自由职业"},
                @{@"key": @"4", @"name": @"个体户"},
                @{@"key": @"5", @"name": @"企业主"}
            ],
            @"field": @"occupation",
            @"fieldName": @"职业"
        },
        @{
            @"conditionList": @[
                @{@"key": @"0", @"name": @"无"},
                @{@"key": @"1", @"name": @"0~4000"},
                @{@"key": @"2", @"name": @"4000~8000"},
                @{@"key": @"3", @"name": @"8000~12000"},
                @{@"key": @"4", @"name": @"12000~16000"},
                @{@"key": @"5", @"name": @"16000~20000"},
                @{@"key": @"6", @"name": @"20000~25000"},
                @{@"key": @"7", @"name": @">25000"}
            ],
            @"field": @"monthlyIncome",
            @"fieldName": @"月收入"
        },
        @{
            @"conditionList": @[
                @{@"key": @"3", @"name": @"3期"},
                @{@"key": @"6", @"name": @"6期"},
                @{@"key": @"12", @"name": @"12期"},
                @{@"key": @"24", @"name": @"24期"},
                @{@"key": @"36", @"name": @"36期"}
            ],
            @"field": @"stageNum",
            @"fieldName": @"贷款期限"
        }
    ];
    
    self.formData = defaultData;
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.formData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *formItem = self.formData[section];
    NSArray *conditionList = formItem[@"conditionList"];
    return conditionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FormCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置cell的外观
        cell.layer.cornerRadius = 8;
        cell.layer.masksToBounds = YES;
        
        // 调整textLabel的位置
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    
    NSDictionary *formItem = self.formData[indexPath.section];
    NSArray *conditionList = formItem[@"conditionList"];
    NSDictionary *condition = conditionList[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"   %@", condition[@"name"]]; // 添加一些左边距
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    // 检查是否选中
    NSString *field = formItem[@"field"];
    NSString *selectedValue = self.selectedValues[field];
    NSString *currentValue = condition[@"key"];
    
    if ([selectedValue isEqualToString:currentValue]) {
        cell.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *formItem = self.formData[indexPath.section];
    NSArray *conditionList = formItem[@"conditionList"];
    NSDictionary *selectedCondition = conditionList[indexPath.row];
    
    NSString *field = formItem[@"field"];
    NSString *selectedValue = selectedCondition[@"key"];
    
    // 保存选择
    self.selectedValues[field] = selectedValue;
    
    // 刷新这个section
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    // 更新用户资料
    [self updateUserProfileFromSelections];
    
    // 通知委托
    if ([self.delegate respondsToSelector:@selector(quickInputView:didUpdateUserProfile:)]) {
        [self.delegate quickInputView:self didUpdateUserProfile:self.userProfile];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56; // 稍微增加高度，营造更好的视觉效果
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60; // 为section标题提供更多空间
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10; // 在section之间添加小间距
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    NSDictionary *formItem = self.formData[section];
    titleLabel.text = [NSString stringWithFormat:@"📋 %@", formItem[@"fieldName"]];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    [headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(16);
        make.centerY.equalTo(headerView);
    }];
    
    return headerView;
}

#pragma mark - Helper Methods

- (void)updateUserProfileFromSelections {
    // 根据选择更新用户资料
    
    // 房产
    NSString *houseValue = self.selectedValues[@"house"];
    self.userProfile.hasHouse = [houseValue isEqualToString:@"1"];
    
    // 车辆
    NSString *carValue = self.selectedValues[@"car"];
    self.userProfile.hasCar = [carValue isEqualToString:@"1"];
    
    // 职业
    NSString *occupationValue = self.selectedValues[@"occupation"];
    if (occupationValue) {
        NSArray *occupationMap = @[@"", @"公务员", @"上班族", @"自由职业", @"个体户", @"企业主"];
        NSInteger occupationIndex = [occupationValue integerValue];
        if (occupationIndex > 0 && occupationIndex < occupationMap.count) {
            self.userProfile.employmentType = occupationMap[occupationIndex];
        }
    }
    
    // 月收入
    NSString *incomeValue = self.selectedValues[@"monthlyIncome"];
    if (incomeValue) {
        NSArray *incomeMap = @[@0, @2000, @6000, @10000, @14000, @18000, @22500, @30000];
        NSInteger incomeIndex = [incomeValue integerValue];
        if (incomeIndex < incomeMap.count) {
            self.userProfile.monthlyIncome = incomeMap[incomeIndex];
        }
    }
    
    // 设置一些默认值
    if ([self.userProfile.monthlyIncome doubleValue] > 0) {
        self.userProfile.monthlyExpense = @([self.userProfile.monthlyIncome doubleValue] * 0.6);
    }
    if (!self.userProfile.currentDebt) {
        self.userProfile.currentDebt = @0;
    }
    if (self.userProfile.workYears == 0) {
        self.userProfile.workYears = 3;
    }
    if ([self.userProfile.creditScore integerValue] == 0) {
        self.userProfile.creditScore = @650; // 默认良好信用
    }
    if (self.userProfile.age == 0) {
        self.userProfile.age = 30; // 默认年龄
    }
}

#pragma mark - Public Methods

- (BOOL)hasValidSelection {
    // 检查必要的字段是否已选择
    NSArray *requiredFields = @[@"monthlyIncome", @"occupation"];
    for (NSString *field in requiredFields) {
        if (!self.selectedValues[field]) {
            return NO;
        }
    }
    return YES;
}

- (CGSize)intrinsicContentSize {
    // 返回内容的固有尺寸，确保高度正确
    CGFloat tableHeight = self.tableView.contentSize.height;
    CGFloat totalHeight = tableHeight + 32; // 加上内边距
    
    // 确保最小高度
    totalHeight = MAX(totalHeight, 400);
    
    return CGSizeMake(UIViewNoIntrinsicMetric, totalHeight);
}

- (void)resetToDefault {
    NSLog(@"🔄 重置快速输入视图到默认状态");
    
    // 清空所有选择
    [self.selectedValues removeAllObjects];
    
    // 重置用户资料
    self.userProfile = [[JJRAIUserProfile alloc] init];
    
    // 刷新表格视图
    [self.tableView reloadData];
    
    // 🔧 确保在主线程中进行UI更新，并延迟一帧以确保reloadData完成
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 滚动到顶部，显示第一个选择框
            [self.tableView setContentOffset:CGPointZero animated:NO];
            
            // 通知系统重新计算内容尺寸
            [self invalidateIntrinsicContentSize];
            
            // 强制重新布局以确保正确的高度
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            // 确保表格视图也重新布局
            [self.tableView setNeedsLayout];
            [self.tableView layoutIfNeeded];
            
            NSLog(@"🔧 重置后的表格视图frame: %@", NSStringFromCGRect(self.tableView.frame));
            NSLog(@"🔧 重置后的输入视图frame: %@", NSStringFromCGRect(self.frame));
            NSLog(@"🔧 重置后的表格内容尺寸: %@", NSStringFromCGSize(self.tableView.contentSize));
        });
    });
    
    // 通知代理更新
    if (self.delegate && [self.delegate respondsToSelector:@selector(quickInputView:didUpdateUserProfile:)]) {
        [self.delegate quickInputView:self didUpdateUserProfile:self.userProfile];
    }
    
    NSLog(@"✅ 快速输入视图已重置完成");
}

@end 