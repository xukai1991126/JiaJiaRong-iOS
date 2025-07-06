#import "WebViewController.h"
#import "JJRNetworkService.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>

@interface WebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadWebContent];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 根据协议类型设置标题
    if (self.agreementType) {
        if ([self.agreementType isEqualToString:@"user"]) {
            self.title = @"服务协议";
        } else if ([self.agreementType isEqualToString:@"privacy"]) {
            self.title = @"隐私协议";
        } else {
            self.title = @"协议";
        }
    } else {
        self.title = self.titleString ?: @"网页";
    }
    
    // 进度条
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.view addSubview:self.progressView];
    
    // WebView
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    // 设置约束
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(2);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // 监听加载进度
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)loadWebContent {
    if (self.agreementType) {
        // 如果是协议类型，通过API获取协议内容
        [self loadAgreementContent];
    } else if (self.urlString) {
        // 如果是URL，直接加载
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (void)loadAgreementContent {
    [JJRNetworkService showLoading];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", JJR_AGREEMENT, self.agreementType];
    NSDictionary *params = @{@"appId": @"JJR"};
    
    [[JJRNetworkService sharedInstance] GET:url 
                                     params:params 
                                    success:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        NSLog(@"🎯 协议内容获取成功: %@", response);
        
        NSString *content = response[@"data"][@"content"];
        if (content) {
            [self loadHTMLContent:content];
        } else {
            [self showAlert:@"协议内容为空"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        NSLog(@"🎯 协议内容获取失败: %@", error.localizedDescription);
        [self showAlert:@"协议内容加载失败"];
    }];
}

- (void)loadHTMLContent:(NSString *)htmlContent {
    // 创建完整的HTML页面
    NSString *fullHTML = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset='utf-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><style>body{font-family:Arial,sans-serif;padding:20px;line-height:1.6;color:#333;}h1,h2,h3{color:#2c3e50;}p{margin-bottom:15px;}</style></head><body>%@</body></html>", htmlContent];
    
    [self.webView loadHTMLString:fullHTML baseURL:nil];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    [self.progressView setProgress:0 animated:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:1.0 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
    });
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    [self showAlert:@"加载失败，请检查网络连接"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        float progress = [change[NSKeyValueChangeNewKey] floatValue];
        [self.progressView setProgress:progress animated:YES];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
