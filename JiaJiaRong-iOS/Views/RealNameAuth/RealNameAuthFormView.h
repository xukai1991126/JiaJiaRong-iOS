//
//  RealNameAuthFormView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJRRealNameAuthViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol RealNameAuthFormViewDelegate <NSObject>

- (void)formViewDidTapCitySelection;
- (void)formViewDidTapSubmit;

@end

@interface RealNameAuthFormView : UIView

@property (nonatomic, weak) id<RealNameAuthFormViewDelegate> delegate;

- (instancetype)initWithViewModel:(JJRRealNameAuthViewModel *)viewModel;
- (void)updateCityDisplay;

@end

NS_ASSUME_NONNULL_END 