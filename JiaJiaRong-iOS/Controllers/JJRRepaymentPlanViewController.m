//
//  JJRRepaymentPlanViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/01/01.
//

#import "JJRRepaymentPlanViewController.h"
#import "JJRRepaymentPlanCell.h"
#import "JJRRepaymentPlanModel.h"
#import "JJRNetworkService.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface JJRRepaymentPlanViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerBgImageView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UILabel *totalAmountLabel;
@property (nonatomic, strong) UIImageView *headerDecorationImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, strong) NSMutableArray<JJRRepaymentPlanModel *> *userRepaymentList;
@property (nonatomic, assign) CGFloat zongdaihuan; // 总待还金额

@end

@implementation JJRRepaymentPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]; // #f7f7f7
    
    // 初始化数据
    self.userRepaymentList = [NSMutableArray array];
    self.zongdaihuan = 0.0;
    
    [self setupUI];
    [self loadRepaymentPlan];
}

- (void)setupUI {
    // 设置导航栏
    self.navigationItem.title = @"还款计划";
    
    // 创建头部视图
    [self createHeaderView];
    
    // 创建TableView
    [self createTableView];
    
    // 创建空状态视图
    [self createEmptyView];
}

- (void)createHeaderView {
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headerView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#F2582B"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1"].CGColor,
    ];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    gradientLayer.cornerRadius = 16.0;
    [self.headerView.layer insertSublayer:gradientLayer atIndex:0];
    
    // 头部标题
    self.headerTitleLabel = [[UILabel alloc] init];
    self.headerTitleLabel.text = @"全部待还(元)";
    self.headerTitleLabel.textColor = [UIColor whiteColor];
    self.headerTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:self.headerTitleLabel];
    
    // 总金额标签
    self.totalAmountLabel = [[UILabel alloc] init];
    self.totalAmountLabel.text = @"0.00";
    self.totalAmountLabel.textColor = [UIColor whiteColor];
    self.totalAmountLabel.font = [UIFont boldSystemFontOfSize:26];
    [self.headerView addSubview:self.totalAmountLabel];
    
    // 装饰图片
    self.headerDecorationImageView = [[UIImageView alloc] init];
    self.headerDecorationImageView.image = [UIImage imageNamed:@"img_e6b5f66d0b2a"];
    self.headerDecorationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerView addSubview:self.headerDecorationImageView];
    
    // 设置约束
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(15);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
        make.height.mas_equalTo(88);
    }];
    
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(16);
        make.top.equalTo(self.headerView).offset(14);
    }];
    
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerTitleLabel);
        make.top.equalTo(self.headerTitleLabel.mas_bottom).offset(10);
    }];
    
    [self.headerDecorationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-16);
        make.centerY.equalTo(self.headerView);
        make.width.height.mas_equalTo(68);
    }];
    
    // 异步设置渐变层frame
    dispatch_async(dispatch_get_main_queue(), ^{
        gradientLayer.frame = self.headerView.bounds;
    });
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    // 注册Cell
    [self.tableView registerClass:[JJRRepaymentPlanCell class] forCellReuseIdentifier:@"JJRRepaymentPlanCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(15);
        make.top.equalTo(self.headerView.mas_bottom).offset(12);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

- (void)createEmptyView {
    self.emptyView = [[UIView alloc] init];
    self.emptyView.backgroundColor = [UIColor clearColor];
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    
    self.emptyImageView = [[UIImageView alloc] init];
    self.emptyImageView.image = [UIImage imageNamed:@"img_67c7518aff85"];
    self.emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.emptyView addSubview:self.emptyImageView];
    
    self.emptyLabel = [[UILabel alloc] init];
    self.emptyLabel.text = @"没有还款金额";
    self.emptyLabel.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0]; // #767676
    self.emptyLabel.font = [UIFont systemFontOfSize:14];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:self.emptyLabel];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(220);
    }];
    
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(self.emptyView);
        make.width.height.mas_equalTo(200);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.bottom.equalTo(self.emptyView).offset(-5);
    }];
}

- (void)loadRepaymentPlan {
    if (!self.loanNo || self.loanNo.length == 0) {
        NSLog(@"❌ loanNo为空，无法加载还款计划");
        return;
    }
    
    // 显示加载提示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"加载中...";
    
    // 完全按照uni-app的逻辑调用接口
    [[JJRNetworkService sharedInstance] getRepaymentPlanWithLoanNo:self.loanNo success:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"✅ 还款计划数据加载成功");
        
        // 解析数据
        NSArray *dataArray = response[@"data"];
        if (!dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
            NSLog(@"❌ 数据格式错误");
            [self updateUIWithEmptyData];
            return;
        }
        
        // 完全按照uni-app的逻辑处理数据
        if (dataArray.count == 0) {
            [self updateUIWithEmptyData];
            return;
        }
        
        // 转换数据为模型对象，并添加selected属性
        [self.userRepaymentList removeAllObjects];
        for (NSDictionary *item in dataArray) {
            JJRRepaymentPlanModel *model = [[JJRRepaymentPlanModel alloc] initWithDictionary:item];
            model.selected = NO; // 按照uni-app逻辑，默认都不选中
            [self.userRepaymentList addObject:model];
        }
        
        // 计算总待还金额：只统计status==1的项目
        self.zongdaihuan = 0.0;
        for (JJRRepaymentPlanModel *model in self.userRepaymentList) {
            if (model.status == 1) {
                self.zongdaihuan += model.totalAmt;
            }
        }
        
        // 默认展开第一个项目
        if (self.userRepaymentList.count > 0) {
            self.userRepaymentList[0].selected = YES;
        }
        
        [self updateUIWithData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"❌ 还款计划加载失败: %@", error.localizedDescription);
        
        // 显示错误提示
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"加载失败";
        [hud hideAnimated:YES afterDelay:2.0];
        
        [self updateUIWithEmptyData];
    }];
}

- (void)updateUIWithData {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新头部总金额显示
        self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2f", self.zongdaihuan];
        
        // 隐藏空状态，显示列表
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
        
        // 刷新表格
        [self.tableView reloadData];
    });
}

- (void)updateUIWithEmptyData {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 清空数据
        [self.userRepaymentList removeAllObjects];
        self.zongdaihuan = 0.0;
        
        // 更新头部总金额显示
        self.totalAmountLabel.text = @"0.00";
        
        // 显示空状态，隐藏列表
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userRepaymentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJRRepaymentPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJRRepaymentPlanCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.userRepaymentList.count) {
        JJRRepaymentPlanModel *model = self.userRepaymentList[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.userRepaymentList.count) {
        JJRRepaymentPlanModel *model = self.userRepaymentList[indexPath.row];
        return [JJRRepaymentPlanCell cellHeightForModel:model];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.userRepaymentList.count) {
        // 完全按照uni-app的onSelectCard逻辑：切换选中状态
        JJRRepaymentPlanModel *model = self.userRepaymentList[indexPath.row];
        model.selected = !model.selected;
        
        // 刷新对应的cell
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - 工具方法

- (NSString *)addOneMonth:(NSString *)dateStr {
    // 按照uni-app的addOneMonth逻辑：增加一个月
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

@end 
