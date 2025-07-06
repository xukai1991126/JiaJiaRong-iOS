#import <UIKit/UIKit.h>

typedef void(^CitySelectedBlock)(NSString *cityName, NSString *cityCode);

@interface CityPickerViewController : UIViewController

@property (nonatomic, strong) NSArray *hotCities;
@property (nonatomic, copy) CitySelectedBlock citySelectedBlock;

@end 