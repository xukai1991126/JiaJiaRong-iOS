#import "WebViewController.h"
#import "JJRNetworkService.h"
#import <WebKit/WebKit.h>

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

- (BOOL)requiresLogin {
    return NO;
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
    // 获取当前视图控制器检查是否在登录页面
    UIViewController *currentVC = [self getCurrentViewController];
    BOOL isInLoginPage = [currentVC isKindOfClass:NSClassFromString(@"LoginViewController")];
    
    if (isInLoginPage) {
        // 如果在登录页面，直接显示默认协议内容，避免token失效的循环问题
        NSLog(@"🎯 在登录页面请求协议，直接显示默认内容");
        [self loadDefaultAgreementContent];
        return;
    }
    
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
            [self loadDefaultAgreementContent];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        NSLog(@"🎯 协议内容获取失败: %@", error.localizedDescription);
        
        // 显示默认协议内容，避免因token问题无法查看协议
        [self loadDefaultAgreementContent];
    }];
}

- (void)loadHTMLContent:(NSString *)htmlContent {
    // 创建完整的HTML页面
    NSString *fullHTML = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset='utf-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><style>body{font-family:Arial,sans-serif;padding:20px;line-height:1.6;color:#333;}h1,h2,h3{color:#2c3e50;}p{margin-bottom:15px;}</style></head><body>%@</body></html>", htmlContent];
    
    [self.webView loadHTMLString:fullHTML baseURL:nil];
}

- (void)loadDefaultAgreementContent {
    NSString *defaultContent = @"";
    
    if ([self.agreementType isEqualToString:@"user"]) {
        defaultContent = @"<h1>用户服务协议</h1><p>感谢您使用佳佳融服务。本协议是您与佳佳融之间关于您使用佳佳融服务所订立的协议。</p><p>1. 服务内容：佳佳融为用户提供融资担保增信服务，协助对接持牌金融机构。</p><p>2. 用户义务：用户应提供真实、准确、完整的个人信息。</p><p>3. 隐私保护：我们严格保护用户个人信息安全。</p><p>4. 服务费用：平台不收取隐藏费用，所有费用透明公开。</p><p>5. 协议修改：我们有权根据需要修改本协议内容。</p>";
    } else if ([self.agreementType isEqualToString:@"privacy"]) {
        defaultContent = @"<h1>隐私协议</h1><p>佳佳融重视用户隐私保护，本隐私协议说明我们如何收集、使用、储存用户信息。</p><p>1. 信息收集：我们收集您提供的身份信息、联系方式等。</p><p>2. 信息使用：收集的信息仅用于提供金融服务。</p><p>3. 信息保护：采用行业标准的安全措施保护用户信息。</p><p>4. 信息共享：不会向第三方出售或提供用户个人信息。</p><p>5. 用户权利：用户有权查询、更正个人信息。</p>";
    } else if ([self.agreementType isEqualToString:@"authorization"]) {
        defaultContent = @"<h1>个人征信查询授权书</h1><p>本人授权佳佳融平台查询本人的个人征信信息，用于风险评估和信用评估。</p><p>1. 授权范围：个人征信报告查询及相关信用信息。</p><p>2. 使用目的：仅用于贷款审批和风险评估。</p><p>3. 信息保护：查询到的征信信息将严格保密。</p><p>4. 授权期限：自签署之日起至业务关系终止。</p><p>5. 法律责任：本人对提供信息的真实性负责。</p>";
    } else {
        defaultContent = @"<h1>协议内容</h1><p>协议内容加载中，请稍后重试。</p>";
    }
    
    [self loadHTMLContent:defaultContent];
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
    [JJRToastTool showError:@"加载失败，请检查网络连接"];
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


// 获取当前显示的视图控制器
- (UIViewController *)getCurrentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // iOS 13及以上版本的处理
    if (!keyWindow) {
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    keyWindow = windowScene.windows.firstObject;
                    break;
                }
            }
        }
    }
    
    UIViewController *rootVC = keyWindow.rootViewController;
    return [self findCurrentViewController:rootVC];
}

- (UIViewController *)findCurrentViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self findCurrentViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)vc;
        return [self findCurrentViewController:navVC.topViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)vc;
        return [self findCurrentViewController:tabVC.selectedViewController];
    } else {
        return vc;
    }
}

@end 
