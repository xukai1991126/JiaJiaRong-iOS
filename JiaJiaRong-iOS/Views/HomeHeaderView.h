//
//  HomeHeaderView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderView : UIView

@property (nonatomic, strong) NSArray *featureData;

- (void)updateWithFeatureData:(NSArray *)featureData;

@end

NS_ASSUME_NONNULL_END 