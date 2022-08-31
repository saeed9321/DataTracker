#import <ControlCenterUIKit/CCUIContentModule.h>
#import <objc/runtime.h>
#import "SDATA_controller.h"

@interface SDATA : NSObject <CCUIContentModule>
//This is what controls the view for the default UIElements that will appear before the module is expanded
@property (nonatomic, readonly) SDATA_controller* contentViewController;
//This is what will control how the module changes when it is expanded
@property (nonatomic, readonly) UIViewController* backgroundViewController;
// @property (nonatomic, readonly) BOOL smallSize;
@end
