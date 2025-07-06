#import "JJRCityPickerViewController.h"
#import <Masonry/Masonry.h>

@interface JJRCityPickerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *indexView;
@property (nonatomic, strong) NSArray *cityData;
@property (nonatomic, strong) NSArray *indexLetters;

@end

@implementation JJRCityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    // 加载与uni-app相同的本地city.json数据
    [self loadCityDataFromLocalFile];
    
    self.indexLetters = @[@"*", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

- (void)loadCityDataFromLocalFile {
    // 获取city.json文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    
    if (!filePath) {
        NSLog(@"找不到city.json文件");
        [self setupFallbackData];
        return;
    }
    
    // 读取文件内容
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        NSLog(@"无法读取city.json文件");
        [self setupFallbackData];
        return;
    }
    
    // 解析JSON数据
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error || !jsonDict) {
        NSLog(@"解析city.json失败: %@", error);
        [self setupFallbackData];
        return;
    }
    
    // 获取城市数据
    NSArray *cityArray = jsonDict[@"city"];
    if (!cityArray) {
        NSLog(@"city.json格式错误，找不到city数组");
        [self setupFallbackData];
        return;
    }
    
    self.cityData = cityArray;
    NSLog(@"成功加载城市数据，共%lu个字母分组", (unsigned long)self.cityData.count);
}

- (void)setupFallbackData {
    // 备用数据，如果无法加载本地文件时使用
    self.cityData = @[
        @{
            @"initial": @"A",
            @"list": @[
                @{@"code": @"610900", @"name": @"安康"},
                @{@"code": @"340800", @"name": @"安庆"},
                @{@"code": @"210300", @"name": @"鞍山"},
                @{@"code": @"520400", @"name": @"安顺"},
                @{@"code": @"410500", @"name": @"安阳"}
            ]
        },
        @{
            @"initial": @"B",
            @"list": @[
                @{@"code": @"110000", @"name": @"北京"},
                @{@"code": @"130600", @"name": @"保定"},
                @{@"code": @"610300", @"name": @"宝鸡"},
                @{@"code": @"150200", @"name": @"包头"}
            ]
        }
    ];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建头部区域
    [self setupHeaderView];
    
    // 创建表格视图
    [self setupTableView];
    
    // 创建右侧索引
    [self setupIndexView];
}

- (void)setupHeaderView {
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.5];
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    // 当前城市区域
    UIView *currentCityView = [[UIView alloc] init];
    [self.headerView addSubview:currentCityView];
    
    [currentCityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(15);
        make.centerY.equalTo(self.headerView);
    }];
    
    // 定位图标
    UIImageView *locationIcon = [[UIImageView alloc] init];
    locationIcon.image = [UIImage systemImageNamed:@"location.fill"];
    locationIcon.tintColor = [UIColor blackColor];
    [currentCityView addSubview:locationIcon];
    
    [locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(currentCityView);
        make.width.height.mas_equalTo(16);
    }];
    
    UILabel *currentLabel = [[UILabel alloc] init];
    currentLabel.text = @"当前城市：";
    currentLabel.font = [UIFont systemFontOfSize:15];
    currentLabel.textColor = [UIColor blackColor];
    [currentCityView addSubview:currentLabel];
    
    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationIcon.mas_right).offset(5);
        make.centerY.equalTo(currentCityView);
    }];
    
    UILabel *cityNameLabel = [[UILabel alloc] init];
    cityNameLabel.text = self.currentCityName ?: @"未知";
    cityNameLabel.font = [UIFont systemFontOfSize:15];
    cityNameLabel.textColor = [UIColor blackColor];
    [currentCityView addSubview:cityNameLabel];
    
    [cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentLabel.mas_right);
        make.centerY.equalTo(currentCityView);
        make.right.equalTo(currentCityView);
    }];
    
    // 重新定位按钮
    UIButton *relocateButton = [[UIButton alloc] init];
    [self.headerView addSubview:relocateButton];
    
    // 重新定位图标
    UIImageView *reloadIcon = [[UIImageView alloc] init];
    reloadIcon.image = [UIImage systemImageNamed:@"arrow.clockwise"];
    reloadIcon.tintColor = [UIColor blackColor];
    [relocateButton addSubview:reloadIcon];
    
    // 重新定位文字
    UILabel *relocateLabel = [[UILabel alloc] init];
    relocateLabel.text = @"重新定位";
    relocateLabel.font = [UIFont systemFontOfSize:15];
    relocateLabel.textColor = [UIColor blackColor];
    [relocateButton addSubview:relocateLabel];
    
    [relocateButton addTarget:self action:@selector(relocateButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [relocateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-15);
        make.centerY.equalTo(self.headerView);
    }];
    
    [reloadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(relocateButton);
        make.width.height.mas_equalTo(14);
    }];
    
    [relocateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reloadIcon.mas_right).offset(3);
        make.centerY.equalTo(relocateButton);
        make.right.equalTo(relocateButton);
    }];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HotCityCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CityCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SectionHeaderCell"];
}

