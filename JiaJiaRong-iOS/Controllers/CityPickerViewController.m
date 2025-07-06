#import "CityPickerViewController.h"

@interface CityPickerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *allCities;

@end

@implementation CityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadCityData];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择城市";
    
    // 导航栏按钮
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" 
                                                                     style:UIBarButtonItemStylePlain 
                                                                    target:self 
                                                                    action:@selector(closeButtonTapped)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    // 创建表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)loadCityData {
    // 模拟城市数据，实际应该从服务器获取
    self.allCities = @[
        @{@"name": @"北京市", @"code": @"110000"},
        @{@"name": @"上海市", @"code": @"310000"},
        @{@"name": @"广州市", @"code": @"440100"},
        @{@"name": @"深圳市", @"code": @"440300"},
        @{@"name": @"杭州市", @"code": @"330100"},
        @{@"name": @"南京市", @"code": @"320100"},
        @{@"name": @"成都市", @"code": @"510100"},
        @{@"name": @"武汉市", @"code": @"420100"},
        @{@"name": @"西安市", @"code": @"610100"},
        @{@"name": @"重庆市", @"code": @"500000"}
    ];
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // 热门城市 + 全部城市
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotCities.count;
    } else {
        return self.allCities.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSDictionary *city = self.hotCities[indexPath.row];
        cell.textLabel.text = city[@"name"];
    } else {
        NSDictionary *city = self.allCities[indexPath.row];
        cell.textLabel.text = city[@"name"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"热门城市";
    } else {
        return @"全部城市";
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *city;
    
    if (indexPath.section == 0) {
        city = self.hotCities[indexPath.row];
    } else {
        city = self.allCities[indexPath.row];
    }
    
    if (self.citySelectedBlock) {
        self.citySelectedBlock(city[@"name"], city[@"code"]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end 