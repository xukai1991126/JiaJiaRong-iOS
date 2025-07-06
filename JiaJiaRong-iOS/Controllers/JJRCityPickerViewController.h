#import <UIKit/UIKit.h>

typedef void(^JJRCitySelectedBlock)(NSString *cityName, NSString *cityCode);

@interface JJRCityPickerViewController : UIViewController

@property (nonatomic, strong) NSArray *hotCities;
@property (nonatomic, strong) NSString *currentCityName;
@property (nonatomic, copy) JJRCitySelectedBlock citySelectedBlock;

@end 