- (void)setupIndexView {
    self.indexView = [[UIView alloc] init];
    [self.view addSubview:self.indexView];
    
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(self.headerView.mas_bottom).offset(30);
        make.width.mas_equalTo(30);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    
    CGFloat buttonHeight = 18;
    for (NSInteger i = 0; i < self.indexLetters.count; i++) {
        UIButton *indexButton = [[UIButton alloc] init];
        [indexButton setTitle:self.indexLetters[i] forState:UIControlStateNormal];
        [indexButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [indexButton setTitleColor:[UIColor colorWithRed:0.27 green:0.38 blue:0.85 alpha:1.0] forState:UIControlStateHighlighted];
        indexButton.titleLabel.font = [UIFont systemFontOfSize:11];
        indexButton.tag = i;
        [indexButton addTarget:self action:@selector(indexButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.indexView addSubview:indexButton];
        
        [indexButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.indexView);
            make.top.equalTo(self.indexView).offset(i * buttonHeight);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(buttonHeight);
        }];
    }
}

#pragma mark - Actions

- (void)relocateButtonTapped {
    // 重新定位逻辑
    NSLog(@"重新定位");
}

- (void)indexButtonTapped:(UIButton *)button {
    NSString *letter = self.indexLetters[button.tag];
    
    if ([letter isEqualToString:@"*"]) {
        // 滚动到热门城市
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        // 查找对应字母的section
        for (NSInteger i = 0; i < self.cityData.count; i++) {
            NSDictionary *section = self.cityData[i];
            if ([section[@"initial"] isEqualToString:letter]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i + 1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityData.count + 1; // +1 for hot cities section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // 热门城市section：标题 + 热门城市网格
        return 2;
    } else {
        // 普通城市section：字母标题 + 城市列表
        NSDictionary *sectionData = self.cityData[section - 1];
        NSArray *cities = sectionData[@"list"];
        return 1 + cities.count; // 1 for header + cities
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 热门城市标题
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionHeaderCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 清除之前的子视图
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
            
            UIImageView *fireIcon = [[UIImageView alloc] init];
            fireIcon.image = [UIImage systemImageNamed:@"flame.fill"];
            fireIcon.tintColor = [UIColor redColor];
            [cell.contentView addSubview:fireIcon];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"热门城市";
            titleLabel.font = [UIFont systemFontOfSize:15];
            titleLabel.textColor = [UIColor blackColor];
            [cell.contentView addSubview:titleLabel];
            
            [fireIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.centerY.equalTo(cell.contentView);
                make.width.height.mas_equalTo(16);
            }];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(fireIcon.mas_right).offset(5);
                make.centerY.equalTo(cell.contentView);
            }];
            
            return cell;
        } else {
            // 热门城市网格
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCityCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 清除之前的子视图
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
            
            // 创建热门城市网格
            [self createHotCityGridInCell:cell];
            
            return cell;
        }
    } else {
        NSDictionary *sectionData = self.cityData[indexPath.section - 1];
        
        if (indexPath.row == 0) {
            // 字母标题
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionHeaderCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
            
            // 清除之前的子视图
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
            
            UILabel *letterLabel = [[UILabel alloc] init];
            letterLabel.text = sectionData[@"initial"];
            letterLabel.font = [UIFont systemFontOfSize:12];
            letterLabel.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.0];
            [cell.contentView addSubview:letterLabel];
            
            [letterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(25);
                make.centerY.equalTo(cell.contentView);
            }];
            
            return cell;
        } else {
            // 城市名称
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 清除之前的子视图
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
            
            NSArray *cities = sectionData[@"list"];
            NSDictionary *city = cities[indexPath.row - 1];
            
            UILabel *cityLabel = [[UILabel alloc] init];
            cityLabel.text = city[@"name"];
            cityLabel.font = [UIFont systemFontOfSize:15];
            cityLabel.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
            [cell.contentView addSubview:cityLabel];
            
            [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(25);
                make.centerY.equalTo(cell.contentView);
            }];
            
            // 添加背景色（偶数行）
            if ((indexPath.row - 1) % 2 == 1) {
                cell.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:0.12];
            } else {
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            return cell;
        }
    }
}

