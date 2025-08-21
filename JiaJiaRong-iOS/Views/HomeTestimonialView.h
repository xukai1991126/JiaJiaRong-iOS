//
//  HomeTestimonialView.h
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTestimonialView : UIView

@property (nonatomic, strong) NSArray *testimonialData;

- (void)updateWithTestimonialData:(NSArray *)testimonialData;
- (void)startAutoScroll;
- (void)stopAutoScroll;

@end

NS_ASSUME_NONNULL_END 
