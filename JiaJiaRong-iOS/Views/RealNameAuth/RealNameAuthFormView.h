//
//  RealNameAuthFormView.h
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
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
