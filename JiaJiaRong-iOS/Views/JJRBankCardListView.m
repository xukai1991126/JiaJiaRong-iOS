//
//  JJRBankCardListView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBankCardListView.h"
#import "JJRBankCardCell.h"

@interface JJRBankCardListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<JJRBankCardModel *> *bankCards;
@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation JJRBankCardListView

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
    
    // 表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.tableView registerClass:[JJRBankCardCell class] forCellReuseIdentifier:@"JJRBankCardCell"];
    [self addSubview:self.tableView];
    
    // 空状态标签
    self.emptyLabel = [[UILabel alloc] init];
    self.emptyLabel.text = @"暂无银行卡，点击右上角添加";
    self.emptyLabel.font = [UIFont systemFontOfSize:16];
    self.emptyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyLabel.hidden = YES;
    [self addSubview:self.emptyLabel];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
}

- (void)updateBankCards:(NSArray<JJRBankCardModel *> *)bankCards {
    self.bankCards = bankCards;
    [self.tableView reloadData];
    
    self.emptyLabel.hidden = bankCards.count > 0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJRBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJRBankCardCell"];
    cell.bankCard = self.bankCards[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(JJRBankCardModel *bankCard) {
        if (weakSelf.deleteBankCardBlock) {
            weakSelf.deleteBankCardBlock(bankCard);
        }
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectBankCardBlock) {
        self.selectBankCardBlock(self.bankCards[indexPath.row]);
    }
}

@end 