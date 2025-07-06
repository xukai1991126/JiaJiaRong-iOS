//
//  JiaJiaRong_iOSUITestsLaunchTests.m
//  JiaJiaRong-iOSUITests
//
//  Created by xk work's computer on 2025/7/5.
//

#import <XCTest/XCTest.h>

@interface JiaJiaRong_iOSUITestsLaunchTests : XCTestCase

@end

@implementation JiaJiaRong_iOSUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
