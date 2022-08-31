
#import <UIKit/UIViewController.h>
#import "PopoverViewController.h"
#import "Tracker.h"

@interface Settings_controller : UITableViewController <UITextFieldDelegate>
@property (nonatomic) long inputDataLimit;
@property (strong, nonatomic) UIColor *bgColor;
@property (nonatomic) BOOL isGB;


@end