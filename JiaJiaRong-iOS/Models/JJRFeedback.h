//
//  JJRFeedback.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRFeedback : JJRBaseModel

@property (nonatomic, copy) NSString *feedbackId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *reply;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *replyTime;

@end

NS_ASSUME_NONNULL_END 