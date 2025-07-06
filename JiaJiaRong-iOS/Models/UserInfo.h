#import "JJRBaseModel.h"

@interface UserInfo : JJRBaseModel

@property (nonatomic, strong) NSString *tk;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, assign) BOOL login;
@property (nonatomic, assign) BOOL form;
@property (nonatomic, assign) BOOL identity;
@property (nonatomic, assign) BOOL authority;
@property (nonatomic, assign) NSInteger audit;

// 用户详细信息
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *idNo;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, assign) BOOL isRealNameAuth;
@property (nonatomic, assign) BOOL isBankCardBind;
@property (nonatomic, assign) BOOL isFormSubmit;

@end 