#import "BankCardListViewController.h"
#import "BankCardAddViewController.h"
#import "NetworkService.h"
#import <Masonry/Masonry.h>

@interface BankCardListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *bankCards;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIBarButtonItem *addButton;

@end

@implementation BankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchBankCards];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"我的银行卡";
    
    // 添加按钮
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                    target:self 
                                                                    action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    // 表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    // 空状态视图
    self.emptyView = [[UIView alloc] init];
    [self.view addSubview:self.emptyView];
    
    UIImageView *emptyImageView = [[UIImageView alloc] init];
    emptyImageView.image = [UIImage systemImageNamed:@"creditcard"];
    emptyImageView.tintColor = [UIColor lightGrayColor];
    [self.emptyView addSubview:emptyImageView];
    
    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.text = @"暂无银行卡";
    emptyLabel.font = [UIFont systemFontOfSize:16];
    emptyLabel.textColor = [UIColor lightGrayColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:emptyLabel];
    
    UIButton *addCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCardButton setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [addCardButton setTitleColor:[UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    addCardButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addCardButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.emptyView addSubview:addCardButton];
    
    // 设置约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(self.emptyView);
        make.width.height.mas_equalTo(80);
    }];
    
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(emptyImageView.mas_bottom).offset(20);
    }];
    
    [addCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(emptyLabel.mas_bottom).offset(20);
    }];
    
    self.emptyView.hidden = YES;
}

- (void)fetchBankCards {
    [NetworkService showLoading];
    
    [[NetworkService sharedInstance] GET:@"/app/userinfo/bankcard/list" 
                                   params:nil 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleBankCardsData:response[@"data"] ?: @[]];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"获取银行卡列表失败"];
        });
    }];
}

- (void)handleBankCardsData:(NSArray *)data {
    self.bankCards = data;
    
    if (data.count == 0) {
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

- (void)addButtonTapped {
    BankCardAddViewController *addVC = [[BankCardAddViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BankCardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 12;
        cell.layer.masksToBounds = YES;
        
        // 银行卡背景
        UIView *cardView = [[UIView alloc] init];
        cardView.tag = 100;
        cardView.layer.cornerRadius = 12;
        [cell.contentView addSubview:cardView];
        
        // 银行名称
        UILabel *bankNameLabel = [[UILabel alloc] init];
        bankNameLabel.tag = 101;
        bankNameLabel.font = [UIFont boldSystemFontOfSize:18];
        bankNameLabel.textColor = [UIColor whiteColor];
        [cardView addSubview:bankNameLabel];
        
        // 卡号
        UILabel *cardNumberLabel = [[UILabel alloc] init];
        cardNumberLabel.tag = 102;
        cardNumberLabel.font = [UIFont systemFontOfSize:16];
        cardNumberLabel.textColor = [UIColor whiteColor];
        [cardView addSubview:cardNumberLabel];
        
        // 卡类型
        UILabel *cardTypeLabel = [[UILabel alloc] init];
        cardTypeLabel.tag = 103;
        cardTypeLabel.font = [UIFont systemFontOfSize:14];
        cardTypeLabel.textColor = [UIColor whiteColor];
        [cardView addSubview:cardTypeLabel];
        
        // 删除按钮
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.tag = 104;
        [deleteButton setImage:[UIImage systemImageNamed:@"trash"] forState:UIControlStateNormal];
        [deleteButton setTintColor:[UIColor whiteColor]];
        [cell.contentView addSubview:deleteButton];
        
        // 设置约束
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(cell.contentView).inset(10);
            make.bottom.equalTo(cell.contentView).offset(-10);
        }];
        
        [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(cardView).offset(20);
        }];
        
        [cardNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cardView).offset(20);
            make.centerY.equalTo(cardView);
        }];
        
        [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cardView).offset(20);
            make.bottom.equalTo(cardView).offset(-20);
        }];
        
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-20);
            make.centerY.equalTo(cell.contentView);
            make.width.height.mas_equalTo(30);
        }];
    }
    
    // 配置数据
    NSDictionary *card = self.bankCards[indexPath.row];
    
    UIView *cardView = [cell.contentView viewWithTag:100];
    UILabel *bankNameLabel = [cell.contentView viewWithTag:101];
    UILabel *cardNumberLabel = [cell.contentView viewWithTag:102];
    UILabel *cardTypeLabel = [cell.contentView viewWithTag:103];
    UIButton *deleteButton = [cell.contentView viewWithTag:104];
    
    // 设置银行卡背景颜色
    NSString *bankName = card[@"bankName"] ?: @"";
    if ([bankName containsString:@"工商"]) {
        cardView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:80.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if ([bankName containsString:@"建设"]) {
        cardView.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    } else if ([bankName containsString:@"农业"]) {
        cardView.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:175.0/255.0 blue:80.0/255.0 alpha:1.0];
    } else if ([bankName containsString:@"中国"]) {
        cardView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:67.0/255.0 blue:54.0/255.0 alpha:1.0];
    } else {
        cardView.backgroundColor = [UIColor colorWithRed:156.0/255.0 green:39.0/255.0 blue:176.0/255.0 alpha:1.0];
    }
    
    bankNameLabel.text = bankName;
    cardNumberLabel.text = [NSString stringWithFormat:@"**** **** **** %@", card[@"cardNo"] ?: @""];
    cardTypeLabel.text = card[@"cardType"] ?: @"储蓄卡";
    
    // 设置删除按钮事件
    deleteButton.tag = indexPath.row;
    [deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)deleteButtonTapped:(UIButton *)sender {
    NSInteger index = sender.tag;
    NSDictionary *card = self.bankCards[index];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除" 
                                                                   message:@"确定要删除这张银行卡吗？" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:nil];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" 
                                                           style:UIAlertActionStyleDestructive 
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self deleteBankCard:card[@"id"]];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteBankCard:(NSString *)cardId {
    [NetworkService showLoading];
    
    NSDictionary *params = @{@"id": cardId};
    [[NetworkService sharedInstance] POST:@"/app/userinfo/bankcard/delete" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"删除成功"];
            [self fetchBankCards];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"删除失败，请重试"];
        });
    }];
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end 