- (void)createHotCityGridInCell:(UITableViewCell *)cell {
    if (!self.hotCities || self.hotCities.count == 0) {
        return;
    }
    
    UIView *containerView = [[UIView alloc] init];
    [cell.contentView addSubview:containerView];
    
    // 增加右侧间距，避免与字母索引重叠
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.right.equalTo(cell.contentView).offset(-45); // 原来是-15，现在是-45，增加了30px间距
        make.top.equalTo(cell.contentView).offset(10);
        make.bottom.equalTo(cell.contentView).offset(-10);
    }];
    
    NSInteger columns = 3;
    CGFloat buttonHeight = 35;
    CGFloat spacing = 10;
    
    // 根据容器实际宽度计算按钮宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat containerWidth = screenWidth - 15 - 45; // 左边距15 + 右边距45
    CGFloat buttonWidth = (containerWidth - (columns - 1) * spacing) / columns;
    
    NSInteger totalRows = (self.hotCities.count + columns - 1) / columns;
    
    for (NSInteger i = 0; i < self.hotCities.count; i++) {
        NSDictionary *city = self.hotCities[i];
        
        UIButton *cityButton = [[UIButton alloc] init];
        [cityButton setTitle:city[@"name"] forState:UIControlStateNormal];
        [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cityButton.titleLabel.font = [UIFont systemFontOfSize:13];
        cityButton.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:0.2];
        cityButton.layer.cornerRadius = 3;
        cityButton.tag = i;
        [cityButton addTarget:self action:@selector(hotCityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:cityButton];
        
        NSInteger row = i / columns;
        NSInteger col = i % columns;
        
        [cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView).offset(row * (buttonHeight + spacing));
            make.left.equalTo(containerView).offset(col * (buttonWidth + spacing));
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(buttonHeight);
        }];
    }
    
    // 设置容器高度
    CGFloat totalHeight = totalRows * buttonHeight + (totalRows - 1) * spacing;
    [containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40; // 热门城市标题
        } else {
            // 热门城市网格高度
            NSInteger rows = (self.hotCities.count + 2) / 3; // 3列
            return rows * 45 + 20; // 按钮高度35 + 间距10 + 上下边距
        }
    } else {
        if (indexPath.row == 0) {
            return 30; // 字母标题
        } else {
            return 45; // 城市行
        }
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.row == 0) {
        return; // 不处理标题行的点击
    }
    
    NSDictionary *sectionData = self.cityData[indexPath.section - 1];
    NSArray *cities = sectionData[@"list"];
    NSDictionary *city = cities[indexPath.row - 1];
    
    if (self.citySelectedBlock) {
        self.citySelectedBlock(city[@"name"], city[@"code"]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hotCityButtonTapped:(UIButton *)button {
    // 过滤有效的城市数据，与createHotCityGridInCell中的逻辑保持一致
    NSMutableArray *validCities = [NSMutableArray array];
    for (NSDictionary *city in self.hotCities) {
        if (city[@"name"] && [city[@"name"] length] > 0) {
            [validCities addObject:city];
        }
    }
    
    if (button.tag < validCities.count) {
        NSDictionary *city = validCities[button.tag];
        
        if (self.citySelectedBlock) {
            self.citySelectedBlock(city[@"name"], city[@"code"]);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end 